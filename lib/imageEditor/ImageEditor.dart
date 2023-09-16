//ImageEditor

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'Sliders.dart';
import 'colors_picker.dart';

class ImageEditor extends StatefulWidget {
  ImageEditor(
      {Key? key,
      this.title = '',
      this.isUpdate = false,
      this.isDoubleTap = true,
      this.codePk,
      this.mFile})
      : super(key: key);

  final String title;

  final String? codePk;
  final bool isUpdate;
  final bool isDoubleTap;
  final File? mFile;

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  File? mFile;
  final picker = ImagePicker();
  final _repaintKey = GlobalKey();
  Uint8List? memoryImage;
  bool accepted = false;
  Offset offset = Offset.zero;

  late double height;
  late double width;

  /// Text Widget Variables
  List<Offset> offsets = [];
  List widgetList = [];
  List fontSize = [];
  List fontColor = [];
  int? selectedPosition;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();

  String originalImageSize = '';
  String afterCompImageSize = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isUpdate) {
        setState(() {
          mFile = widget.mFile;
          logIt('ImageEditor -> ${widget.mFile}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Visibility(
            visible: selectedPosition != null,
            child: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    offsets.removeAt(selectedPosition!);
                    widgetList.removeAt(selectedPosition!);
                    fontSize.removeAt(selectedPosition!);
                    fontColor.removeAt(selectedPosition!);
                    selectedPosition = null;
                  });
                }),
          ),
          Visibility(
            visible: mFile != null,
            child: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 28,
                ),
                onPressed: () {
                  mFile = null;
                  memoryImage = null;
                  offset = Offset.zero;
                  widgetList.clear();
                  offsets.clear();
                  fontSize.clear();
                  setState(() {});
                }),
          ),
          Visibility(
            visible: mFile != null,
            child: IconButton(
                icon: Icon(
                  Icons.cloud_upload,
                  size: 28,
                ),
                onPressed: () async {
                  final _image = await _captureImage();
                  // ignore: unnecessary_null_comparison
                  if (_image == null) {
                    return;
                  }
                  final tempDir = await getTemporaryDirectory();
                  final kFile = await File(
                          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg')
                      .create();
                  if (kFile.existsSync()) {
                    kFile.deleteSync();
                  }
                  kFile.writeAsBytesSync(_image);

                  Map map;
                  if (!widget.isUpdate) {
                    map = {
                      'file': kFile,
                    };
                    Navigator.pop(context, map);
                  } else {
                    map = {
                      'file': kFile,
                      'codePk': widget.codePk,
                    };

                    if (widget.isDoubleTap) {
                      Navigator.pop(context);
                    }
                    Navigator.pop(context, map);
                  }
                }),
          ),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Center(
              child: mFile != null
                  ? RepaintBoundary(
                      key: _repaintKey,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.file(
                              mFile!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Stack(
                            children: widgetList
                                .asMap()
                                .entries
                                .map((f) => Positioned(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      child: GestureDetector(
                                        onPanUpdate: (details) {
                                          setState(() {
                                            setState(() {
                                              offsets[f.key] = Offset(
                                                  offsets[f.key].dx +
                                                      details.delta.dx,
                                                  offsets[f.key].dy +
                                                      details.delta.dy);
                                            });
                                          });
                                        },
                                        onLongPress: () {
                                          selectedPosition = f.key;
                                          setState(() {});
                                        },
                                        onTap: () {
                                          if (selectedPosition == f.key) {
                                            selectedPosition = null;
                                            setState(() {});
                                            return;
                                          }
                                          showCustomization(f);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedPosition == f.key
                                                ? Colors.white54
                                                : Colors.white.withOpacity(0),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            f.value.toString(),
                                            style: TextStyle(
                                                color: fontColor[f.key],
                                                fontSize:
                                                    fontSize[f.key].toDouble()),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      onTap: () {
                        _imageBottomSheet(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: (height + width) * 12,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                            child: Text(
                              'No Image Selected',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: height * 2.5),
                            ),
                          ),
                        ],
                      ),
                    ),
            )),
      ),
      bottomNavigationBar: Visibility(
        visible: mFile != null,
        child: Container(
          color: AppColor.appRed,
          width: width * 100,
          height: height * 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    selectedPosition == null ? Icons.text_fields : Icons.edit,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (selectedPosition != null) {
                      addText(f: selectedPosition);
                    } else {
                      addText();
                    }
                  }),
              IconButton(
                  icon: Icon(
                    Icons.crop,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final _image = await _captureImage();
                    // ignore: unnecessary_null_comparison
                    if (_image == null) return;
                    final tempDir = await getTemporaryDirectory();
                    final kFile =
                        await new File('${tempDir.path}/image.jpg').create();
                    kFile.writeAsBytesSync(_image);

                    print('File_is-> ${kFile.absolute.path}');
                    print('File_is-> ${await kFile.exists()}');
                    cropImage(kFile);

                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _imageBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 10.9, color: Colors.grey[400]!)
            ]),
            height: 170,
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text("Select Image Options"),
                ),
                Divider(
                  height: 1,
                ),
                new Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.photo_library),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      getImage(ImageSource.gallery);
                                    }),
                                SizedBox(width: 10),
                                Text("Open Gallery")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    getImage(ImageSource.camera);
                                  }),
                              SizedBox(width: 10),
                              Text("Open Camera")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showCustomization(MapEntry<int, dynamic> f) {
    showModalBottomSheet(
        enableDrag: false,
        barrierColor: Colors.white.withOpacity(0),
        isDismissible: true,
        builder: (BuildContext ctx) {
          return Card(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sliders(
                  sizevalue: fontSize[f.key].toDouble(),
                  onChanged: (v) {
                    fontSize[f.key] = v.toInt();
                    setState(() {});
                  },
                  onChangeEnd: (v) {
                    fontSize[f.key] = v.toInt();
                    setState(() {});
                  },
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text("Color"),
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(height: 20),
                BarColorPicker(
                    width: 300,
                    initialColor: fontColor[f.key],
                    thumbColor: Colors.white,
                    cornerRadius: 10,
                    pickMode: PickMode.Color,
                    colorListener: (int value) {
                      setState(() {
                        fontColor[f.key] = Color(value);
                      });
                    }),
                SizedBox(height: 20),
              ],
            ),
          );
        },
        context: context);
  }

  getImage(ImageSource imgSrc) async {
    final pickedFile = await picker.pickImage(source: imgSrc);
    if (pickedFile != null) {
      mFile = File(pickedFile.path);
      if (mFile == null) return;
      await cropImage(mFile);

      if (mFile != null) {
        // final dir = await getTemporaryDirectory();
        // final targetPath = dir.absolute.path + "/qtnImage.jpg";

        originalImageSize = filesize(mFile!.lengthSync());
        afterCompImageSize = filesize(mFile!.lengthSync());
        logIt('afterComp File Size is-> ${filesize(mFile!.lengthSync())}');
      }
    } else {
      print('No image selected.');
    }
  }

  Future cropImage(File? file) async {
    if (file != null) {
      if (!File(file.absolute.path).existsSync()) return;

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      /*  File croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'BK',
              toolbarColor: AppColor.appRed,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              activeControlsWidgetColor: AppColor.appRed),
          iosUiSettings: IOSUiSettings())]; */
      //minimumAspectRatio: 1.0, aspectRatioLockEnabled: true
      if (croppedFile == null) return;
      mFile = File(croppedFile.path);
      ;
      setState(() {});
    }
  }

  Future<Uint8List> _captureImage() async {
    // ignore: null_argument_to_non_null_type
    if (_repaintKey.currentContext == null) return Future.value();
    final RenderRepaintBoundary renderRepaintBoundary =
        _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await renderRepaintBoundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    return Future.value(bytes!.buffer.asUint8List());
  }

  addText({int? f}) {
    print('addText $f');
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController textCont =
        TextEditingController(text: f != null ? widgetList[f] : '');
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Text'),
            content: Form(
              key: formKey,
              child: TextFormField(
                validator: (val) =>
                    val!.trim().isEmpty ? 'Please add Text' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: textCont,
                decoration: InputDecoration(
                    hintText: 'Add text here',
                    suffixIcon: Icon(Icons.text_fields)),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    if (f != null) {
                      widgetList[f] = textCont.text.trim();
                    } else {
                      widgetList.add(textCont.text.trim());
                      fontSize.add(20);
                      fontColor.add(Colors.black);
                      offsets.add(Offset.zero);
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(f != null ? 'Update' : 'Add')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }

  showImageInfo() {
    AlertDialog alert = AlertDialog(
      title: Text('Image Info'),
      content: Table(
        // border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text(
              'Original Size: ',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              originalImageSize,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'After Compression: ',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                afterCompImageSize,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            )
          ]),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );

    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: alert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }
}
