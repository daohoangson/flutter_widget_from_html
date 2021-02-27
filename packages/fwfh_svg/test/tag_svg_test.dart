import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '_.dart' as helper;

final svgBytes = utf8.encode('<svg viewBox="0 0 1 1"></svg>');

void main() {
  final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  testWidgets('renders asset picture', (WidgetTester tester) async {
    final assetName = 'test/images/logo.svg';
    final html = '<img src="asset:$assetName" />';
    final explained = await helper.explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=ExactAssetPicture(name: "$assetName", bundle: null, colorFilter: null)'
          ']]'),
    );
  });

  testWidgets('renders file picture', (WidgetTester tester) async {
    final filePath = '${Directory.current.path}/test/images/logo.svg';
    final html = '<img src="file://$filePath" />';
    final explained = await helper.explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=FilePicture("$filePath", colorFilter: null)'
          ']]'),
    );
  });

  group('MemoryPicture', () {
    final explain = (WidgetTester tester, String html) => helper
        .explain(tester, html)
        .then((e) => e.replaceAll(RegExp(r'\(Uint8List#.+\)'), '(bytes)'));

    testWidgets('renders base64', (WidgetTester tester) async {
      final base64 = base64Encode(svgBytes);
      final html = '<img src="data:image/svg+xml;base64,$base64" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
              ']'));
    });

    testWidgets('renders utf8', (WidgetTester tester) async {
      final utf8 = '&lt;svg viewBox=&quot;0 0 1 1&quot;&gt;&lt;/svg&gt;';
      final html = '<img src="data:image/svg+xml;utf8,$utf8" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
              ']'));
    });
  });

  testWidgets('renders network picture', (WidgetTester tester) async {
    final src = 'http://domain.com/image.svg';
    final html = '<img src="$src" />';
    final explained = await HttpOverrides.runZoned(
      () => helper.explain(tester, html),
      createHttpClient: (_) => _createMockSvgImageHttpClient(),
    );
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=NetworkPicture("$src", headers: null, colorFilter: null)'
          ']]'),
    );
  });
}

class _MockHttpClient extends Mock implements HttpClient {
  @override
  set autoUncompress(bool _autoUncompress) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createMockSvgImageHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();

  when(client)
      .calls(#getUrl)
      .withArgs(positional: [any]).thenAnswer((_) async => request);
  when(request).calls(#headers).thenReturn(headers);
  when(request).calls(#close).thenAnswer((_) async => response);
  when(response)
      .calls(#compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(response).calls(#contentLength).thenReturn(svgBytes.length);
  when(response).calls(#statusCode).thenReturn(HttpStatus.ok);
  when(response).calls(#listen).thenAnswer((invocation) {
    final onData =
        invocation.positionalArguments[0] as void Function(List<int>);
    return Stream.fromIterable(<List<int>>[svgBytes]).listen(onData);
  });

  return client;
}
