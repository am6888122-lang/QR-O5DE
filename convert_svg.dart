import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Read the SVG file
    final ByteData svgData = await rootBundle.load(
      'assets/images/app_icon.svg',
    );
    final Uint8List svgBytes = svgData.buffer.asUint8List();

    // Create a temporary directory for processing
    final Directory tempDir = await getTemporaryDirectory();
    final File svgFile = File('${tempDir.path}/app_icon.svg');
    await svgFile.writeAsBytes(svgBytes);

    // Load SVG as Picture
    final svgString = await svgFile.readAsString();
    
    // Modern flutter_svg API
    final PictureInfo pictureInfo = await vg.loadPicture(
      SvgStringLoader(svgString),
      null,
    );

    // Render SVG to PNG with high resolution
    final int size = 1024;
    final ui.Image image = await pictureInfo.picture.toImage(size, size);

    // Convert to PNG bytes
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    
    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to assets directory
      final Directory currentDir = Directory.current;
      final Directory assetsDir = Directory('${currentDir.path}/assets/images');
      if (!assetsDir.existsSync()) {
        assetsDir.createSync(recursive: true);
      }

      final File pngFile = File('${assetsDir.path}/app_icon.png');
      await pngFile.writeAsBytes(pngBytes);

      print('✅ App icon generated successfully: ${pngFile.path}');
    } else {
      print('❌ Failed to convert SVG to PNG');
    }
    
    pictureInfo.picture.dispose();
  } catch (e) {
    print('❌ Error: $e');
  }
}

