# Release Runbook

This document describes the actual, empirically-observed release process for this monorepo,
reconstructed from real "Prepare vX releases" commits, `tool/pub-publish.sh`, `tool/pub-get.sh`,
and the packages' own `CHANGELOG.md`/`pubspec.yaml`/`README.md` history. It replaces guesswork
with what the maintainer has actually done, cycle after cycle. Where real history was
inconsistent, this doc says so rather than inventing a clean rule that doesn't exist.

**The versioning of record is each package's own `pubspec.yaml`, not a repo-wide git tag.**
There is no scripted, mandatory tagging step in this process (see "Tagging" below).

**What this runbook does NOT cover:** actually publishing to pub.dev. Preparing a release
(bumping versions, writing changelogs, committing, opening the PR) is a repo-editing task that
anyone/any agent can do. Running `tool/pub-publish.sh` (which calls `flutter pub publish` for
real) is a deliberate, manual action the repo owner takes separately, after the prep PR has been
reviewed and merged. Never run it as part of "preparing" a release.

## Packages, in publish/dependency order

This is the exact order `tool/pub-publish.sh` iterates in, and it matches the dependency graph
(core has no in-repo deps; each `fwfh_*` add-on depends only on core; `enhanced` depends on all
of them):

1. `packages/core` — `flutter_widget_from_html_core`
2. `packages/fwfh_cached_network_image`
3. `packages/fwfh_chewie`
4. `packages/fwfh_just_audio`
5. `packages/fwfh_svg`
6. `packages/fwfh_url_launcher`
7. `packages/fwfh_webview`
8. `packages/enhanced` — `flutter_widget_from_html` (always last: it depends on everything else)

## Step 1: Determine which packages actually need a release

Do NOT blanket-bump every package every cycle. Historically, only packages with real unreleased
changes since their own last release-prep commit get bumped — verified by diffing real "Prepare"
commits (e.g. `078b98b8`, `fc6e7497`, `e54aa9d0`, and the latest one, `f73b7152`): each cycle
only touches the subset of packages that actually changed or were forced to change by dependency
propagation (see below).

For each package:

1. Find its last release-prep commit: `git log --oneline -- packages/<pkg>/CHANGELOG.md` (the
   most recent commit that touched that file is the last time it was released) or
   `git log --oneline --all --grep="^Prepare" -i` for the whole-repo view.
2. Diff everything since then: `git log --oneline --name-only <last-release-sha>..HEAD -- packages/<pkg>/`
3. Classify what you find:
   - Changes under `<pkg>/lib/` or to `<pkg>/pubspec.yaml` → **counts**, needs a release.
   - Changes confined to `<pkg>/test/` → **does NOT count**. `tool/pub-publish.sh` writes
     `/test/` into `.pubignore` before publishing, so the published artifact is byte-identical
     whether or not `test/` changed. (Verified against real commits `04a30856` and `6d1fe830`,
     which only touched `fwfh_chewie/test/` and `fwfh_webview/test/` mock files — no release was
     warranted for those packages from those commits alone.)
   - CI-only (`.github/workflows/*`), `demo_app/`-only, or docs-only changes → does not count.
   - A `README.md` feature-list edit on its own (see AGENTS.md: core/enhanced README feature
     lists must stay in sync) does not itself force a release; it rides along with whatever code
     change it documents.

### Dependency-propagation effects (this is the part that's easy to get wrong)

Two different pinning styles are used in this repo, and they behave very differently:

- **`enhanced`'s `pubspec.yaml`** pins every dependency (core and every `fwfh_*` add-on) with a
  plain caret kept in exact sync with that dependency's current version
  (`flutter_widget_from_html_core: ^0.17.2`, `fwfh_webview: ^0.15.7`, etc.). This caret is bumped
  on **every single release of that dependency, including pure patch bumps** — verified across
  dozens of historical commits (e.g. `ab4bf0e5`: core `0.14.5+1→0.14.6`, a patch, still bumped
  the caret in `enhanced`). **Consequence: `enhanced` needs a new release in every cycle that
  touches any one of its dependencies, even when `enhanced`'s own Dart code hasn't changed at
  all** — its `pubspec.yaml` necessarily changes.

