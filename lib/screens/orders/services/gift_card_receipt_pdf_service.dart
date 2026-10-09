import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../gift_card_details/models/gift_card_details_model.dart';
import 'gift_card_pdf_download_stub.dart'
    if (dart.library.html) 'gift_card_pdf_download_web.dart' as web_download;
import 'gift_card_pdf_share_stub.dart'
    if (dart.library.io) 'gift_card_pdf_share_io.dart' as mobile_share;

class GiftCardReceiptPdfService {
  static Future<Uint8List> generatePdf(GiftCardDetailsModel details) async {
    final document = pw.Document();
    final regularFont = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();
    final lines = receiptLines(details);
    final title = lines.isEmpty ? 'Gift Card Receipt' : lines.first;
    final fields = lines.skip(1);
    final hasCredential = details.code.trim().isNotEmpty ||
        (details.pin?.trim().isNotEmpty ?? false);

    document.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.teal700,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'NobleCards',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  title,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),
          ...fields.map((line) => _fieldWidget(line, regularFont, boldFont)),
          if (!hasCredential) ...[
            pw.SizedBox(height: 18),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'Use the View Gift Card button in NobleCards to access the provider redemption experience.',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );

    return document.save();
  }

  static List<String> receiptLines(GiftCardDetailsModel details) =>
      details.downloadText.split('\n');

  static Future<void> downloadOrShare(GiftCardDetailsModel details) async {
    try {
      final bytes = await generatePdf(details);
      final fileName = _fileName(details.orderReference);
      if (kIsWeb) {
        web_download.downloadPdf(bytes, fileName);
        return;
      }

      await mobile_share.sharePdf(bytes, fileName);
    } catch (_) {
      throw Exception('Unable to generate or share the gift card PDF.');
    }
  }

  static String wrapCredentialForPdf(String value, {int lineLength = 24}) {
    final characters = value.runes.map(String.fromCharCode).toList();
    return [
      for (var offset = 0; offset < characters.length; offset += lineLength)
        characters.skip(offset).take(lineLength).join(),
    ].join('\n');
  }

  static String _fileName(String? reference) {
    final safeReference = reference
        ?.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')
        .trim();
    return 'noblecards_gift_card_receipt_${safeReference?.isNotEmpty == true ? safeReference : 'gift_card'}.pdf';
  }

  static pw.Widget _fieldWidget(
    String line,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    final separator = line.indexOf(':');
    if (separator < 0) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(
          line,
          style: pw.TextStyle(fontSize: 11, font: regularFont),
        ),
      );
    }

    final label = line.substring(0, separator).trim();
    final value = line.substring(separator + 1).trim();
    final isCredential = label == 'Gift Card Code' || label == 'Gift Card PIN';
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: pw.EdgeInsets.all(isCredential ? 12 : 8),
      decoration: pw.BoxDecoration(
        color: isCredential ? PdfColors.grey100 : PdfColors.white,
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: PdfColors.grey700,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              font: boldFont,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            isCredential ? wrapCredentialForPdf(value) : value,
            style: pw.TextStyle(
              color: PdfColors.grey900,
              fontSize: 11,
              font: isCredential ? pw.Font.courier() : regularFont,
            ),
          ),
        ],
      ),
    );
  }
}