import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';

BytesLoader? fileLoader(String path) => SvgFileLoader(File(path));
