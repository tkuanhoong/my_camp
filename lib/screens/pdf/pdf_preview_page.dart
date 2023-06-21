import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/logic/cubits/report/report_cubit.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final String campsiteId;
  const PdfPreviewPage({Key? key, required this.campsiteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        canDebug: false,
        canChangePageFormat: false,
        pdfFileName: 'report.pdf',
        canChangeOrientation: false,
        build: (_) async =>
            await context.read<ReportCubit>().generatePdf(campsiteId),
      ),
    );
  }
}
