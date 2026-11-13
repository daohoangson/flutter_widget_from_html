import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_just_audio/src/internal/guard_audio_source_load.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  test('swallows PlayerInterruptedException when unmounted', () async {
    final gate = Completer<void>();
    final load = guardAudioSourceLoad(
      gate.future,
      isMounted: () => false,
    );

    gate.completeError(PlayerInterruptedException('disposed'));

    await load;
  });

  test('rethrows PlayerInterruptedException while mounted', () async {
    final gate = Completer<void>();
    final load = guardAudioSourceLoad(
      gate.future,
      isMounted: () => true,
    );

    gate.completeError(PlayerInterruptedException('still mounted'));

    await expectLater(load, throwsA(isA<PlayerInterruptedException>()));
  });

  test('does not swallow other errors after unmount', () async {
    final gate = Completer<void>();
    final load = guardAudioSourceLoad(
      gate.future,
      isMounted: () => false,
    );

    gate.completeError(StateError('platform failed'));

    await expectLater(load, throwsA(isA<StateError>()));
  });
}
