import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path_provider/path_provider.dart';

class ImgFileScreen extends StatefulWidget {
  @override
  _ImgFileScreenState createState() => _ImgFileScreenState();
}

class _ImgFileScreenState extends State<ImgFileScreen> {
  final status = ValueNotifier(_ImgFileStatus.idle);

  Future<File> get file async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/img_file--$hashCode.png');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('ImgFileScreen')),
        body: AnimatedBuilder(
          animation: status,
          builder: (_, __) {
            switch (status.value) {
              case _ImgFileStatus.idle:
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'This test will write an image into the device\'s file system '
                        'then try to render it using a file:// src in an IMG tag. '
                        'The actual file path is semi-random and it should be '
                        'unique across tests '
                        '(go back home then reopen this screen to test again).',
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
        ),
      );

  void _writeFile() async {
    assert(status.value == _ImgFileStatus.idle);
    status.value = _ImgFileStatus.writeFileWriting;

    ByteData data;
    try {
      data = await rootBundle.load('logos/android.png');
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
