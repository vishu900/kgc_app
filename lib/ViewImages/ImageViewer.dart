import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart' as web;
import 'package:dataproject2/quotation/ViewPdf.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:open_file/open_file.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'ImageDocModel.dart';

class ImageViewer extends StatefulWidget {
  final itemCode;

  ImageViewer({required this.itemCode});

  @override
  State<StatefulWidget> createState() => _ImageViewer();
}

class _ImageViewer extends State<ImageViewer> with NetworkResponse {
  List<ImageDocModel> galleryItems = [];

  PageController pageController = PageController();
  var position = 0;
  String? imageBaseUrl = '';
  bool isAdmin = false;
  String imageCode = '';
  String mediaType = 'Image';
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    setState(() {
      logIt('IsAdmin-> ${AppConfig.prefs.getBool('isAdmin')}');
      if (AppConfig.prefs.getBool('isAdmin') != null &&
          AppConfig.prefs.getBool('isAdmin')!) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: mediaType == 'Image',
            child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  downloadImage();
                }),
          ),
          Visibility(
              visible: isAdmin,
              child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showAlert(
                        context, 'Do you want to delete?', 'Delete Warning!',
                        notOk: 'No',
                        onNo: () {
                          popIt(context);
                        },
                        ok: 'Delete',
                        onOk: () {
                          _deleteItemImage();
                        });
                  })),
          SizedBox(width: 4)
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                onTapUp: (context, _, val) {
                  if (galleryItems[index].mediaType != 'Image') {
                    Map json = {
                      'user_id': getUserId(),
                      'code_pk': galleryItems[index].id.split('.')[0]
                    };
                    web.WebService.fromApi(AppConfig.viewCatalogPdf, this, json)
                        .callPostService(context);
                  }
                },
                imageProvider: galleryItems[index].mediaType == 'Image'
                    ? NetworkImage('$imageBaseUrl${galleryItems[index].id}')
                    : _getFileIcon(
                        galleryItems[index].id.fileExt().toLowerCase()),
                initialScale: PhotoViewComputedScale.contained * 0.9,
              );
            },
            itemCount: galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  // backgroundColor: Color(0xFFFF0000).withOpacity(0.70),
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            pageController: pageController,
            onPageChanged: (pos) {
              imageCode = galleryItems[pos].id.split('.')[0];
              mediaType = galleryItems[pos].mediaType;
              _onPageChanged(pos);
              setState(() {});
            },
          )),
          Visibility(
            visible: isDownloading,
            child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator()),
                    /*  Positioned(
                        top: 12,
                        left: 6,
                        child: Text(
                          '${_progress.toStringAsFixed(1)}%',
                          style: TextStyle(color: Colors.white),
                        )),*/
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                galleryItems.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: position == index
                                  ? Color(0xFFFF0000).withOpacity(0.70)
                                  : Colors.transparent)),
                      height: 128,
                      width: 128,
                      child: galleryItems[index].mediaType == 'Image'
                          ? Image.network(
                              '$imageBaseUrl${galleryItems[index].id}')
                          : _getFileIconWidget(
                              galleryItems[index].id.fileExt().toLowerCase()),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return AssetImage('images/pdf.png');
      case 'jpg':
        return AssetImage('images/jpg.png');
      case 'txt':
        return AssetImage('images/txt.png');
      case 'xlsx':
        return AssetImage('images/xls.png');
      case 'docx':
        return AssetImage('images/doc.png');
    }
  }

  _getFileIconWidget(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Image.asset('images/pdf.png');
      case 'jpg':
        return Image.asset('images/jpg.png');
      case 'txt':
        return Image.asset('images/txt.png');
      case 'xlsx':
        return Image.asset('images/xls.png');
      case 'docx':
        return Image.asset('images/doc.png');
    }
  }

  _onPageChanged(position) {
    setState(() {
      this.position = position;
    });

    debugPrint(
        'onImageChanged $position page ${pageController.page} code-> $imageCode');
  }

  _getImages() {
    Commons().showProgressbar(context);

    logIt('TheUrlIs->${AppConfig.getImages + widget.itemCode}');

    WebService()
        .get(context, AppConfig.getImages + widget.itemCode, '')
        .then((value) => {Navigator.of(context).pop(), _parse(value!)});
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentsList = data['content'] as List;
        var docList = data['pdfcontent'] as List?;

        debugPrint('ImageViewer ${data['image_png_path']}');

        imageBaseUrl = data['image_png_path'];

        if (contentsList.isNotEmpty || docList!.isNotEmpty) {
          galleryItems.clear();

          contentsList.forEach((element) {
            String image = element;

            if (image.endsWith('.tiff')) {
              image = image.replaceAll('.tiff', '.png');
            }

            galleryItems.add(ImageDocModel(id: image, mediaType: 'Image'));
          });

          docList!.forEach((element) {
            galleryItems.add(ImageDocModel(id: element, mediaType: 'Doc'));
          });

          if (galleryItems.isNotEmpty) {
            imageCode = galleryItems[0].id.split('.')[0];
            mediaType = galleryItems[0].mediaType;
          }

          setState(() {});
        } else {
          Commons().showAlert(context, 'There is no image.', 'App Says:');
        }
      }
    }
  }

  _deleteItemImage() {
    Map jsonBody = {
      'user_id': getUserId(),
      'catalog_item_code': widget.itemCode,
      'code_pk': imageCode,
      'type': mediaType == 'Image' ? 'image' : 'pdf'
    };

    logIt('PostParams-> $jsonBody');

    web.WebService.fromApi(AppConfig.deleteCatalogMachineImage, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.deleteCatalogMachineImage:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                galleryItems.removeAt(position);
                setState(() {});
                if (galleryItems.isEmpty) {
                  popIt(context);
                } else {
                  pageController.jumpTo(0);
                  imageCode = galleryItems[0].id.split('.')[0];
                  mediaType = galleryItems[0].mediaType;
                }
              });
            } else {
              showAlert(context, data['message'], 'Success');
            }
          }
          break;

        case AppConfig.viewCatalogPdf:
          {
            var data = jsonDecode(response!);

            logIt('viewCatalogPdf-> $data');

            if (data['error'] == 'false') {
              String type = getString(data, 'file_extension');

              if (type == 'PDF') {
                Navigator.of(this.context).push(MaterialPageRoute(
                    builder: (context) => ViewPdf(
                          pdfUrl: getString(data, 'pdf_path'),
                        )));
              } else {
                _downloadPdf(getString(data, 'pdf_path'), type);
              }
            }
          }
          break;
      }
    } catch (err) {}
  }

  _downloadPdf(String url, String ext) async {
    List<int> bytes = [];

    String docCode = basename(url);

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    Commons().showProgressbar(this.context);
    logIt('File does not exist -> $file2');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);
        popIt(this.context);

        /*    var res = await OpenFile.open(file2.absolute.path);

        if (res.type != ResultType.done) {
          showAlert(this.context, res.message, 'Error');
        } */
      },
      onError: (e) {
        popIt(this.context);
        showAlert(this.context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
  }

  downloadImage() async {
    setState(() {
      isDownloading = true;
    });

    List<int> bytes = [];

    var url = '$imageBaseUrl${galleryItems[position].id}';

    logIt('Download Image-> $url');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/$imageCode.jpg';

    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        setState(() {});
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);

        setState(() {
          isDownloading = false;
        });

        logIt('Downloaded-> ${file2.absolute.path}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageEditor(
                      isUpdate: true,
                      codePk: imageCode,
                      mFile: file2,
                    )));
      },
      onError: (e) {
        setState(() {
          isDownloading = false;
        });
        showAlert(context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
    //file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    setState(() {
      // imageData = filePathAndName;
      isDownloading = false;
    });
  }
}

class ImageModel {
  String? image = '';
  String? id = '';

  ImageModel({required this.image, required this.id});

  factory ImageModel.fromJSON(Map<String, dynamic> json) {
    return ImageModel(
        image: json['image'] == null ? '' : json['image'],
        id: json[''] == null ? '' : json['id']);
  }
}
