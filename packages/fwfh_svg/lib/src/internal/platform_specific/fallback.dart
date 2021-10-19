import 'dart:typed_data';

import 'package:flutter_svg/flutter_svg.dart';

import '../../svg_factory.dart';

PictureProvider? assetPictureProvider(
  SvgFactory wf,
  String assetName,
  String? package,
) =>
    null;

PictureProvider? memoryPictureProvider(SvgFactory wf, Uint8List bytes) => null;

PictureProvider? networkPictureProvider(SvgFactory wf, String url) => null;

PictureProvider? filePictureProvider(SvgFactory wf, String path) => null;

PictureProvider? stringPicture(SvgFactory wf, String string) => null;
