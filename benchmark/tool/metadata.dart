import 'dart:convert';
import 'dart:io';

const _flutterFields = [
  'frameworkVersion',
  'channel',
  'frameworkRevision',
  'frameworkCommitDate',
  'engineRevision',
  'engineCommitDate',
  'engineContentHash',
  'engineBuildDate',
  'dartSdkVersion',
  'devToolsVersion',
];

const _platforms = {
  'darwin',
  'linux-arm64',
  'linux-riscv64',
  'linux-x64',
  'web-javascript',
};

Future<void> main(List<String> arguments) async {
  final input = jsonDecode(await stdin.transform(utf8.decoder).join());
  final output = switch (arguments) {
    ['flutter'] => filterFlutterVersion(input as Map<String, Object?>),
    ['device', final id] => sanitizeDevice(
      input as List<Object?>,
      id,
      osVersion: hostOsVersion(),
      architecture: hostArchitecture(),
    ),
    _ => throw ArgumentError('Use: metadata.dart flutter|device <id>'),
  };
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(output));
}

Map<String, Object?> filterFlutterVersion(Map<String, Object?> input) => {
  for (final field in _flutterFields)
    if (input[field] case final value?) field: value,
};

Map<String, Object?> sanitizeDevice(
  List<Object?> input,
  String id, {
  required String osVersion,
  required String architecture,
}) {
  final device = input.whereType<Map<String, Object?>>().singleWhere(
    (candidate) => candidate['id'] == id,
  );
  final platform = device['targetPlatform'];
  if (platform is! String || !_platforms.contains(platform)) {
    throw FormatException('Unsupported target platform: $platform');
  }

  final browserVersion = id == 'chrome'
      ? RegExp(r'\d+(?:\.\d+)+').firstMatch('${device['sdk']}')?.group(0)
      : null;
  return {
    'platform': platform,
    'osVersion': osVersion,
    'architecture': architecture,
    if (browserVersion != null) 'browserVersion': browserVersion,
  };
}

String hostOsVersion() {
  if (Platform.isMacOS) {
    return _versionFromCommand('sw_vers', ['-productVersion']);
  }
  if (Platform.isLinux) {
    for (final line in File('/etc/os-release').readAsLinesSync()) {
      if (line.startsWith('VERSION_ID=')) {
        return _safeToken(
          line.substring('VERSION_ID='.length).replaceAll('"', ''),
        );
      }
    }
  }
  if (Platform.isWindows) {
    return _versionFromCommand('cmd', ['/c', 'ver']);
  }
  return _numericVersion(Platform.operatingSystemVersion);
}

String hostArchitecture() {
  final result = Process.runSync('uname', ['-m']);
  if (result.exitCode != 0) return 'unknown';
  return switch (_safeToken('${result.stdout}'.trim())) {
    'aarch64' => 'arm64',
    'x86_64' => 'x64',
    final architecture => architecture,
  };
}

String _versionFromCommand(String executable, List<String> arguments) {
  final result = Process.runSync(executable, arguments);
  if (result.exitCode != 0) return 'unknown';
  return _numericVersion('${result.stdout}');
}

String _numericVersion(String value) =>
    RegExp(r'\d+(?:\.\d+)+').firstMatch(value)?.group(0) ?? 'unknown';

String _safeToken(String value) =>
    RegExp(r'^[A-Za-z0-9._+-]+$').hasMatch(value) ? value : 'unknown';