- **Every `fwfh_*` add-on's own `pubspec.yaml`** pins `core` with an explicit exclusive
  upper-bound range instead of a caret, e.g. `flutter_widget_from_html_core: ">=0.8.0 <0.18.0"`.
  Verified directly in `e54aa9d0` ("Prepare v0.17.0 releases"): when core went `0.16.x → 0.17.0`
  (a **minor** bump), every single `fwfh_*` add-on's upper bound moved from `<0.17.0` to
  `<0.18.0` in that same cycle, each with its own patch bump and a boilerplate changelog line
  ("Add support for flutter_widget_from_html_core@0.17.0 (#1475)") — even for add-ons with zero
  other code changes that cycle. **Consequence: a MINOR (or major) bump of `core` forces a patch
  release of every `fwfh_*` add-on purely to widen this range.** A pure **patch** bump of core
  does *not* force this — the existing upper bound already covers it (confirmed: core
  `0.17.0→0.17.2`, a patch-tier change, did not require touching any `fwfh_*` add-on's core
  range).

So the practical algorithm each cycle is:

1. List packages with real, direct, unreleased changes (per the classification above).
2. If `core` is in that list and its bump is a **minor or major**, add every `fwfh_*` add-on to
   the list too (upper-bound widen), even if they have no other changes.
3. `enhanced` is *always* added to the list if anything above is non-empty, because its
   `pubspec.yaml` caret(s) must move.

### Sub-package README version pins

Each `fwfh_*` add-on's own `README.md` shows an install snippet that pins **itself** at a floor
version, e.g. `fwfh_svg: ^0.16.0` even though the actual current version is `0.16.1`+. Per
AGENTS.md and confirmed by real diffs, **this floor is only updated when that package gets a
MINOR bump, never on a patch bump.** (`fwfh_svg`, `fwfh_chewie`, `fwfh_cached_network_image`,
`fwfh_url_launcher` all currently sit at a `^0.16.0` README floor while their real version is
`0.16.1` — correct, do not "fix" this.)

**Documented pitfall, do not repeat:** `fwfh_webview`'s README pin was, for a long stretch of
history (commits between `6854c72f` and `3a3c3329`), incorrectly bumped on every patch release
(`^0.15.0 → ^0.15.1 → ^0.15.2 → ^0.15.3 → ^0.15.4`), contradicting the floor-pin rule every other
add-on followed. It was corrected back down to the true floor (`^0.15.0`) in `078b98b8`
("Prepare v0.17.1 releases"), and every patch release since (`0.15.5`, `0.15.6`, `0.15.7`) has
correctly left it alone. When bumping any `fwfh_*` add-on's patch version, double-check you are
**not** touching its own README pin unless the bump is a minor.

`core` and `enhanced`'s own self-referential README install snippets (`flutter_widget_from_html_core: ^0.17.2`,
`flutter_widget_from_html: ^0.17.2`) show "how to install me," not "the floor of a dependency I
need" — but **they follow the exact same floor-pin rule as every other pin in this repo, no
exception**: update it only when the release crosses into a new minor; leave it alone on a
patch-only bump. The reasoning is identical to Step 2's caret-semantics point — `^0.17.2` already
resolves to `0.17.3` automatically for anyone installing it, so bumping the exact pin on a patch
release changes nothing functionally and is just diff noise.

The two real data points support this as one rule, not two different philosophies:

