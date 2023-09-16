import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'dart:typed_data';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/LifecycleEventHandler.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mantra_mfs100/mantra_mfs100.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import '../dashboard.dart';
import 'hand_model.dart';
import 'dart:ui' as ui;

class FingerPrint extends StatefulWidget {
  final String empCode;
  final String compCode;
  final String empName;

  const FingerPrint(
      {Key? key,
      required this.empCode,
      required this.empName,
      required this.compCode})
      : super(key: key);

  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> with NetworkResponse {
  bool _isPlatformSupported = false;
  bool _isConnected = false;
  bool _isError = false;
  bool _isCapturing = false;
  String _status = 'Ready';
  Uint8List? _fingerImageBytes;
  late MantraMfs100 _mfs;
  String _selectedFinger = '';
  List<HandModel> _leftHandList = HandModel.loadLeftHandList();
  List<HandModel> _rightHandList = HandModel.loadRightHandList();
  bool _isLeftSelected = true;
  bool _isAllSelected = false;
  StreamSubscription<dynamic>? mfsStream;

  @override
  void initState() {
    _isPlatformSupported = Platform.isAndroid;
    _isConnected = DashboardState.isConnected;
    if (_isPlatformSupported) _registerListener();
    super.initState();
    if (_isPlatformSupported) {
      _mfs = MantraMfs100.instance!;
    }
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(detachedCallBack: () async {
      if (_isPlatformSupported) {
        _mfs.stopAutoCapture();
      }
    }));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAllFingerprint();
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
          'Fingerprint',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
                _isConnected ? Icons.usb_outlined : Icons.usb_off_outlined,
                size: 22),
          )
        ],
      ),
      body: _isPlatformSupported ? _getBodyWidget() : _showPlatformError(),
    );
  }

  Widget _getBodyWidget() {
    if (_isConnected) {
      return SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                children: [
                  TableRow(children: [
                    Text('Employee Code:'),
                    Text('${widget.empCode}')
                  ]),
                  TableRow(children: [
                    Text('Employee name:'),
                    Text('${widget.empName}')
                  ]),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _fingerImageBytes != null
                      ? Image.memory(_fingerImageBytes!, height: 64.sp)
                      : Icon(Icons.fingerprint_outlined,
                          size: 64.sp,
                          color: _isCapturing ? Colors.red : Colors.grey),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: BoxDecoration(
                        color: _isCapturing
                            ? Colors.orange
                            : _isError
                                ? Colors.red
                                : Colors.green,
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: 4),
                  Text(_status,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey)),
                ],
              ),
              SizedBox(height: 10.sp),
              Table(
                border: TableBorder(
                    top: BorderSide(),
                    left: BorderSide(),
                    right: BorderSide(),
                    verticalInside: BorderSide()),
                children: [
                  /// Header
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Left Hand'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Right Hand'),
                    ),
                  ]),
                ],
              ),
              Row(
                children: [
                  /// Left Finger
                  Expanded(
                    child: Table(
                      border: TableBorder(
                          top: BorderSide(),
                          left: BorderSide(),
                          bottom: BorderSide(),
                          horizontalInside: BorderSide(),
                          verticalInside: BorderSide()),
                      children: List.generate(
                        _leftHandList.length,
                        (index) => TableRow(children: [
                          GestureDetector(
                            onTap: () {
                              _leftHandList.forEach(
                                  (element) => element.isSelected = false);
                              _leftHandList[index].fingerValue = null;
                              _leftHandList[index].isDone = false;
                              _leftHandList[index].quality = 0;
                              setState(() {
                                _selectedFinger =
                                    _leftHandList[index].fingerName;
                                _isLeftSelected = true;
                                _isAllSelected = false;
                                _leftHandList[index].isSelected = true;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: !_leftHandList[index].isDone
                                    ? const EdgeInsets.only(left: 14)
                                    : EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 9),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_leftHandList[index].fingerName),
                                        SizedBox(height: 2),
                                        Visibility(
                                            visible:
                                                _leftHandList[index].isDone,
                                            child: Text(
                                                'Quality:${_leftHandList[index].quality}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontStyle:
                                                        FontStyle.italic))),
                                      ],
                                    ),
                                    !_leftHandList[index].isDone
                                        ? Radio(
                                            value:
                                                _leftHandList[index].fingerName,
                                            groupValue: _selectedFinger,
                                            onChanged: (v) {
                                              _leftHandList.forEach((element) =>
                                                  element.isSelected = false);
                                              setState(() {
                                                _selectedFinger =
                                                    _leftHandList[index]
                                                        .fingerName;
                                                _isLeftSelected = true;
                                                _leftHandList[index]
                                                    .isSelected = true;
                                              });
                                            })
                                        : Icon(Icons.done,
                                            size: 20, color: Colors.green)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),

                  /// Right Finger
                  Expanded(
                    child: Table(
                      border: TableBorder.all(),
                      children: List.generate(
                        _rightHandList.length,
                        (index) => TableRow(children: [
                          GestureDetector(
                            onTap: () {
                              _rightHandList.forEach(
                                  (element) => element.isSelected = false);
                              _rightHandList[index].fingerValue = null;
                              _rightHandList[index].isDone = false;
                              _rightHandList[index].quality = 0;
                              setState(() {
                                _selectedFinger =
                                    _rightHandList[index].fingerName;
                                _isLeftSelected = false;
                                _isAllSelected = false;
                                _rightHandList[index].isSelected = true;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: !_rightHandList[index].isDone
                                    ? const EdgeInsets.only(left: 14)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 9),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_rightHandList[index].fingerName),
                                        SizedBox(height: 2),
                                        Visibility(
                                            visible:
                                                _rightHandList[index].isDone,
                                            child: Text(
                                                'Quality:${_rightHandList[index].quality}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontStyle:
                                                        FontStyle.italic))),
                                      ],
                                    ),
                                    !_rightHandList[index].isDone
                                        ? Radio(
                                            value: _rightHandList[index]
                                                .fingerName,
                                            groupValue: _selectedFinger,
                                            onChanged: (v) {
                                              _rightHandList.forEach(
                                                  (element) => element
                                                      .isSelected = false);
                                              setState(() {
                                                _selectedFinger =
                                                    _rightHandList[index]
                                                        .fingerName;
                                                _isLeftSelected = false;
                                                _rightHandList[index]
                                                    .isSelected = true;
                                              });
                                            })
                                        : Icon(Icons.done,
                                            size: 20, color: Colors.green)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.sp),
              Text('For finger reset tap on that finger',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontStyle: FontStyle.italic)),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _isCapturing ||
                              _isAllSelected ||
                              _selectedFinger.isEmpty
                          ? null
                          : _captureFingerPrint,
                      child: Text('Capture')),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: !_isLeftHandListNotFullyEmpty() &&
                              !_isRightHandListNotFullyEmpty()
                          ? null
                          : () {
                              _saveFingerprint();
                            },
                      child: Text('Save')),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.usb_off_outlined,
              size: 48.sp,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text('Fingerprint device is not connected.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w300))
          ],
        ),
      );
    }
  }

  Widget _showPlatformError() {
    return SizedBox(
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.android, size: 52.sp, color: Colors.grey),
          const SizedBox(height: 24),
          Text('Only android is supported.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }

  _captureFingerPrint() async {
    try {
      if (_isCapturing) return;
      _isCapturing = true;
      _resetCapturing();
      _setCaptureSuccess('Trying to capture...');
      await Future.delayed(Duration(milliseconds: 250));
      FingerData res = await _mfs.startAutoCapture(6000, true);
      _fingerImageBytes = Uint8List.fromList(res.fingerImage);
      _setCaptureSuccess('Captured with ${res.quality}% quality');
      _setCapturedData(res);
    } catch (err) {
      if (err is PlatformException) {
        _setCaptureError(err.message.toString());
      }
    } finally {
      _isCapturing = false;
    }
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Uint8List> _getPngUint8List(List<int> fingerImage) async {
    final img = await loadImage(Uint8List.fromList(fingerImage));
    final byteImg = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteImg!.buffer.asUint8List();
  }

  _setCapturedData(FingerData model) async {
    if (_isLeftSelected) {
      for (var element in _leftHandList) {
        if (element.isSelected) {
          element.fingerImage = Uint8List.fromList(model.fingerImage);
          element.fingerValue = model.iSOTemplate;
          element.isDone = true;
          element.quality = model.quality;
          element.file = await _createFileFromUint8List(
              await _getPngUint8List(model.fingerImage),
              element.fingerName.replaceAll(' ', ''));
          int index = _leftHandList.indexOf(element);
          element.isSelected = false;
          _moveNext(++index);
          return;
        }
      }
    } else {
      for (var element in _rightHandList) {
        if (element.isSelected) {
          element.fingerImage = Uint8List.fromList(model.fingerImage);
          element.fingerValue = model.iSOTemplate;
          element.isDone = true;
          element.quality = model.quality;
          element.file = await _createFileFromUint8List(
              await _getPngUint8List(model.fingerImage), element.fingerName);
          int index = _rightHandList.indexOf(element);
          _moveNext(++index);
          element.isSelected = false;
          return;
        }
      }
    }
  }

  _moveNext(int index) {
    if (_isLeftSelected) {
      _jumpToLeft(index);
    } else {
      _jumpToRight(index);
    }
    if (_isLeftHandListFull() && _isRightHandListFull()) {
      setState(() {
        _isAllSelected = true;
      });
    }
    setState(() {});
  }

  _jumpToLeft(int index) {
    if (index < _leftHandList.length) {
      if (_leftHandList[index].fingerValue == null) {
        _leftHandList[index].isSelected = true;
        _selectedFinger = _leftHandList[index].fingerName;
        _isLeftSelected = true;
      } else {
        for (int i = index; i < _leftHandList.length; i++) {
          var element = _leftHandList[i];
          if (element.fingerValue == null) {
            element.isSelected = true;
            _selectedFinger = element.fingerName;
            _isLeftSelected = true;
            return;
          }
        }
      }
    } else {
      for (var element in _leftHandList) {
        if (element.fingerValue == null) {
          element.isSelected = true;
          _selectedFinger = element.fingerName;
          _isLeftSelected = true;
          return;
        }
      }
    }
    if (_isLeftHandListFull() && _isRightHandListFull()) {
      setState(() {
        _isAllSelected = true;
      });
    } else if (_isLeftHandListFull()) {
      _jumpToRight(0);
    }
  }

  _jumpToRight(int index) {
    if (index < _rightHandList.length) {
      if (_rightHandList[index].fingerValue == null) {
        _rightHandList[index].isSelected = true;
        _selectedFinger = _rightHandList[index].fingerName;
        _isLeftSelected = false;
      } else {
        for (int i = index; i < _rightHandList.length; i++) {
          var element = _rightHandList[i];
          if (element.fingerValue == null) {
            element.isSelected = true;
            _selectedFinger = element.fingerName;
            _isLeftSelected = false;
            return;
          }
        }
      }
    } else {
      for (var element in _rightHandList) {
        if (element.fingerValue == null) {
          element.isSelected = true;
          _selectedFinger = element.fingerName;
          _isLeftSelected = false;
          return;
        }
      }
    }

    if (_isLeftHandListFull() && _isRightHandListFull()) {
      setState(() {
        _isAllSelected = true;
      });
    } else if (_isRightHandListFull()) {
      _jumpToLeft(0);
    }
  }

  bool _isLeftHandListFull() {
    return _leftHandList.where((element) => element.isDone).length ==
        _leftHandList.length;
  }

  bool _isLeftHandListNotFullyEmpty() {
    return _leftHandList.where((element) => element.isDone).length > 0;
  }

  bool _isRightHandListFull() {
    return _rightHandList.where((element) => element.isDone).length ==
        _rightHandList.length;
  }

  bool _isRightHandListNotFullyEmpty() {
    return _rightHandList.where((element) => element.isDone).length > 0;
  }

  _setCaptureError(String errorMsg) {
    setState(() {
      _isError = true;
      _status = errorMsg;
    });
  }

  _setCaptureSuccess(String successMsg) {
    setState(() {
      _isError = false;
      _status = successMsg;
    });
  }

  _resetCapturing() {
    _isError = false;
    _status = 'Ready';
    _fingerImageBytes = null;
  }

  _registerListener() {
    mfsStream = DashboardState.mfsController.stream.listen((event) {
      if (event['event'] == 'connected') {
        _isConnected = true;
        _setCaptureSuccess('Ready');
        logIt('onDevAttached-> $_isConnected');
      } else if (event['event'] == 'disConnected') {
        setState(() {
          _isConnected = false;
          _resetCapturing();
        });
        logIt('onDeviceDetached-> $_isConnected');
      }
    });
  }

  Future<File> _createFileFromUint8List(
      Uint8List imageBytes, String fileName) async {
    logIt('filename-> $fileName');
    final tempDir = await getTemporaryDirectory();
    final kFile = await File('${tempDir.path}/$fileName.png').create();
    if (kFile.existsSync()) {
      kFile.deleteSync();
    }
    kFile.writeAsBytesSync(imageBytes);
    return Future.value(kFile);
  }

  _saveFingerprint() {
    List<dynamic> imageList = [];
    String? fingerPrintValue;
    String? fingerPrintQuality;
    String? fingerPrintName;

    for (var element in _leftHandList) {
      if (element.fingerValue != null) {
        /// Finger Image
        imageList.add(element.file!.absolute.path);

        /// FingerQuality
        if (fingerPrintQuality == null) {
          fingerPrintQuality = element.quality.toString();
        } else {
          fingerPrintQuality =
              '$fingerPrintQuality~${element.quality.toString()}';
        }

        /// FingerValue
        if (fingerPrintValue == null) {
          fingerPrintValue = element.fingerValue.toString();
        } else {
          fingerPrintValue =
              '$fingerPrintValue~${element.fingerValue.toString()}';
        }

        /// FingerName
        if (fingerPrintName == null) {
          fingerPrintName = element.fingerName.toString();
        } else {
          fingerPrintName = '$fingerPrintName~${element.fingerName.toString()}';
        }
      }
    }

    for (var element in _rightHandList) {
      if (element.fingerValue != null) {
        /// Finger Image
        imageList.add(element.file!.absolute.path);

        /// FingerQuality
        if (fingerPrintQuality == null) {
          fingerPrintQuality = element.quality.toString();
        } else {
          fingerPrintQuality =
              '$fingerPrintQuality~${element.quality.toString()}';
        }

        /// FingerValue
        if (fingerPrintValue == null) {
          fingerPrintValue = element.fingerValue.toString();
        } else {
          fingerPrintValue =
              '$fingerPrintValue~${element.fingerValue.toString()}';
        }

        /// FingerName
        if (fingerPrintName == null) {
          fingerPrintName = element.fingerName.toString();
        } else {
          fingerPrintName = '$fingerPrintName~${element.fingerName.toString()}';
        }
      }
    }

    Map jsonBody = {
      'user_id': getUserId(),
      'emp_code': widget.empCode,
      'comp_code': widget.compCode,
      'fingerprint_quality': fingerPrintQuality,
      'fingerprint_value': fingerPrintValue,
      'finger_name': fingerPrintName,
    };

    WebService.multipartGalleryImagesApi(
            AppConfig.uploadFingerPrint, this, jsonBody, imageList)
        .callMultipartCreateGalleryService(context,
            fileName: 'fingerprint_image[]');
  }

  _getAllFingerprint() {
    Map jsonBody = {'user_id': getUserId(), 'emp_code': widget.empCode};
    WebService.fromApi(AppConfig.listOfFingerprint, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.listOfFingerprint:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var fingerList = data['content'] as List;

              for (var finger in fingerList) {
                for (var leftFinger in _leftHandList) {
                  if (getString(finger, 'fingerprint_name') ==
                      leftFinger.fingerName) {
                    leftFinger.isDone = true;
                    leftFinger.quality =
                        int.parse(getString(finger, 'fingerprint_quality'));
                  }
                }

                for (var rightFinger in _rightHandList) {
                  if (getString(finger, 'fingerprint_name') ==
                      rightFinger.fingerName) {
                    rightFinger.isDone = true;
                    rightFinger.quality =
                        int.parse(getString(finger, 'fingerprint_quality'));
                  }
                }
              }

              setState(() {});
            }
          }
          break;

        case AppConfig.uploadFingerPrint:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, getString(data, 'message'), 'Error',
                  onOk: () {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err, $stack');
    }
  }

  @override
  void dispose() {
    if (_isPlatformSupported) mfsStream?.cancel();
    super.dispose();
  }
}
