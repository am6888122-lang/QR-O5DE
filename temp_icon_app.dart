import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const TempIconApp());
}

class TempIconApp extends StatelessWidget {
  const TempIconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: IconGenerator());
  }
}

class IconGenerator extends StatefulWidget {
  @override
  _IconGeneratorState createState() => _IconGeneratorState();
}

class _IconGeneratorState extends State<IconGenerator> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isGenerating = false;

  Future<void> _generateIcon() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        // Save to assets directory
        final currentDirectory = Directory.current;
        final assetsDirectory = Directory(
          '${currentDirectory.path}/assets/images',
        );
        if (!assetsDirectory.existsSync()) {
          assetsDirectory.createSync(recursive: true);
        }

        final file = File('${assetsDirectory.path}/app_icon.png');
        await file.writeAsBytes(imageBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App icon generated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating icon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon Generator')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: 1024,
                height: 1024,
                color: Colors.white,
                child: SvgPicture.asset(
                  'assets/images/app_icon.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateIcon,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: _isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Generating...'),
                      ],
                    )
                  : const Text('Generate Icon'),
            ),
          ],
        ),
      ),
    );
  }
}
