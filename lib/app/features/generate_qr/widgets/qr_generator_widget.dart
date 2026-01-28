import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:qro5de/app/core/services/qr_service.dart';

class QRGeneratorWidget extends StatefulWidget {
  final String qrData;
  final String qrType;

  const QRGeneratorWidget({
    super.key,
    required this.qrData,
    required this.qrType,
  });

  @override
  State<QRGeneratorWidget> createState() => _QRGeneratorWidgetState();
}

class _QRGeneratorWidgetState extends State<QRGeneratorWidget>
    with SingleTickerProviderStateMixin {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;
  bool _isSharing = false;
  bool _showSuccess = false;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  Future<void> _saveQRCode() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final imagePath = await _screenshotController.captureAndSave(
        '/storage/emulated/0/Pictures/QR O5DE',
        fileName: 'qr_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (imagePath != null) {
        setState(() {
          _showSuccess = true;
        });
        _successController.forward().then((_) {
          Future.delayed(const Duration(seconds: 2), () {
            _successController.reverse();
            setState(() {
              _showSuccess = false;
            });
          });
        });
      }
    } catch (e) {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save QR code'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _shareQRCode() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        await Share.shareXFiles([
          XFile.fromData(imageBytes, name: 'qr_code.png'),
        ]);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share QR code'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Generated QR Code',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: QRService.generateQRWidget(widget.qrData, 250),
                  ),
                ),
                if (_showSuccess)
                  Lottie.asset(
                    'assets/lottie/success_animation.json',
                    width: 100,
                    height: 100,
                    controller: _successController,
                    onLoaded: (composition) {
                      _successController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveQRCode,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _shareQRCode,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