- `fc6e7497` (core `0.16.0→0.16.1`, patch, same minor) correctly left the README pin untouched.
- `f73b7152` (core `0.17.0→0.17.2`, patch, same minor) updated both `core` and `enhanced`'s pins to
  the exact new version anyway — but this is best read as an accidental blanket-update while
  bumping several packages in one pass (that commit touched three packages' files together), not
  a deliberate policy call. There's no other evidence anywhere in this repo's history of "keep the
  self-pin in exact sync" ever being applied on purpose, it directly contradicts the floor-pin
  logic every other pin in this repo follows, and it's the only such instance across the entire
  history checked. Treat it as the one outlier to avoid repeating, not as precedent.

## Step 2: Decide the version bump

This project's `0.x` packages follow a real, **deterministic rule** — verified with zero
exceptions across every mainline core release from `v0.14.2` through `v0.17.3` by diffing the
actual `environment.flutter` (and `environment.sdk`) constraint in that package's own
`pubspec.yaml`, not just by reading changelog prose (changelog wording can mention a Flutter
version for other reasons — see the caution below):

**Minor bump ⟺ this release changes the package's own `environment.flutter` / `environment.sdk`
floor in its `pubspec.yaml`, compared to its previous release. Patch otherwise, no matter what
else the release contains.**

Confirmed transitions for `core` (`packages/core/pubspec.yaml`, `environment.flutter`):

| Release | Bump | Floor before → after |
| --- | --- | --- |
| `0.14.12 → 0.15.1` | **minor** | `>=3.7.0` → `>=3.10.0` |
| `0.15.2 → 0.16.0` | **minor** | `>=3.10.0` → `>=3.22.0` |
| `0.16.0 → 0.17.0` | **minor** | `>=3.22.0` → `>=3.32.0` |
| `0.14.2` through `0.14.12` (many patch releases) | patch | `>=3.7.0` unchanged throughout |
| `0.15.1 → 0.15.2` | patch | `>=3.10.0` unchanged |
| `0.17.0 → 0.17.2` | patch | `>=3.32.0` unchanged |

Every one of those patch-tier releases still shipped real user-facing changes — including brand
new CSS features (`text-emphasis`/`text-emphasis-style`, `text-decoration-style: wavy`, roman
numerals past 3999, `text-shadow`, flex improvements) and even lines a changelog marks
`BREAKING:` (`v0.14.5`) — none of that mattered to the bump size. Only the `environment.flutter`/
`environment.sdk` floor changing did. This holds because every package here is pre-1.0, and pub's
caret operator treats the *middle* number as the real compatibility boundary for `0.x` versions
(`^0.14.4` resolves to `>=0.14.4 <0.15.0`), which is exactly the boundary a Flutter/SDK floor raise
is meant to signal — a minor bump exists here for exactly one reason, not as a generic "notable
change" signal.

**Caution — check the constraint itself, not the prose:** a package's *own* changelog can mention
a Flutter version for reasons unrelated to its own floor, e.g. citing a bundled dependency's
requirement (`enhanced`'s `v0.16.1`, itself a patch, notes "requires Flutter 3.27" only because
the `just_audio` version it picked up needs that — `enhanced`'s own `environment.flutter` did not
change that release). Always diff `environment.flutter`/`environment.sdk` directly; don't infer
the bump size from whether "Flutter" appears in the changelog text.

Practical guidance:

- **Minor**: only when *this* release raises the package's own `environment.flutter` and/or
  `environment.sdk` floor in its `pubspec.yaml`. Diff that file's `environment:` block against its
  previous release to check — don't guess from the changelog.
- **Patch**: everything else — new backwards-compatible capabilities, any number of bundled
  fixes, dependency-constraint widens (`"Add support for X@Y.Z"`), even a breaking API change (has
  happened; `major` below is the theoretically-correct answer for that, but real history has
  always shipped it as patch instead — flag it explicitly rather than silently following either
  precedent).
- **Major**: reserved for an actual breaking change. Real history has never used it (breaking
  changes have shipped as patch instead, pre-1.0 norms notwithstanding) — treat this as a decision
  to flag for the maintainer, not one to make unilaterally.
- `enhanced` still needs a release whenever any dependency it exact-pins bumps (see the
  propagation rule above) — bump it to at least the same tier as the highest-tier dependency bump
  it's picking up this cycle. Since `enhanced` has no add-on code of its own with a Flutter floor
  to raise independently, this is in practice almost always patch, escalating to minor only when
  one of the dependencies it bundles took a minor (floor-raising) bump this cycle.

## Step 3: Write the CHANGELOG entry

Format, derived from reading many real `CHANGELOG.md` entries across all packages:

```markdown
## 0.17.3

- Add support for standalone CSS `border-*` properties (#1570, authored by @CaptainDario)
- Add support for 3-value CSS shorthand for `margin` and `padding` (#1577)
- Fix `text-align` handling for `<li>` content layout (#1578)
```

- New version header is `## X.Y.Z` (or `## X.Y.Z+N` for a build number), inserted at the very
  top of the file, above the previous newest entry. No date, no other metadata in the header.
- Convention leans toward listing `Add`/feature-style bullets before `Fix` bullets, but this is
  not strictly enforced in older history — some entries are closer to PR-merge chronological
  order. Recent releases (e.g. `0.17.2`) group them cleanly; do that when you can.
- Cite the PR number in parentheses: `(#1234)`.
- Credit external human contributors with `(#1234, authored by @username)`. Repeat contributors
  in the same release sometimes get a flourish (`also by @ngthailam 🎉`, `another one by
  @anttileppa 🔥🔥🔥🔥`) — optional, not required.
- **AI/bot co-authors are never credited in the CHANGELOG.** Many real commits carry a
  `Co-authored-by: Claude ...` or `copilot-swe-agent[bot]` trailer; none of that ever surfaces in
  any CHANGELOG entry. Only human external contributors get an "authored by" credit; the
  maintainer's own commits (AI-assisted or not) get none.
- **If you can't confidently resolve a contributor's GitHub handle** (e.g. their commit email
  isn't a GitHub noreply address and you have no other way to look it up), omit the credit
  entirely rather than guess. Do not fabricate a `@username`.
- `enhanced`'s CHANGELOG entry for a given version **aggregates the user-facing bullets from
  every package it bundles that changed that cycle** (since `enhanced` re-exports everything),
  plus anything specific to `enhanced` itself. This is consistent across every historical
  release: e.g. `v0.17.0`'s `enhanced` entry repeats `core`'s "Fix `text-align: center` inside
  tables" bullet verbatim, plus adds bullets sourced from `fwfh_just_audio`, `fwfh_chewie`, and
  `fwfh_webview`'s own changelogs for that cycle.
- A pure "widen an upstream range" patch for an `fwfh_*` add-on gets a one-line entry:
  `Add support for <plugin>@<version> (#PR)`.

## Step 4: Commit shape

**One atomic commit per bumped package. Never one combined commit for the whole release.** This
is the real historical shape, confirmed by reading the individual "Prepare" commits' messages —
each squash-merged PR's final commit message lists exactly one line per package it bumped:

```
Prepare v0.17.0 releases (#1476)

* [core] v0.17.0
* [fwfh_cached_network_image] v0.16.1
* [fwfh_chewie] v0.16.1
* [fwfh_just_audio] v0.17.0
* [fwfh_svg] v0.16.1
* [fwfh_url_launcher] v0.16.1
* [fwfh_webview] v0.15.5
* [enhanced] v0.17.0
```

Each of those lines was originally its own commit on the PR branch before GitHub squash-merged
them into one. Reproduce that: **one commit per package, message `[<package_short_name>] vX.Y.Z`**
(e.g. `[core] v0.17.3`, `[fwfh_webview] v0.15.7`, `[enhanced] v0.17.3`), each touching only that
package's own directory (`pubspec.yaml`, `CHANGELOG.md`, and its own `README.md` self-pin if
applicable). The commit for `enhanced` is the one that updates `enhanced`'s dependency
constraints on everything it bundles, since those lines live inside `enhanced/pubspec.yaml`.

Commit order should follow the publish/dependency order above (core, then the `fwfh_*` add-ons
that need it, then `enhanced` last).

### PR title

Two title formats are both established, real convention — either is fine, pick one:

```
Prepare vX.Y.Z releases
```

Confirmed across ~20+ real "Prepare" PRs from `v0.6.0` through `v0.17.1`, where `X.Y.Z` is
**`enhanced`'s new version** (verified: every single historical example uses enhanced's version
number here, never core's or any add-on's).

