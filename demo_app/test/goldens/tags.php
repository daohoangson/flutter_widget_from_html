<?php

$json = file_get_contents('../goldens.json');
$map = json_decode($json, true);

$tagTests = [];
foreach ($map as $test => $html) {
  // test names are formatted as "tag1,tag2,..."
  $tags = explode(',', $test);

  if (strpos($test, '/') !== false) {
    if (substr($test, 0, 4) === 'tag/') {
      // for "tag/xxx/*" test cases, take xxx as tag
      $parts = explode('/', $test);
      $tags = [$parts[1]];
    } else {
      // ignore deep test cases
      continue;
    }
  }

  // replace asset path with URL for proper browser rendering
  $html = str_replace('asset:logos/android.png', 'https://github.com/daohoangson/flutter_widget_from_html/raw/master/demo_app/logos/android.png', $html);

  foreach ($tags as $tag) {
    if (!isset($tagTests[$tag])) $tagTests[$tag] = [];
    $tagTests[$tag][$test] = $html;
  }
}

echo('<!doctype html>');
echo('<html lang="en">');
echo('<head>');
echo('<meta charset="utf-8">');
echo('<title>flutter_widget_from_html Supported Tags</title>');
echo('<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">');
echo('<style>body { font-family: Roboto, sans-serif; }</style>');
echo('<style>.html { font-size: 14px; margin: 10px; }</style>');
echo('</head>');
echo('<body>');
echo("<table border=\"1\" cellpadding=\"4\" style=\"border-collapse: collapse\">\n");
echo("<tr><th></th><th>Tag</th><th>Flutter rendering</th><th>Browser rendering</th></tr>\n");

ksort($tagTests);
$tags = array_keys($tagTests);
for ($i = 0; $i < count($tags); $i++) {
  $no = $i + 1;
  $tag = $tags[$i];
  $tests = array_keys($tagTests[$tag]);
  $rowspan = count($tests);
  $test0 = $tests[0];
  $html0 = $tagTests[$tag][$test0];

  echo("<tr>\n");
  echo("  <td rowspan=\"$rowspan\"><center>$no</center></td>\n");
  echo("  <td rowspan=\"$rowspan\"><var>$tag</var></td>\n");
  echo("  <td><img src=\"$test0.png\" /></td>\n");
  echo("  <td valign=\"bottom\"><div class=\"html\">$html0</div></td>\n");
  echo("</tr>\n");

  if ($rowspan > 1) {
    foreach ($tagTests[$tag] as $test => $html) {
      if ($test === $test0) continue;

      echo("<tr>\n");
      echo("  <td><img src=\"$test.png\" /></td>\n");
      echo("  <td valign=\"bottom\"><div class=\"html\">$html</div></td>\n");
      echo("</tr>\n");
    }
  }
}

echo("</table>\n");
echo('</body>');
