import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final svgString = '''
<svg width="1024" height="1024" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4A90E2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#9013FE;stop-opacity:1" />
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur in="SourceAlpha" stdDeviation="20"/>
      <feOffset dx="0" dy="10" result="offsetblur"/>
      <feComponentTransfer>
        <feFuncA type="linear" slope="0.3"/>
      </feComponentTransfer>
      <feMerge> 
        <feMergeNode/>
        <feMergeNode in="SourceGraphic"/> 
      </feMerge>
    </filter>
  </defs>
  
  <rect width="1024" height="1024" rx="160" fill="url(#bgGrad)" filter="url(#shadow)"/>
  
  <g transform="translate(256, 256)" scale="2">
    <rect x="0" y="0" width="128" height="128" fill="white" rx="10"/>
    <rect x="16" y="16" width="96" height="96" fill="#4A90E2" rx="8"/>
    <rect x="32" y="32" width="64" height="64" fill="white" rx="6"/>
    
    <rect x="256" y="0" width="128" height="128" fill="white" rx="10"/>
    <rect x="272" y="16" width="96" height="96" fill="#4A90E2" rx="8"/>
    <rect x="288" y="32" width="64" height="64" fill="white" rx="6"/>
    
    <rect x="0" y="256" width="128" height="128" fill="white" rx="10"/>
    <rect x="16" y="272" width="96" height="96" fill="#4A90E2" rx="8"/>
    <rect x="32" y="288" width="64" height="64" fill="white" rx="6"/>
    
    <rect x="128" y="0" width="128" height="16" fill="white" rx="2"/>
    <rect x="128" y="240" width="128" height="16" fill="white" rx="2"/>
    <rect x="0" y="128" width="16" height="128" fill="white" rx="2"/>
    <rect x="240" y="128" width="16" height="128" fill="white" rx="2"/>
    
    <rect x="128" y="128" width="48" height="48" fill="white" rx="4"/>
    <rect x="144" y="144" width="16" height="16" fill="#4A90E2" rx="2"/>
    
    <rect x="176" y="128" width="16" height="16" fill="white" rx="2"/>
    <rect x="208" y="128" width="16" height="16" fill="white" rx="2"/>
    <rect x="128" y="176" width="16" height="16" fill="white" rx="2"/>
    <rect x="128" y="208" width="16" height="16" fill="white" rx="2"/>
    <rect x="176" y="176" width="16" height="16" fill="white" rx="2"/>
    <rect x="208" y="176" width="16" height="16" fill="white" rx="2"/>
    <rect x="176" y="208" width="16" height="16" fill="white" rx="2"/>
    <rect x="208" y="208" width="16" height="16" fill="white" rx="2"/>
    <rect x="240" y="240" width="16" height="16" fill="white" rx="2"/>
  </g>
</svg>
''';

  final container = RepaintBoundary(
    key: GlobalKey(),
    child: SizedBox(
      width: 1024,
      height: 1024,
      child: SvgPicture.string(svgString, fit: BoxFit.cover),
    ),
  );

  final screenshotController = ScreenshotController();

  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/app_icon.png';

  await screenshotController.captureFromWidget(container, pixelRatio: 1.0).then(
    (Uint8List data) {
      File(tempPath).writeAsBytesSync(data);
    },
  );

  print('App icon generated at: $tempPath');

  final assetsDir = Directory('assets/images');
  if (!assetsDir.existsSync()) {
    assetsDir.createSync(recursive: true);
  }

  final targetPath = 'assets/images/app_icon.png';
  File(tempPath).copySync(targetPath);
  File(tempPath).deleteSync();

  print('App icon saved to: $targetPath');
}
