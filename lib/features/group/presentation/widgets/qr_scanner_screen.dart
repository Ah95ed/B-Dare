import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/colors.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onCodeScanned;

  const QRScannerScreen({
    super.key,
    required this.onCodeScanned,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        // Stop scanning
        _controller.stop();

        // Extract invite code from QR data
        // QR data could be: invite code directly, or deep link like "mysterylink://join?code=1234"
        String inviteCode = code;

        // If it's a deep link, extract the code
        if (code.startsWith('mysterylink://join?code=')) {
          final uri = Uri.parse(code);
          inviteCode = uri.queryParameters['code'] ?? code;
        } else if (code.contains('code=')) {
          final uri = Uri.tryParse(code);
          if (uri != null) {
            inviteCode = uri.queryParameters['code'] ?? code;
          }
        }

        // Validate code format (4 digits)
        if (RegExp(r'^\d{4}$').hasMatch(inviteCode)) {
          widget.onCodeScanned(inviteCode);
          Navigator.pop(context, inviteCode);
        } else {
          // Show error and continue scanning
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Invalid QR code. Please scan a valid invite code.'),
              backgroundColor: AppColors.error,
            ),
          );
          _controller.start();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // QR Scanner
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),

          // Overlay with instructions
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Position QR code within the frame',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Make sure the code is clear and well-lit',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Scanning frame overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primary, width: 4),
                          left: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primary, width: 4),
                          right: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.primary, width: 4),
                          left: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.primary, width: 4),
                          right: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () {
                      _controller.toggleTorch();
                    },
                    tooltip: 'Toggle flash',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap flash icon to toggle light',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
