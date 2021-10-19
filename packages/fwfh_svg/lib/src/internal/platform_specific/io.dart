import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../svg_factory.dart';

PictureProvider? assetPictureProvider(
  SvgFactory wf,
  String assetName,
  String? package,
) =>
    ExactAssetPicture(
      wf.svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgStringDecoderOutsideViewBoxBuilder
          : SvgPicture.svgStringDecoderBuilder,
      assetName,
      package: package,
    );

PictureProvider? memoryPictureProvider(SvgFactory wf, Uint8List bytes) =>
    MemoryPicture(
      wf.svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      bytes,
    );

PictureProvider? networkPictureProvider(SvgFactory wf, String url) =>
    NetworkPicture(
      wf.svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      url,
    );

PictureProvider? filePictureProvider(SvgFactory wf, String path) => FilePicture(
      wf.svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      File(path),
    );

Widget? svgPictureString(String bytes) => SvgPicture.string(bytes);
