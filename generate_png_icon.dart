import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> generatePngIcon() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the SVG
  final svgString = await rootBundle.loadString('assets/images/app_icon.svg');
  
  // Render SVG to memory using modern API
  final PictureInfo pictureInfo = await vg.loadPicture(
    SvgStringLoader(svgString),
    null,
  );

  // Convert to image (high resolution 1024x1024)
  final int size = 1024;
  final ui.Image image = await pictureInfo.picture.toImage(size, size);
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  // Save to file
  if (byteData != null) {
    final Directory currentDir = Directory.current;
    final Directory assetsDir = Directory('${currentDir.path}/assets/images');
    if (!assetsDir.existsSync()) {
      assetsDir.createSync(recursive: true);
    }

    final File pngFile = File('${assetsDir.path}/app_icon.png');
    await pngFile.writeAsBytes(byteData.buffer.asUint8List());
    print('✅ App icon generated successfully: ${pngFile.path}');
  } else {
    print('❌ Failed to convert SVG to PNG');
  }
  
  pictureInfo.picture.dispose();
}

