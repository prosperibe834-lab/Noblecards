import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DepositReceiptService {
  static Future<void> shareReceiptImage(
    Uint8List imageBytes, {
    String? receiptIdentifier,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = _fileName(receiptIdentifier, 'png');
      final imageFile = File('${directory.path}/$fileName');
      await imageFile.writeAsBytes(imageBytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imageFile.path)],
          text: receiptIdentifier == null
              ? 'Deposit Receipt'
              : 'Deposit Receipt - $receiptIdentifier',
          subject: 'NobleCards Deposit Receipt',
        ),
      );
    } catch (error) {
      throw Exception('Failed to share deposit receipt: $error');
    }
  }

  static Future<void> downloadReceiptPdf(
    Uint8List imageBytes, {
    String? receiptIdentifier,
  }) async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${_fileName(receiptIdentifier, 'pdf')}');
      await file.writeAsBytes(await pdf.save());
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Your NobleCards deposit receipt',
          subject: 'NobleCards Deposit Receipt',
        ),
      );
    } catch (error) {
      throw Exception('Failed to generate deposit receipt PDF: $error');
    }
  }

  static String _fileName(String? identifier, String extension) {
    final safeIdentifier = identifier
        ?.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')
        .trim();
    final suffix = safeIdentifier == null || safeIdentifier.isEmpty
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : safeIdentifier;
    return 'noblecards_deposit_receipt_$suffix.$extension';
  }
}