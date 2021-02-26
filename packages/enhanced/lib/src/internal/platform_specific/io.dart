import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';

PictureProvider filePictureProvider(String path) =>
    FilePicture(SvgPicture.svgByteDecoder, File(path));
