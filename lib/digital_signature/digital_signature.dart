import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DigitalSignature extends StatefulWidget {
  final String empCode;

  const DigitalSignature({Key? key, required this.empCode}) : super(key: key);

  @override
  _DigitalSignatureState createState() => _DigitalSignatureState();
}

class _DigitalSignatureState extends State<DigitalSignature>
    with NetworkResponse {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  Uint8List? _imageBytes;
  bool _isSigned = false;
  String _uploadedSign = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSignature();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              splashRadius: 24.0,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                popIt(context);
              },
            ),
            title: Text(
              'Signature',
              style: TextStyle(fontSize: 17),
            )),
        body: SingleChildScrollView(
          child: Column(
              children: [
                Column(
                  children: [
                    _uploadedSign.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 12),
                              child: Text('Uploaded Signature',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey)),
                            ),
                            Container(
                                height: 110.sp,
                                width: double.infinity,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                padding: EdgeInsets.all(8),
                                child: CachedNetworkImage(
                                  imageUrl: _uploadedSign,
                                  height: 110.sp,
                                  width: 96.sp,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Image.asset("images/loading_placeholder.png"),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                          ],
                        )
                        : Column(
                            children: [
                              Icon(Icons.image_not_supported, size: 72, color: Colors.grey),
                              SizedBox(height: 10.sp),
                              Text('Signature not available',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey))
                            ],
                          ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                            child: SfSignaturePad(
                              key: signatureGlobalKey,
                              backgroundColor: Colors.white,
                              strokeColor: Colors.black,
                              minimumStrokeWidth: 1.0,
                              maximumStrokeWidth: 4.0,
                              onDraw: (x, y) {
                                _isSigned = true;
                              },
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)))),
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      TextButton(
                        child: Text('Upload'),
                        onPressed: () {
                          if (!_isSigned) {
                            showAlert(
                                context, 'Signature cannot be empty', 'Error');
                            return;
                          }
                          showAlert(context, 'Do you want to upload this sign',
                              'Confirmation', ok: 'Upload', notOk: 'Cancel',
                              onNo: () {
                            popIt(context);
                          }, onOk: _handleSaveButtonPressed);
                        },
                      ),
                      TextButton(
                        child: Text('Clear'),
                        onPressed: _handleClearButtonPressed,
                      )
                    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center),
        ));
  }

  _getSignature() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': widget.empCode,
    };

    WebService.fromApi(AppConfig.getEmpSign, this, jsonBody)
        .callPostService(context);
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
    _imageBytes = null;
    _isSigned = false;
  }

  void _handleSaveButtonPressed() async {
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final byteImg = await data.toByteData(format: ui.ImageByteFormat.png);
    _imageBytes = byteImg!.buffer.asUint8List();
    _uploadSign();
  }



  Future<File> _createFileFromUint8List() async {
    final tempDir = await getTemporaryDirectory();
    final kFile = await File('${tempDir.path}/temp_signature.png').create();
    if (kFile.existsSync()) {
      kFile.deleteSync();
    }
    kFile.writeAsBytesSync(_imageBytes!);
    return Future.value(kFile);
  }

  _uploadSign() async {
    File mFile = await _createFileFromUint8List();

    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'emp_code': widget.empCode,
      'file_type': 's'
    };

    WebService.multipartApi(
            AppConfig.uploadEmployeePic, this, jsonBody, mFile.absolute.path)
        .callMultipartPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.uploadEmployeePic:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                _getSignature();
                _handleClearButtonPressed();
              });
            } else {
              showAlert(
                context,
                getString(data, 'message'),
                'Error',
              );
            }
          }
          break;

        case AppConfig.getEmpSign:
          {
            var data = jsonDecode(response!);

            logIt("EmpSign-> $data");

            if (data['error'] == 'false') {

              if(getString(data, 'content').isNotEmpty){
                _uploadedSign = '${getString(data, 'image_png_path')}${getString(data, 'content')}';
              }

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err, $stack');
    }
  }
}
