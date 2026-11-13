import 'package:just_audio/just_audio.dart';

/// Awaits [load] and ignores [PlayerInterruptedException] only when the
/// caller is no longer mounted.
///
/// Any other error is rethrown. An interruption while [isMounted] is true
/// is rethrown as well.
Future<void> guardAudioSourceLoad(
  Future<void> load, {
  required bool Function() isMounted,
}) async {
  try {
    await load;
  } on PlayerInterruptedException {
    if (isMounted()) {
      rethrow;
    }
  }
}
