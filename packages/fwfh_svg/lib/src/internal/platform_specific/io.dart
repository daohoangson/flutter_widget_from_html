import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_svg/flutter_svg.dart';

PictureProvider? filePicture(
  PictureInfoDecoderBuilder<Uint8List> decoderBuilder,
  String path,
) =>
    FilePicture(decoderBuilder, File(path));
