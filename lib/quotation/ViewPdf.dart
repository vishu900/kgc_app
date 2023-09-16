import 'dart:io';

//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'SendEmail.dart';

class ViewPdf extends StatefulWidget {
  final File? data;
  final String? pdfUrl;
  final String? id;
  final String? partyCode;
  final String? partyName;
  final String? type;

  const ViewPdf(
      {Key? key,
      this.pdfUrl,
      this.data,
      this.id,
      this.partyCode,
      this.type,
      this.partyName})
      : super(key: key);

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
//  PDFDocument? doc;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    logIt(widget.pdfUrl);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      /*  widget.data == null
          ? doc = await PDFDocument.fromURL(widget.pdfUrl!)
          : doc = await PDFDocument.fromFile(widget.data!);
      setState(() {}); */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            popIt(context);
          },
        ),
      ),
      body: //doc == null
          //? const SizedBox()
          widget.data == null
              ? SfPdfViewer.network(
                  widget.pdfUrl!,
                )
              : SfPdfViewer.file(
                  widget.data!,
                ),
      floatingActionButton: Visibility(
        visible: widget.data != null && widget.type != null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: 'EmailTag',
                child: Icon(Icons.email),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendEmail(
                              type: widget.type,
                              codePk: widget.id,
                              partyCode: widget.partyCode,
                              companyName: widget.partyName)));
                  //Share.shareFiles([widget.data.absolute.path]);
                }),
            SizedBox(width: 8),
            FloatingActionButton(
                heroTag: 'PdfTag',
                child: Icon(Icons.share),
                onPressed: () {
                  Share.shareFiles([widget.data!.absolute.path]);
                }),
          ],
        ),
      ),
    );
  }

  /*PDFViewer(
  document: doc!,
  pickerButtonColor: AppColor.appRed,
  ),*/
}
