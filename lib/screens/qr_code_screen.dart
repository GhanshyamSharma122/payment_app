import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:payment_app/utils/theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _isScanning = false;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _isScanning = true);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to scan QR codes')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'QR Code',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 28,
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'My QR'),
              Tab(text: 'Scan QR'),
            ],
            indicatorColor: isDarkMode ? Colors.white : AppTheme.accentColor,
            labelColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _MyQRView(),
            _ScanQRView(
              isScanning: _isScanning,
              onScanStateChanged: (scanning) async {
                if (scanning) {
                  await _requestCameraPermission();
                } else {
                  setState(() => _isScanning = false);
                }
              },
              scannerController: _scannerController,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyQRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual user data
    const userId = "user123";
    const userName = "testuser"; // Changed from Utkrisht to testuser
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? AppTheme.darkGradientColors 
              : AppTheme.gradientColors,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: userId,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'testuser', // Changed from Utkrisht
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan to pay',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Share your QR code to receive payments instantly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanQRView extends StatelessWidget {
  final bool isScanning;
  final ValueChanged<bool> onScanStateChanged;
  final MobileScannerController scannerController;

  const _ScanQRView({
    required this.isScanning,
    required this.onScanStateChanged,
    required this.scannerController,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? AppTheme.darkGradientColors 
              : AppTheme.gradientColors,
        ),
      ),
      child: Center(
        child: isScanning
            ? Column(
                children: [
                  Expanded(
                    child: MobileScanner(
                      controller: scannerController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          debugPrint('Barcode found! ${barcode.rawValue}');
                          if (barcode.rawValue != null) {
                            // Handle the scanned QR code
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Scanned: ${barcode.rawValue}'),
                                action: SnackBarAction(
                                  label: 'Process Payment',
                                  onPressed: () {
                                    // Handle payment processing
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => onScanStateChanged(false),
                      icon: const Icon(Icons.close),
                      label: const Text('Stop Scanning'),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 280,
                      height: 280,
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 80,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Scan QR Code',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Point your camera at a QR code',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => onScanStateChanged(true),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Start Scanning'),
                  ),
                ],
              ),
      ),
    );
  }
}