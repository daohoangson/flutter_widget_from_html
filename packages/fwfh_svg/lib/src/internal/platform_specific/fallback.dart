import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

PictureProvider? assetPictureProvider(String assetName, String? package) =>
    null;

PictureProvider? memoryPictureProvider(Uint8List bytes) => null;

PictureProvider? networkPictureProvider(String url) => null;

PictureProvider? filePictureProvider(String path) => null;

Widget? svgPictureString(String bytes) => null;