```
chore: Release vX.Y.Z
```

Used for `v0.17.2` (`f73b7152`) and again for `v0.17.3` (the release this runbook itself shipped
in, PR #1622) — two independent real instances is a real, established pattern going forward, not
a one-off to avoid. Same `X.Y.Z` = `enhanced`'s new version rule applies.

An optional trailing "Update files" style commit for regenerated lockfiles is sometimes present
(e.g. a `demo_app/pubspec.lock` re-resolved by `./tool/pub-get.sh` for the bumped packages only,
or fully refreshed by `./tool/pub-upgrade.sh` when a broader dependency update is intended) but
is **not scripted anywhere and not required** — some real Prepare cycles include it, several
don't. Do not confuse this with `tool/update-demo_app-files.sh`, which is a
completely unrelated script that regenerates `demo_app`'s native platform scaffolding
(`android/ios/macos/web`) — it has nothing to do with versioning and is not part of this
workflow.

## Step 5: Open the PR, get it reviewed, merge

Normal GitHub PR flow. This runbook does not prescribe a specific CLI for this step.

## Step 6: Publish (NOT automated by this runbook — manual, owner-only, after merge)

`tool/pub-publish.sh` is the real mechanical publish script, run **by the repo owner, after the
prep PR has merged to `master`** — never as part of preparing the release, and never by an
agent unless a human has explicitly asked for that exact action. For each package, in the
dependency order above, it:

1. Verifies the package's working directory is clean (skips with a warning if not).
2. Reads `name`/`version` from `pubspec.yaml` via `yq` and checks pub.dev
   (`https://pub.dev/packages/<name>/versions/<version>`) — **skips the package if that exact
   version is already published.** This is what makes it safe to run repeatedly / makes
   "some packages didn't change this cycle" a non-issue.
3. Strips `dependency_overrides` from `pubspec.yaml` (pub.dev rejects packages with those
   present), runs `flutter clean && flutter pub get`, and runs `flutter test` if a `test/`
   directory exists.
4. Builds a `.pubignore` from `.gitignore` plus `/test/` (so tests never ship), strips the
   `flutter:` key from `pubspec.yaml`.
5. Runs `flutter pub publish` for real.
6. Reverts all local changes (`git checkout .`) and removes the generated `.pubignore`.

`tool/pub-get.sh` is a different, sibling script — it just runs `flutter pub get` across every
package and `demo_app`, preserving existing `pubspec.lock` resolutions where they're still
compatible with the manifests. (`tool/pub-upgrade.sh` is the sibling that instead runs
`flutter pub upgrade` everywhere, refreshing resolutions within the declared constraints.)
`pub-get.sh` is useful for sanity-checking that a bump resolves correctly before committing,
but **it is not itself a release step** and doesn't touch versions, changelogs, or publish
anything.

## Tagging: NOT current practice — do not invent it

There is no tagging step anywhere in `tool/pub-publish.sh`, `tool/pub-get.sh`, or any GitHub
Actions workflow. **The versioning of record is each package's own `pubspec.yaml`.** Historical
tags exist in this repo up through `v0.9.1` and, unusually, resume again for the two most recent
releases (`v0.17.1`, `v0.17.2`) — those two appear to have been created ad hoc by whoever
prepared that release, not by any scripted or documented step, and should not be read as
"tagging is now the process." Do not add a step to this runbook (or to your own release work)
that tags and pushes `git tag vX.Y.Z` as if it were an established, required part of the
pipeline — it isn't, per the actual tooling.

**Recommendation (not current practice):** if a future maintainer wants git tags back as a
matter of course, that would be a reasonable improvement (it gives a stable ref per release,
useful for changelogs/diffing), but it should be a deliberate, explicit decision — e.g. adding an
actual step to `tool/pub-publish.sh` or a follow-up in CI — not something quietly reintroduced
one release at a time.

## Quick checklist

- [ ] For every package (`core`, `enhanced`, all `fwfh_*`), diff since its last release-prep
      commit; classify changes (lib/pubspec vs. test-only vs. CI/demo_app-only).
- [ ] Apply dependency-propagation rules: core minor/major bump → all `fwfh_*` add-ons need a
      patch; anything changing → `enhanced` needs a release.
- [ ] Pick version bumps: minor only for an SDK/Flutter floor raise; patch otherwise.
- [ ] Write CHANGELOG entries (features before fixes where practical; credit humans only;
      `enhanced` aggregates everything it bundles).
- [ ] Update every README floor pin (sub-package dependency pins, and core/enhanced's own
      self-pin alike) only when that package's bump crosses into a new minor; leave alone on a
      patch-only bump.
- [ ] One commit per bumped package, `[pkg] vX.Y.Z`, in dependency order.
- [ ] Open PR titled `Prepare vX.Y.Z releases` or `chore: Release vX.Y.Z` (X.Y.Z = enhanced's new version) — both are established convention.
- [ ] After merge, the repo owner runs `tool/pub-publish.sh` manually — this runbook stops here.
