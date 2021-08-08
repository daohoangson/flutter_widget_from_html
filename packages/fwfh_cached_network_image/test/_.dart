import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/memory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:mocktail/mocktail.dart';

import '../../core/test/_.dart' as helper;

const kDataUri = helper.kDataUri;

String? cachedNetworkImageExplainer(helper.Explainer parent, Widget widget) {
  if (widget is CachedNetworkImage) {
    return '[CachedNetworkImage:imageUrl=${widget.imageUrl}]';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool useExplainer = true,
}) async {
  await helper.explain(
    tester,
    null,
    explainer: cachedNetworkImageExplainer,
    hw: HtmlWidget(
      html,
      key: helper.hwKey,
      factoryBuilder: () => _WidgetFactory(),
    ),
    useExplainer: useExplainer,
  );

  await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 10)));
  await tester.pump();

  return helper.explainWithoutPumping(
    explainer: cachedNetworkImageExplainer,
    useExplainer: useExplainer,
  );
}

class _MockCacheManager extends Mock implements CacheManager {}

class _WidgetFactory extends WidgetFactory with CachedNetworkImageFactory {
  @override
  BaseCacheManager? get cacheManager {
    final manager = _MockCacheManager();
    final ttl = DateTime.now().add(const Duration(days: 1));

    when(() => manager.getFileStream(
          any(),
          headers: any(named: 'headers'),
          withProgress: any(named: 'withProgress'),
        )).thenAnswer((invocation) async* {
      final String url = invocation.positionalArguments[0];
      final uri = Uri.parse(url);
      final fileName = uri.pathSegments.last;

      switch (fileName) {
        case 'transparent.gif':
          final data = base64Decode(helper.kDataBase64);
          final file = MemoryFileSystem().file(fileName)
            ..writeAsBytesSync(data.toList(growable: false));
          yield FileInfo(file, FileSource.Cache, ttl, url);
          break;
        case 'error.jpg':
          final file = MemoryFileSystem().file(fileName)..writeAsStringSync('');
          yield FileInfo(file, FileSource.Cache, ttl, url);
      }
    });

    return manager;
  }

  @override
  Widget imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
    ImageSource src,
  ) {
    if (loadingProgress == null) return child;
    return const CircularProgressIndicator.adaptive();
  }
}
