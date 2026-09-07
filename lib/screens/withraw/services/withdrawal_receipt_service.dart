import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/withdrawal_transaction_model.dart';

class WithdrawalReceiptService {
  /// Shares the captured image byte data using share_plus
  static Future<void> shareReceiptImage(
    Uint8List imageBytes,
    WithdrawalTransactionModel transaction,
  ) async {
    try {
      final directory = await getTemporaryDirectory();
      final imagePath = await File(
        '${directory.path}/receipt_${transaction.referenceId}.png',
      ).create();
      await imagePath.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath.path)],
          text: 'Withdrawal Receipt - ${transaction.referenceId}',
          subject: 'NobleCards Receipt',
        ),
      );
    } catch (e) {
      throw Exception('Failed to share receipt: $e');
    }
  }

  /// Converts the captured image to a PDF and saves/shares it
  static Future<void> downloadReceiptPdf(
    Uint8List imageBytes,
    WithdrawalTransactionModel transaction,
  ) async {
    try {
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );

      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/NobleCards_Receipt_${transaction.referenceId}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      // On mobile, downloading typically means saving to files or sharing the document
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Your NobleCards PDF Receipt',
          subject: 'NobleCards Receipt Download',
        ),
      );
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}
