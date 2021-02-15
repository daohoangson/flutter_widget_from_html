import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:path_provider/path_provider.dart';

class ImgFileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'PNG'),
                Tab(text: 'SVG'),
              ],
            ),
            title: Text('ImgFileScreen'),
          ),
          body: TabBarView(
            children: <Widget>[
              _ImgFileTab(
                assetKey: 'logos/android.png',
                fileExtension: 'png',
              ),
              _ImgFileTab(
                assetKey:
                    'packages/flutter_widget_from_html/test/images/logo.svg',
                fileExtension: 'svg',
              ),
            ],
          ),
        ),
      );
}

class _ImgFileTab extends StatefulWidget {
  final String assetKey;
  final String fileExtension;

  const _ImgFileTab({
    @required this.assetKey,
    @required this.fileExtension,
    Key key,
  }) : super(key: key);

  @override
  State<_ImgFileTab> createState() => _ImgFileState();
}

class _ImgFileState extends State<_ImgFileTab> {
  final status = ValueNotifier(_ImgFileStatus.idle);

  Future<File> get file async {
    final directory = await getApplicationSupportDirectory();
    return File(
        '${directory.path}/img_file--$hashCode.${widget.fileExtension}');
  }

  @override
  Widget build(BuildContext _) => AnimatedBuilder(
        animation: status,
        builder: (_, __) {
          switch (status.value) {
            case _ImgFileStatus.idle:
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'This test will write a ${widget.fileExtension} file into '
                      'the device\'s file system then try to render with an IMG tag. '
                      'The actual file path is semi-random and it should be '
                      'unique across tests (switch tab to test again and again).',
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text('Write file'),
                      onPressed: _writeFile,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              );
            case _ImgFileStatus.writeFileWriting:
              return const Center(child: CircularProgressIndicator());
            case _ImgFileStatus.writeFileSuccess:
              return FutureBuilder<File>(
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final file = snapshot.data;
                  final html = '<img src="file://${file.path}" />';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(html),
                        HtmlWidget(html),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  );
                },
                future: file,
              );
            case _ImgFileStatus.writeFileError:
              return const Center(child: Text('Unable to write file'));
          }

          return const SizedBox.shrink();
        },
      );

  void _writeFile() async {
    assert(status.value == _ImgFileStatus.idle);
    status.value = _ImgFileStatus.writeFileWriting;

    ByteData data;
    try {
      data = await rootBundle.load(widget.assetKey);
    } catch (e) {
      print(e);
      status.value = _ImgFileStatus.writeFileError;
      return;
    }

    final buffer = data.buffer;
    try {
      await (await file).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    } catch (e) {
      print(e);
      status.value = _ImgFileStatus.writeFileError;
      return;
    }

    status.value = _ImgFileStatus.writeFileSuccess;
  }
}

enum _ImgFileStatus {
  idle,
  writeFileWriting,
  writeFileSuccess,
  writeFileError,
}
