import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> main() async {
  // Create a picture recorder and canvas
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, 1024, 1024));

  // Set white background
  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, 1024, 1024),
    ui.Paint()..color = const ui.Color(0xFFFFFFFF),
  );

  // Draw dark blue circle (background)
  canvas.drawCircle(
    const ui.Offset(512, 512),
    462,
    ui.Paint()..color = const ui.Color(0xFF1E40AF),
  );

  // Draw lighter blue circle (inner)
  canvas.drawCircle(
    const ui.Offset(512, 512),
    312,
    ui.Paint()..color = const ui.Color(0xFF3B82F6),
  );

  // Draw white circle (inner)
  canvas.drawCircle(
    const ui.Offset(512, 512),
    212,
    ui.Paint()..color = const ui.Color(0xFFFFFFFF),
  );

  // Draw QR corners
  const qrColor = ui.Color(0xFF1E40AF);
  const qrSize = 120.0;

  // Top-left corner
  canvas.drawRect(
    ui.Rect.fromLTWH(350, 350, qrSize, qrSize),
    ui.Paint()..color = qrColor,
  );
  canvas.drawRect(
    ui.Rect.fromLTWH(370, 370, 80, 80),
    ui.Paint()..color = Colors.white,
  );
  canvas.drawRect(ui.Rect.fromLTWH(385, 385, 50, 50), ui.Paint()..color = qrColor);

  // Top-right corner
  canvas.drawRect(
    ui.Rect.fromLTWH(674, 350, qrSize, qrSize),
    ui.Paint()..color = qrColor,
  );
  canvas.drawRect(
    ui.Rect.fromLTWH(694, 370, 80, 80),
    ui.Paint()..color = Colors.white,
  );
  canvas.drawRect(ui.Rect.fromLTWH(709, 385, 50, 50), ui.Paint()..color = qrColor);

  // Bottom-left corner
  canvas.drawRect(
    ui.Rect.fromLTWH(350, 674, qrSize, qrSize),
    ui.Paint()..color = qrColor,
  );
  canvas.drawRect(
    ui.Rect.fromLTWH(370, 694, 80, 80),
    ui.Paint()..color = Colors.white,
  );
  canvas.drawRect(ui.Rect.fromLTWH(385, 709, 50, 50), ui.Paint()..color = qrColor);

  // Draw QR body
  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < 12; j++) {
      if ((i + j) % 2 == 0 &&
          i != 0 &&
          i != 1 &&
          i != 2 &&
          i != 3 &&
          i != 11 &&
          i != 10 &&
          i != 9 &&
          i != 8 &&
          j != 0 &&
          j != 1 &&
          j != 2 &&
          j != 3 &&
          j != 11 &&
          j != 10 &&
          j != 9 &&
          j != 8) {
        final x = 420 + i * 25.0;
        final y = 420 + j * 25.0;
        canvas.drawRect(ui.Rect.fromLTWH(x, y, 20, 20), ui.Paint()..color = qrColor);
      }
    }
  }

  // Draw QR text
  const qrText = 'QR';
  const qrTextStyle = TextStyle(
    fontSize: 180,
    color: qrColor,
    fontWeight: FontWeight.bold,
  );

  final qrTextPainter = TextPainter(
    text: const TextSpan(text: qrText, style: qrTextStyle),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  qrTextPainter.layout(minWidth: 0, maxWidth: 1024);
  qrTextPainter.paint(
    canvas,
    Offset(
      (1024 - qrTextPainter.width) / 2,
      (1024 - qrTextPainter.height) / 2 - 100,
    ),
  );

  // Draw O5DE text
  const o5deText = 'O5DE';
  const o5deTextStyle = TextStyle(
    fontSize: 120,
    color: Color(0xFF3B82F6),
    fontWeight: FontWeight.bold,
  );

  final o5deTextPainter = TextPainter(
    text: const TextSpan(text: o5deText, style: o5deTextStyle),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  o5deTextPainter.layout(minWidth: 0, maxWidth: 1024);
  o5deTextPainter.paint(
    canvas,
    Offset(
      (1024 - o5deTextPainter.width) / 2,
      (1024 - o5deTextPainter.height) / 2 + 200,
    ),
  );

  // Convert to PNG
  final picture = recorder.endRecording();
  final image = await picture.toImage(1024, 1024);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    final Directory assetsDir = Directory(
      '${Directory.current.path}/assets/images',
    );
    if (!assetsDir.existsSync()) {
      assetsDir.createSync(recursive: true);
    }

    final File pngFile = File('${assetsDir.path}/app_icon.png');
    await pngFile.writeAsBytes(byteData.buffer.asUint8List());
    print('✅ App icon generated successfully: ${pngFile.path}');
  } else {
    print('❌ Failed to convert to PNG');
  }
}

