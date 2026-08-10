import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart' show Icons;
import 'widgets/qr_scanner_info_sheet.dart';
import 'qr_scanner_overlay.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController _scannerController;
  bool _isTorchOn = false;
  bool _isProcessing = false;

  // Define standard scanner area size
  final double _scanAreaSize = 280.0;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // --- ACTIONS ---

  void _toggleTorch() {
    HapticFeedback.lightImpact();
    _scannerController.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  Future<void> _pickImageFromGallery() async {
    HapticFeedback.lightImpact();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _isProcessing = true);

      final BarcodeCapture? capture = await _scannerController.analyzeImage(
        image.path,
      );
      final bool qrFound = capture?.barcodes.isNotEmpty ?? false;

      if (!qrFound && mounted) {
        setState(() => _isProcessing = false);
        _showResultModal(
          isSuccess: false,
          title: 'No QR Code Found',
          message: "We couldn't detect a valid QR code in the selected image.",
        );
      }
      // If found, the onDetect callback of MobileScanner handles the success routing.
    }
  }

  void _showScannerInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QrScannerInfoSheet(),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        setState(() => _isProcessing = true);
        HapticFeedback.heavyImpact();

        // Pause camera while handling result
        _scannerController.stop();

        // Simulate backend validation delay
        await Future.delayed(const Duration(seconds: 1));

        // TODO: Connect this to actual NobleCards URL/Token validation
        final bool isNobleCardsCode = barcode.rawValue!.contains("noblecards");

        if (isNobleCardsCode) {
          _showResultModal(
            isSuccess: true,
            title: 'QR Code Detected',
            message: 'Processing your request...',
          );
          // Navigate to destination here...
        } else {
          _showResultModal(
            isSuccess: false,
            title: 'Unsupported QR Code',
            message: "Sorry, this QR code isn't recognized by NobleCards.",
          );
        }
      }
    }
  }

  void _showResultModal({
    required bool isSuccess,
    required String title,
    required String message,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF141C28) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Boxicons.bx_check_circle : Boxicons.bx_x_circle,
                color: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (!isSuccess) {
                      setState(() => _isProcessing = false);
                      _scannerController.start();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess
                        ? const Color(0xFF10B981)
                        : bgColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSuccess
                            ? Colors.transparent
                            : const Color(0xFF10B981),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isSuccess ? 'Continue' : 'Scan Again',
                    style: TextStyle(
                      color: isSuccess ? Colors.white : const Color(0xFF10B981),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // --- UI BUILDING ---

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final primaryGreen = const Color(0xFF10B981);

    // Calculate scanner area positioning based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scanRect = Rect.fromCenter(
      center: Offset(screenWidth / 2, screenHeight / 2.2),
      width: _scanAreaSize,
      height: _scanAreaSize,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black, // Fallback behind camera
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: primaryTextColor,
            size: 28,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Text(
          'Scan QR Code',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_info_circle,
              color: primaryTextColor,
              size: 24,
            ),
            onPressed: _showScannerInfoSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Camera Feed
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Boxicons.bx_camera_off, color: Colors.white, size: 40),
                    const SizedBox(height: 16),
                    const Text(
                      'Camera permission denied or unavailable.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                      ),
                      onPressed: () => _scannerController.start(),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Custom Overlay & Animated Scan Line
          QrScannerOverlay(scanArea: scanRect, isDark: isDark),

          // 3. UI Elements placed precisely via SafeArea and Columns
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Top Instruction Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Position the QR code within the frame\nto scan ',
                        ),
                        TextSpan(
                          text: 'automatically.',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Flashlight Pill Indicator (Right below the scanner frame)
                GestureDetector(
                  onTap: _toggleTorch,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B).withOpacity(0.8)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isTorchOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: _isTorchOn ? primaryGreen : secondaryTextColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tap to turn on flashlight',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Bottom Control Panel
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F141A)
                          : const Color(
                              0xFF141C28,
                            ), // Always dark container as per reference
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBottomActionButton(
                          icon: Boxicons.bx_image_alt,
                          label: 'Album',
                          onTap: _pickImageFromGallery,
                        ),
                        // Divider Line
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        _buildBottomActionButton(
                          icon: _isTorchOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          label: 'Flashlight',
                          isActive: _isTorchOn,
                          onTap: _toggleTorch,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay if processing an image/QR
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF10B981)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final activeGreen = const Color(0xFF10B981);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? activeGreen : Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? activeGreen : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
