import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/report_service.dart';
import '../../../ticket/domain/entities/ticket.dart';

class ReportPreviewPage extends StatelessWidget {
  final List<Ticket> tickets;

  const ReportPreviewPage({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (format) => ReportService.buildTicketReport(tickets).save(),
        pdfFileName: 'Laporan_Helpdesk_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfPreviewPageDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        loadingWidget: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
