import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:tinhte_html_widget/config.dart';
import 'package:tinhte_html_widget/widget_factory.dart';

void main() {
  group('WidgetFactory', () {
    WidgetFactory widgetFactory;

    setUp(() => widgetFactory = WidgetFactory());

    group('buildFullUrl', () {
      test('http url', () {
        final httpUrl = 'http://http.domain.com/image.jpg';
        final built = widgetFactory.buildFullUrl(httpUrl);
        expect(built, equals(httpUrl));
      });

      test('https url', () {
        final httpUrl = 'https://https.domain.com/image.jpg';
        final built = widgetFactory.buildFullUrl(httpUrl);
        expect(built, equals(httpUrl));
      });

      test('protocol-relative url', () {
        final protocolRelativeUrl = '//protocol-relative.domain.com/image.jpg';

        final httpsWf = WidgetFactory(config: Config(baseUrl: Uri.parse('https://domain.com')));
        final httpsBuilt = httpsWf.buildFullUrl(protocolRelativeUrl);
        expect(httpsBuilt, equals("https:$protocolRelativeUrl"));

        final httpWf = WidgetFactory(config: Config(baseUrl: Uri.parse('http://domain.com')));
        final httpBuilt = httpWf.buildFullUrl(protocolRelativeUrl);
        expect(httpBuilt, equals("http:$protocolRelativeUrl"));
      });

      var testBaseUrls = (String path) {
        final baseUrls = [
          'http://domain.com',
          'http://domain.com/',
          'http://domain.com/path',
          'http://domain.com/path/',
          'http://domain.com:123',
          'http://domain.com:123/',
          'http://domain.com:123/path',
          'http://domain.com:123/path/',
        ];
        final results = baseUrls.map((baseUrl) {
          final wf = WidgetFactory(config: Config(baseUrl: Uri.parse(baseUrl)));
          return wf.buildFullUrl(path);
        });

        return results.toList(growable: false);
      };

      group('relative path', () {
        final relativePath = 'relative/image.jpg';

        test('without baseUrl', () {
          final built = widgetFactory.buildFullUrl(relativePath);
          expect(built, isNull);
        });

        test('with baseUrls', () {
          final builts = testBaseUrls(relativePath);
          expect(
              builts,
              equals([
                'http://domain.com/relative/image.jpg',
                'http://domain.com/relative/image.jpg',
                'http://domain.com/path/relative/image.jpg',
                'http://domain.com/path/relative/image.jpg',
                'http://domain.com:123/relative/image.jpg',
                'http://domain.com:123/relative/image.jpg',
                'http://domain.com:123/path/relative/image.jpg',
                'http://domain.com:123/path/relative/image.jpg',
              ]));
        });
      });

      group('absolute path', () {
        final absolutePath = '/absolute/image.jpg';

        test('without baseUrl', () {
          final built = widgetFactory.buildFullUrl(absolutePath);
          expect(built, isNull);
        });

        test('with baseUrls', () {
          final builts = testBaseUrls(absolutePath);
          expect(
              builts,
              equals([
                'http://domain.com/absolute/image.jpg',
                'http://domain.com/absolute/image.jpg',
                'http://domain.com/absolute/image.jpg',
                'http://domain.com/absolute/image.jpg',
                'http://domain.com:123/absolute/image.jpg',
                'http://domain.com:123/absolute/image.jpg',
                'http://domain.com:123/absolute/image.jpg',
                'http://domain.com:123/absolute/image.jpg',
              ]));
        });
      });
    });

    group('buildImageBytes', () {
      test('decodes ok', () {
        ['gif', 'jpeg', 'png'].forEach((type) {
          final dataUri = "data:image/$type;base64,MTIz";
          final bytes = widgetFactory.buildImageBytes(dataUri);
          expect(bytes, equals(utf8.encode('123')));
        });
      });

      test('fails for empty string', () {
        final bytes = widgetFactory.buildImageBytes('');
        expect(bytes, isNull);
      });

      test('fails for invalid string', () {
        final bytes = widgetFactory.buildImageBytes('123');
        expect(bytes, isNull);
      });

      test('fails for empty data', () {
        final bytes = widgetFactory.buildImageBytes('data:image/png;base64,');
        expect(bytes, isNull);
      });
    });
  });
}
