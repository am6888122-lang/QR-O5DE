import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:qro5de/app/core/providers/history_provider.dart';
import 'package:qro5de/app/core/services/qr_service.dart';
import 'package:qro5de/app/core/models/qr_code_model.dart';
import 'package:qro5de/app/features/generate_qr/widgets/qr_generator_widget.dart';
import 'package:qro5de/app/features/history/screens/history_screen.dart';
import 'package:qro5de/app/features/qr_scanner/screens/qr_scanner_screen.dart';
import 'package:qro5de/app/features/settings/screens/settings_screen.dart';

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  String _selectedType = 'text';
  String _qrData = '';
  bool _isGenerated = false;

  final Map<String, dynamic> _formData = {
    'text': '',
    'url': '',
    'phone': '',
    'email': '',
    'subject': '',
    'body': '',
    'ssid': '',
    'password': '',
    'security': 'WPA',
    'name': '',
    'contactPhone': '',
    'contactEmail': '',
  };

  final List<Map<String, dynamic>> _qrTypes = [
    {'type': 'text', 'title': 'Text', 'icon': Icons.text_fields},
    {'type': 'url', 'title': 'URL', 'icon': Icons.link},
    {'type': 'phone', 'title': 'Phone', 'icon': Icons.phone},
    {'type': 'email', 'title': 'Email', 'icon': Icons.email},
    {'type': 'wifi', 'title': 'WiFi', 'icon': Icons.wifi},
    {'type': 'contact', 'title': 'Contact', 'icon': Icons.contacts},
  ];

  void _generateQR() {
    final data = QRService.generateQRData(
      type: _selectedType,
      data: _getFormDataForType(),
    );
    setState(() {
      _qrData = data;
      _isGenerated = true;
    });

    // Save to history
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    historyProvider.addToHistory(
      QRCodeModel(
        type: _selectedType,
        data: _qrData,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> _getFormDataForType() {
    switch (_selectedType) {
      case 'text':
        return {'text': _formData['text']};
      case 'url':
        return {'url': _formData['url']};
      case 'phone':
        return {'phone': _formData['phone']};
      case 'email':
        return {
          'email': _formData['email'],
          'subject': _formData['subject'],
          'body': _formData['body'],
        };
      case 'wifi':
        return {
          'ssid': _formData['ssid'],
          'password': _formData['password'],
          'security': _formData['security'],
        };
      case 'contact':
        return {
          'name': _formData['name'],
          'phone': _formData['contactPhone'],
          'email': _formData['contactEmail'],
        };
      default:
        return {};
    }
  }

  Widget _buildForm() {
    switch (_selectedType) {
      case 'text':
        return _buildTextField('Text', 'text');
      case 'url':
        return _buildTextField('URL', 'url');
      case 'phone':
        return _buildTextField(
          'Phone Number',
          'phone',
          keyboardType: TextInputType.phone,
        );
      case 'email':
        return Column(
          children: [
            _buildTextField(
              'Email',
              'email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField('Subject', 'subject'),
            _buildTextField('Body', 'body'),
          ],
        );
      case 'wifi':
        return Column(
          children: [
            _buildTextField('SSID', 'ssid'),
            _buildTextField('Password', 'password', obscureText: true),
            _buildSecurityDropdown(),
          ],
        );
      case 'contact':
        return Column(
          children: [
            _buildTextField('Name', 'name'),
            _buildTextField(
              'Phone',
              'contactPhone',
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              'Email',
              'contactEmail',
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTextField(
    String label,
    String fieldKey, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) {
          setState(() {
            _formData[fieldKey] = value;
          });
        },
      ),
    );
  }

  Widget _buildSecurityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Security',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        value: _formData['security'],
        items: ['WPA', 'WEP', 'NONE'].map((security) {
          return DropdownMenuItem(value: security, child: Text(security));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _formData['security'] = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR O5DE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // QR Type Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select QR Type',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _qrTypes.length,
                            itemBuilder: (context, index) {
                              final type = _qrTypes[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedType = type['type'];
                                    _isGenerated = false;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _selectedType == type['type']
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedType == type['type']
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        type['icon'],
                                        size: 32,
                                        color: _selectedType == type['type']
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        type['title'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _selectedType == type['type']
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildForm(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _generateQR,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Generate QR Code'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // QR Code Display
                if (_isGenerated)
                  QRGeneratorWidget(qrData: _qrData, qrType: _selectedType),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
