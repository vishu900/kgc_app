import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/ViewImages/ImageViewer.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CatalogItemImages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CatalogItemImages();
}

class _CatalogItemImages extends State<CatalogItemImages> {
  File? _image;
  final picker = ImagePicker();
  String? catalogCode = '';
  String? itemCode = '';
  String? itemName = '';
  String imageCount = '';
  String char = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Catalog Item Images',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: (char) {
                            _getItemDetail(char.trim());
                          },
                          onChanged: (v) {
                            this.char = v.trim();
                            if (v.trim().isEmpty) {
                              itemCode = '';
                              setState(() {});
                            }
                          },
                          cursorColor: AppColor.appRed,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            isDense: true,
                            focusColor: AppColor.appRed,
                            border: OutlineInputBorder(),
                            labelText: 'Code',
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                          onTap: () {
                            _getItemDetail(char.trim());
                          },
                          child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      width: 1, color: Colors.grey[700]!)),
                              child:
                                  Icon(Icons.search, color: Colors.grey[700]))),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Visibility(
                    visible: itemCode!.isNotEmpty,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: TextEditingController(text: itemName),
                          readOnly: true,
                          cursorColor: AppColor.appRed,
                          decoration: InputDecoration(
                            isDense: true,
                            focusColor: AppColor.appRed,
                            border: OutlineInputBorder(),
                            labelText: 'Item Name',
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                0,
                                8.0,
                                8.0,
                              ),
                              child: Text(
                                'Total Media: $imageCount',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (imageCount == '' || imageCount == '0') {
                                  Commons.showToast('Image not available');
                                  return;
                                }

                                var mFile = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                              itemCode: catalogCode,
                                            )));

                                _getItemDetail(char.trim());

                                logIt('uploadImageMap-> $mFile');

                                if (mFile != null) {
                                  _image = mFile['file'];
                                  _updateImage(
                                      _image!.absolute.path, mFile['codePk']);
                                }
                              },
                              child: Row(
                                children: [
                                  Text('View Media',
                                      style: TextStyle(
                                        color: AppColor.appBlue,
                                        fontSize: 16,
                                      )),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: AppColor.appBlue,
                                        size: 26,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          onTap: () async {
                            _filePickerBottomSheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 36,
                                ),
                                Text(
                                  'Upload File',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _uploadImage(String filename) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id')!;

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.saveCatalogImages));

    request.files.add(await http.MultipartFile.fromPath(
      'filename[]',
      filename,
    ));

    request.fields['user_id'] = userId;
    request.fields['catalog_code'] = catalogCode!;
    request.fields['item_code'] = itemCode!;

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        _getItemDetail(catalogCode!);
        Commons.showToast('Image Uploaded Successfully');
      } else {
        Commons.showToast('Something went wrong!');
      }
    }

    debugPrint('UploadImage ${res.body}');
  }

  _uploadFile(String filename) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id')!;

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.saveCatalogImages));

    request.files.add(await http.MultipartFile.fromPath(
      'filename[]',
      filename,
    ));

    request.fields['user_id'] = userId;
    request.fields['catalog_code'] = catalogCode!;
    request.fields['item_code'] = itemCode!;

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        _getItemDetail(catalogCode!);
        Commons.showToast('File Uploaded Successfully');
      } else {
        Commons.showToast('Something went wrong!');
      }
    }

    debugPrint('UploadImage ${res.body}');
  }

  _updateImage(String filename, String codePk) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_id = prefs.getString('user_id')!;

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.updateCatalogImage));

    request.files.add(await http.MultipartFile.fromPath(
      'filename',
      filename,
    ));

    request.fields['user_id'] = user_id;
    request.fields['catalog_code'] = catalogCode!;
    request.fields['item_code'] = itemCode!;
    request.fields['code_pk'] = codePk;

    logIt(
        'Multipart_Request-> CatalogCode:$catalogCode itemCode:$itemCode codePk:$codePk ');

    debugPrint('UploadImage CatalogCode-> $catalogCode itemCode-> $itemCode');
    debugPrint(
        'UploadImage ${AppConfig.baseUrl + AppConfig.updateCatalogImage}');

    http.Response res = await http.Response.fromStream(await request.send());

    Navigator.of(this.context).pop();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        debugPrint('Image Uploaded Successfully!');
        _getItemDetail(catalogCode!);
        Commons.showToast('Image Updated Successfully');
      } else {
        Commons.showToast('Something went wrong!');
      }
    }

    debugPrint('UploadImage ${res.body}');
  }

  uploadImages(List<AssetPathEntity> imageFile) async {
    List<String> fileList = [];

    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id')!;

    // fileList = await _getCompressedImages(imageFile);

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.saveCatalogImages));

    debugPrint('<<---- Adding To Multipart ---->>');

    for (int i = 0; i < fileList.length; i++) {
      var element = fileList[i];
      request.files.add(await http.MultipartFile.fromPath(
        'filename[]',
        element,
      ));
    }

    fileList.forEach((element) async {});

    request.fields['user_id'] = user_id;
    request.fields['catalog_code'] = catalogCode!;
    request.fields['item_code'] = itemCode!;

    request.fields.forEach((key, value) {
      debugPrint('Multipart-> $Key : $value');
    });

    debugPrint('Multipart File Length-> ${request.files.length}');

    request.files.forEach((element) {
      debugPrint(
          'Multipart File -> ${element.filename}, ${element.contentType}');
    });

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        _getItemDetail(catalogCode!);
        debugPrint('Image Uploaded Successfully!');
        Commons.showToast('Image Uploaded Successfully');
      }
    }

    debugPrint('UploadImage ${res.body}');
  }

  /* Future<List<String>> _getCompressedImages(List<Asset> imageFile) async {
    List<String> fileList = [];
    final dir = await getTemporaryDirectory();

    for (int i = 0; i < imageFile.length; i++) {
      final targetPath = dir.absolute.path + "/qtnImage$i.jpg";
      var element = imageFile[i];
      var path2 = await FlutterAbsolutePath.getAbsolutePath(element.identifier);

      File _image = File(path2);

      File compFile = await Commons.compressAndGetFile(_image, targetPath);

      fileList.add(compFile.absolute.path);
    }

    debugPrint('BeforeReturningImageListSize-> ${fileList.length}');

    return fileList;
  }*/

  _getItemDetail(String itemId) {
    clearFocus(context);
    if (itemId.trim().isEmpty) {
      showAlert(context, 'Please enter code', 'Error');
      return;
    }

    String? userId = AppConfig.prefs.getString('user_id');
    var json = jsonEncode(
        <String, dynamic>{'user_id': userId, 'catalog_code': itemId});

    Commons().showProgressbar(this.context);
    WebService().post(this.context, AppConfig.getCatalogDetailsById, json).then(
        (value) => {Navigator.pop(this.context), _parseItemDetails(value!)});
  }

  _parseItemDetails(Response value) {
    if (value.statusCode == 200) {
      var res = jsonDecode(value.body);

      if (res['content'] == null) {
        itemCode = '';
        setState(() {});
        Commons.showToast('No Data Found!');
        return;
      }

      var data = res['content'];

      if (res['error'] == 'false') {
        catalogCode = data['code'];
        itemCode = data['item_code'];

        itemName =
            data['item_name'] == null ? 'N.A' : data['item_name']['name'];
        var imageList = data['item_multiple_image'] as List;
        var docList = data['item_multiple_pdf'] as List;

        imageCount = (imageList.length + docList.length).toString();
        setState(() {});
      }
    }
  }

  void _filePickerBottomSheet(context) {
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
                  child: new Text("Select File Options"),
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
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      var mFile = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageEditor()));

                                      if (mFile == null) return;
                                      _image = mFile['file'];

                                      setState(() {});

                                      _uploadImage(_image!.absolute.path);
                                    }),
                                SizedBox(width: 10),
                                Text("Upload Image")
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
                                  icon: Icon(Icons.file_copy_outlined),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf',
                                        'doc',
                                        'txt',
                                        'xlsx',
                                        'docx'
                                      ],
                                    );

                                    if (result != null) {
                                      File mFile =
                                          File(result.files.single.path!);

                                      // ignore: unnecessary_null_comparison
                                      if (mFile == null) return;

                                      _image = mFile;

                                      setState(() {});

                                      _uploadFile(_image!.absolute.path);
                                    }
                                  }),
                              SizedBox(width: 10),
                              Text("Upload File")
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
}
