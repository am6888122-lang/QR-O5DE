import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qro5de/app/core/providers/history_provider.dart';
import 'package:qro5de/app/core/models/qr_code_model.dart';
import 'package:qro5de/app/core/services/qr_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanned = false;
  bool _torchEnabled = false;
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScanResult(String data) {
    if (!_isScanned) {
      setState(() {
        _isScanned = true;
      });

      // Save to history
      final historyProvider = Provider.of<HistoryProvider>(
        context,
        listen: false,
      );
      final qrType = QRService.getQRTypeFromData(data);
      historyProvider.addToHistory(
        QRCodeModel(
          type: qrType,
          data: data,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('QR Code Scanned'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Type: $qrType'),
                  const SizedBox(height: 8),
                  Text('Data: $data'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isScanned = false;
                  });
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleScanResult(barcode.rawValue!);
                }
              }
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _torchEnabled ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          await _controller.toggleTorch();
                          setState(() {
                            _torchEnabled = !_torchEnabled;
                          });
                        } catch (e) {
                          // Torch might not be available on some devices
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(
                        Icons.flip_camera_android,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _controller.switchCamera();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
