import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class ViewPDF extends StatefulWidget {
  String filePath;
  ViewPDF({Key? key, required this.filePath}) : super(key: key);

  @override
  State<ViewPDF> createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("PDF View"),
          actions: [
            InkWell(
                onTap: () {
                  Share.shareFiles([widget.filePath], text: "Share Production Report");
                },
                child: Icon(Icons.share)),
            SizedBox(width: 10,)
          ],
        ),
        body: PDFView(
          filePath: widget.filePath,
        ),
      ),
    );
  }
}
