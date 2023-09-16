import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import '../Commons/Commons.dart';
//import '../appConfig/AppConfig.dart';

class VerifySign extends StatefulWidget {
  final String uploadedSign;

  const VerifySign({Key? key, required this.uploadedSign}) : super(key: key);

  @override
  _VerifySignState createState() => _VerifySignState();
}

class _VerifySignState extends State<VerifySign> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  bool _isSigned = false;
  bool _showSavedSign = false;
  Uint8List? _imageBytes;
  String _uploadedSign = '';

  @override
  void initState() {
    _uploadedSign = widget.uploadedSign;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Here'),
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40.h,
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            ),
            SizedBox(height: 5.sp),
            Visibility(
                visible: _showSavedSign,
                child: _uploadedSign.isNotEmpty
                    ? SizedBox(
                        height: 40.h,
                        child: CachedNetworkImage(
                          imageUrl: _uploadedSign,
                          placeholder: (context, _) =>
                              Image.asset('images/loading_placeholder.png'),
                        ))
                    : Container(
                        child: Column(
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 10.sp),
                            Text('Signature not available',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey))
                          ],
                        ),
                      )),
            TextButton(
                onPressed: () {
                  setState(() {
                    _showSavedSign = !_showSavedSign;
                  });
                },
                child: Text(
                    _showSavedSign ? 'Hide Saved Sign' : 'Show Saved Sign')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async {
                      if (_isSigned) {
                        await _handleSaveButtonPressed();
                        popIt(context,
                            args: {'status': true, 'data': _imageBytes});
                      } else {
                        showAlert(
                            context, 'Signature cannot be empty', 'Error');
                        return;
                      }
                    },
                    child: Text('Pay Now')),
                TextButton(
                    onPressed: () {
                      _handleClearButtonPressed();
                    },
                    child: Text('Clear')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
    _imageBytes = null;
    _isSigned = false;
  }

  Future _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final byteImg = await data.toByteData(format: ui.ImageByteFormat.png);
    _imageBytes = byteImg!.buffer.asUint8List();
  }
}
