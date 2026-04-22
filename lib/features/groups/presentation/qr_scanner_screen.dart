import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('СКАНЕР QR-КОДА'),
        backgroundColor: BrutalTheme.primaryBlack,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isProcessing) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                  setState(() {
                    _isProcessing = true;
                  });
                  // Возвращаем результат на предыдущий экран
                  context.pop(barcode.rawValue);
                  break;
                }
              }
            },
          ),
          
          // Рамка прицела
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: BrutalTheme.warningYellow,
                  width: 4,
                ),
              ),
            ),
          ),
          
          // Инструкция
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrutalTheme.primaryBlack,
                border: Border.all(color: BrutalTheme.primaryWhite, width: 2),
              ),
              child: Text(
                'НАВЕДИТЕ КАМЕРУ НА QR-КОД ГРУППЫ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: BrutalTheme.primaryWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
