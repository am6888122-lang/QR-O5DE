import 'package:qr_flutter/qr_flutter.dart';

class QRService {
  /// Generates QR code data from different types of inputs
  static String generateQRData({
    required String type,
    required Map<String, dynamic> data,
  }) {
    switch (type) {
      case 'text':
        return data['text'];
      case 'url':
        return data['url'];
      case 'phone':
        return 'tel:${data['phone']}';
      case 'email':
        return 'mailto:${data['email']}?subject=${data['subject']}&body=${data['body']}';
      case 'wifi':
        return 'WIFI:T:${data['security']};S:${data['ssid']};P:${data['password']};;';
      case 'contact':
        return '''BEGIN:VCARD
VERSION:3.0
FN:${data['name']}
TEL:${data['phone']}
EMAIL:${data['email']}
END:VCARD''';
      default:
        return '';
    }
  }

  /// Gets the appropriate QR code widget
  static QrImageView generateQRWidget(String data, double size) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false,
    );
  }

  /// Determines the appropriate QR type from data
  static String getQRTypeFromData(String data) {
    if (data.startsWith('tel:')) {
      return 'phone';
    } else if (data.startsWith('mailto:')) {
      return 'email';
    } else if (data.startsWith('WIFI:')) {
      return 'wifi';
    } else if (data.contains('BEGIN:VCARD')) {
      return 'contact';
    } else if (data.startsWith('http://') || data.startsWith('https://')) {
      return 'url';
    } else {
      return 'text';
    }
  }
}
