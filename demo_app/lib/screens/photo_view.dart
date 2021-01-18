import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:photo_view/photo_view.dart';

import 'custom_widget_builder.dart' as custom_widget_builder;

class PhotoViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Inline'),
                Tab(text: 'Popup'),
              ],
            ),
            title: Text('PhotoViewScreen'),
          ),
          body: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    custom_widget_builder.kHtml,
                    factoryBuilder: () => _InlinePhotoViewWidgetFactory(),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    custom_widget_builder.kHtml,
                    factoryBuilder: () => _PopupPhotoViewWidgetFactory(),
                  ),
                ),
              ),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
        length: 2,
      );
}

class _InlinePhotoViewWidgetFactory extends WidgetFactory {
  @override
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata data) {
    if (provider is ImageProvider) {
      return AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: ClipRect(
          child: PhotoView(
            imageProvider: provider,
          ),
        ),
      );
    }

    return super.buildImage(meta, provider, data);
  }

  @override
  void parse(BuildMetadata meta) {
    if (meta.element.classes.contains('image')) {
      meta['margin'] = '1em 0';
    }

    super.parse(meta);
  }
}

class _PopupPhotoViewWidgetFactory extends WidgetFactory {
  @override
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata data) {
    final built = super.buildImage(meta, provider, data);

    if (provider is ImageProvider) {
      final heroTag = data.sources.first.url;

      return Builder(
        builder: (context) => GestureDetector(
          child: Hero(
            child: built,
            tag: heroTag,
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => Scaffold(
                    appBar: AppBar(),
                    body: Container(
                      child: PhotoView(
                        heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                        imageProvider: provider,
                      ),
                    ),
                  ))),
        ),
      );
    }

    return built;
  }

  @override
  void parse(BuildMetadata meta) {
    if (meta.element.classes.contains('image')) {
      meta['margin'] = '1em 0';
    }

    super.parse(meta);
  }
}
