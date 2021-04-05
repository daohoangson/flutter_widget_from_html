import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

PictureProvider? assetPictureProvider(String assetName, String? package) =>
    ExactAssetPicture(SvgPicture.svgStringDecoder, assetName, package: package);

PictureProvider? memoryPictureProvider(Uint8List bytes) =>
    MemoryPicture(SvgPicture.svgByteDecoder, bytes);

PictureProvider? networkPictureProvider(String url) =>
    NetworkPicture(SvgPicture.svgByteDecoder, url);

PictureProvider? filePictureProvider(String path) =>
    FilePicture(SvgPicture.svgByteDecoder, File(path));

Widget? svgPictureString(String bytes) => SvgPicture.string(bytes);
