import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/datamodel/ContactModel.dart';
import 'package:dataproject2/datamodel/DataModel.dart';
import 'package:dataproject2/datamodel/ImagesModel.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AddContact extends StatefulWidget {
  final String type;
  final String? accCode;
  final String? imageBaseUrl;
  final ContactModel? model;

  /// type: e.g. Edit, Add
  const AddContact(
      {Key? key,
      required this.type,
      required this.accCode,
      this.model,
      this.imageBaseUrl})
      : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

/// file_name_id
class _AddContactState extends State<AddContact> with NetworkResponse {
  double? screenWidth;
  List<ImagesModel> imageList = [];
  RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  var urlValidator = RegExp(
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
      caseSensitive: false);

  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _mobile2Controller = TextEditingController();
  final _phoneController = TextEditingController();
  final _faxController = TextEditingController();
  final _emailController = TextEditingController();
  final _email2Controller = TextEditingController();
  final _email3Controller = TextEditingController();
  final _webSiteController = TextEditingController();

  String? _titleCode = '';
  String? _countryCode = '';
  String? stateCode = '';
  String? _cityCode = '';

  bool isActive = true;
  bool isSendMail = false;
  bool isSendLedger = false;
  int imagePos = 0;
  String? imgBaseUrl = '';
  bool isLocal = true;

  List<DataModel> _titleList = [];
  List<DataModel> _countryList = [];
  List<DataModel> _stateList = [];
  List<DataModel> _cityList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getTitle();
      //  _getCountry();
      _getCity();
      if (widget.type == 'Edit') {
        isLocal = false;
        _titleController.text = widget.model!.title!;
        _titleCode = widget.model!.titleId;
        _nameController.text = widget.model!.name!;
        _addressController.text = widget.model!.address!;
        _address2Controller.text = widget.model!.address2!;
        _cityController.text = widget.model!.city!;
        _cityCode = widget.model!.cityId;
        _stateController.text = widget.model!.state!;
        stateCode = widget.model!.stateId;
        _countryController.text = widget.model!.country!;
        _countryCode = widget.model!.countryId;
        _pinCodeController.text = widget.model!.pinCode!;
        _mobileController.text = widget.model!.mobile!;
        _mobile2Controller.text = widget.model!.mobile2!;
        _phoneController.text = widget.model!.phone!;
        _faxController.text = widget.model!.fax!;
        _emailController.text = widget.model!.email!;
        _email2Controller.text = widget.model!.email2!;
        _email3Controller.text = widget.model!.email3!;
        _webSiteController.text = widget.model!.website!;
        imgBaseUrl = widget.imageBaseUrl;
        widget.model!.imageList!.forEach((element) {
          imageList.add(ImagesModel(isLocal: false, imagePath: element));
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'Add' ? 'Add Contact' : 'Edit Contact'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Item Images
                  SizedBox(
                    height: screenWidth! / 1.26,
                    child: Container(
                      width: screenWidth,
                      height: screenWidth! / 1.26,
                      child: imageList.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: PhotoViewGallery.builder(
                                    backgroundDecoration:
                                        BoxDecoration(color: Colors.white),
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    builder:
                                        (BuildContext context, int imgIndex) {
                                      imagePos = imgIndex;
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: (imageList[imgIndex]
                                                    .isLocal
                                                ? FileImage(
                                                    imageList[imgIndex].path!)
                                                : NetworkImage(
                                                    '$imgBaseUrl${imageList[imgIndex].imagePath}.png'))
                                            as ImageProvider<Object>?,
                                        initialScale:
                                            PhotoViewComputedScale.contained *
                                                0.9,
                                      );
                                    },
                                    onPageChanged: (value) {
                                      setState(() {
                                        imagePos = value;
                                      });
                                    },
                                    itemCount: imageList.length,
                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        child: CircularProgressIndicator(
                                          value: event == null
                                              ? 0
                                              : event.cumulativeBytesLoaded /
                                                  event.expectedTotalBytes!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (imageList[imagePos].isLocal) {
                                          imageList.removeAt(imagePos);
                                          setState(() {});
                                        } else {
                                          _deleteImage();
                                        }
                                      },
                                      // color: AppColor.appRed,
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _getImage();
                                      },
                                      // color: AppColor.appRed,
                                      child: Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'images/noImage.png',
                                      height: screenWidth! / 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _getImage();
                                        },
                                        // color: AppColor.appRed,
                                        child: Text(
                                          'Add',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
                    ),
                  ),

                  /// Carousel Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageList.length, (index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: imagePos == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }),
                  ),

                  /// Title
                  TextFormField(
                    controller: _titleController,
                    readOnly: true,
                    validator: (value) =>
                        _titleCode!.isEmpty ? 'Title is required' : null,
                    onTap: () async {
                      _showTitleSheet();
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: 'Title',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Name
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Name is required' : null,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Address
                  TextFormField(
                    controller: _addressController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Address is required' : null,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Address 2
                  TextFormField(
                    controller: _address2Controller,
                    decoration: InputDecoration(
                        labelText: 'Address 2',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// City
                  TextFormField(
                    controller: _cityController,
                    readOnly: true,
                    onTap: () {
                      _showCitySheet();
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'City is required' : null,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: 'City',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// State
                  TextFormField(
                    controller: _stateController,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'State is required' : null,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: 'State',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Country
                  TextFormField(
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _countryController,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Country is required' : null,
                    decoration: InputDecoration(
                        labelText: 'Country',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Pin Code
                  TextFormField(
                    controller: _pinCodeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value!.trim().isEmpty
                        ? 'Pin Code is required'
                        : (value.trim().length != 6
                            ? 'Enter valid Pin Code'
                            : null),
                    decoration: InputDecoration(
                        labelText: 'Pin Code',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Mobile
                  TextFormField(
                    controller: _mobileController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Mobile is required'
                        : (value.trim().length != 10
                            ? 'Enter valid mobile no'
                            : null),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: 'Mobile',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Mobile 2
                  TextFormField(
                    controller: _mobile2Controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.trim().isNotEmpty
                        ? (value.trim().length != 10
                            ? 'Enter valid mobile no'
                            : null)
                        : null,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: 'Mobile 2',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value!.trim().isNotEmpty
                        ? (value.trim().length < 10
                            ? 'Enter valid Phone no'
                            : null)
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Fax
                  TextFormField(
                    controller: _faxController,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value!.trim().isNotEmpty
                        ? (value.trim().length < 10
                            ? 'Enter valid Phone no'
                            : null)
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Fax',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Email
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Email is required'
                        : (!emailValidator.hasMatch(value)
                            ? 'Enter valid email'
                            : null),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Email 2
                  TextFormField(
                    controller: _email2Controller,
                    validator: (value) => value!.isNotEmpty
                        ? (!emailValidator.hasMatch(value)
                            ? 'Enter valid email'
                            : null)
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: 'Email 2',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Email 3
                  TextFormField(
                    controller: _email3Controller,
                    validator: (value) => value!.isNotEmpty
                        ? (!emailValidator.hasMatch(value)
                            ? 'Enter valid email'
                            : null)
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: 'Email 3',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  /// Website
                  TextFormField(
                    controller: _webSiteController,
                    keyboardType: TextInputType.url,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    /*validator: (value) => value.isNotEmpty
                        ? (!urlValidator.hasMatch(value)
                            ? 'Enter valid website'
                            : null)
                        : null,*/
                    decoration: InputDecoration(
                        labelText: 'Website',
                        labelStyle: TextStyle(fontSize: 18),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  SizedBox(height: 12),

                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isActive,
                              onChanged: (v) {
                                setState(() {
                                  isActive = !isActive;
                                });
                              }),
                          Text(
                            'Active',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isSendMail,
                              onChanged: (v) {
                                setState(() {
                                  isSendMail = !isSendMail;
                                });
                              }),
                          Text(
                            'Send Mail Automatically',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isSendLedger,
                              onChanged: (v) {
                                setState(() {
                                  isSendLedger = !isSendLedger;
                                });
                              }),
                          Text(
                            'Send Ledger To Party',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.type == 'Add') {
                              _addContact();
                            } else {
                              _updateContact();
                            }
                          }
                        },
                        // color: AppColor.appRed,
                        child: Text(
                          widget.type == 'Add' ? 'Submit' : 'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _deleteImage() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code': imageList[imagePos].imagePath
    };
    WebService.fromApi(AppConfig.deleteContactImage, this, jsonBody)
        .callPostService(context);
  }

  _getImage() async {
    var data = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageEditor()));

    logIt('getImage-> $data');
    if (data == null) return;
    var mFile = data['file'];

    imageList.add(ImagesModel(path: mFile));
    setState(() {});
  }

  _getTitle() {
    Map jsonBody = {'user_id': getUserId(), 'table_name': 'TITLE_MASTER'};
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'TITLE_MASTER')
        .callPostService(context);
  }

  getCountry() {
    Map jsonBody = {'user_id': getUserId(), 'table_name': 'COUNTRY_MASTER'};
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'COUNTRY_MASTER')
        .callPostService(context);
  }

  _getState() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'STATE_MASTER',
      'country_code': _countryCode
    };
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'STATE_MASTER')
        .callPostService(context);
  }

  _getCity() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'CITY_MASTER',
      //'state_code': _stateCode
    };
    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: 'CITY_MASTER')
        .callPostService(context);
  }

  _addContact() {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': widget.accCode,
      'title_code': _titleCode,
      'name': _nameController.text.trim(),
      'add1': _addressController.text.trim(),
      'add2': _address2Controller.text.trim(),
      'city_code': _cityCode,
      'pin_code': _pinCodeController.text.trim(),
      'mobile_no1': _mobileController.text.trim(),
      'mobile_no2': _mobile2Controller.text.trim(),
      'ph_no': _phoneController.text.trim(),
      'fax_no': _faxController.text.trim(),
      'url_id': _webSiteController.text.trim(),
      'email_id': _emailController.text.trim(),
      'email_id_2': _email2Controller.text.trim(),
      'email_id_3': _email3Controller.text.trim(),
      'active_tag': isActive ? 'Y' : 'N',
      'send_email': isSendMail ? 'Y' : 'N',
      'send_ledger': isSendLedger ? 'Y' : 'N',
    };

    logIt('postParams-> $jsonBody');

    var imgFileList = [];

    imageList.forEach((element) {
      imgFileList.add(element.path!.absolute.path);
    });

    if (imgFileList.isEmpty) {
      WebService.fromApi(AppConfig.addContact, this, jsonBody)
          .callPostService(context);
    } else {
      WebService.multipartGalleryImagesApi(
              AppConfig.addContact, this, jsonBody, imgFileList)
          .callMultipartCreateGalleryService(context);
    }
  }

  _updateContact() {
    var imgFileList = [];
    String? imageId;

    imageList.forEach((element) {
      if (element.isLocal) {
        imgFileList.add(element.path!.absolute.path);
        if (imageId == null) {
          imageId = '0';
        } else {
          imageId = '$imageId,0';
        }
      }
    });

    Map jsonBody = {
      'code': widget.model!.id,
      'user_id': getUserId(),
      'acc_code': widget.accCode,
      'title_code': _titleCode,
      'name': _nameController.text.trim(),
      'add1': _addressController.text.trim(),
      'add2': _address2Controller.text.trim(),
      'city_code': _cityCode,
      'pin_code': _pinCodeController.text.trim(),
      'mobile_no1': _mobileController.text.trim(),
      'mobile_no2': _mobile2Controller.text.trim(),
      'ph_no': _phoneController.text.trim(),
      'fax_no': _faxController.text.trim(),
      'url_id': _webSiteController.text.trim(),
      'email_id': _emailController.text.trim(),
      'email_id_2': _email2Controller.text.trim(),
      'email_id_3': _email3Controller.text.trim(),
      'active_tag': isActive ? 'Y' : 'N',
      'send_email': isSendMail ? 'Y' : 'N',
      'send_ledger': isSendLedger ? 'Y' : 'N',
      if (imgFileList.isNotEmpty) 'filename_id': imageId,
    };

    logIt('postParams-> $jsonBody');

    if (imgFileList.isEmpty) {
      WebService.fromApi(AppConfig.updateContact, this, jsonBody)
          .callPostService(context);
    } else {
      WebService.multipartGalleryImagesApi(
              AppConfig.updateContact, this, jsonBody, imgFileList)
          .callMultipartCreateGalleryService(context);
    }
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case 'TITLE_MASTER':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _titleList.clear();
              _titleList.addAll(content.map((e) => DataModel.fromJSON(e)));
              logIt('Title List-> ${_titleList.length}');
              if (_titleList.isNotEmpty && widget.type == 'Add') {
                _titleController.text = _titleList[0].name!;
                _titleCode = _titleList[0].id;
              }
              setState(() {});
            }
          }
          break;

        case 'COUNTRY_MASTER':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _countryList.clear();
              _countryList.addAll(content.map((e) => DataModel.fromJSON(e)));
              logIt('_countryList List-> ${_countryList.length}');
              if (_countryList.isNotEmpty && widget.type == 'Add') {
                _countryList.forEach((element) {
                  if (element.name == 'INDIA') {
                    _countryController.text = element.name!;
                    _countryCode = element.id;
                    _getState();
                  }
                });
              }
              _getState();

              setState(() {});
            }
          }
          break;

        case 'STATE_MASTER':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _stateList.clear();
              _stateList.addAll(content.map((e) => DataModel.fromJSON(e)));
              setState(() {});
            }
          }
          break;

        case 'CITY_MASTER':
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _cityList.clear();
              _cityList.addAll(content.map((e) => DataModel.fromJSONCity(e)));
              setState(() {});
            }
          }
          break;

        case AppConfig.updateContact:
        case AppConfig.addContact:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, data['message'], 'Failed!');
            }
          }
          break;

        case AppConfig.deleteContactImage:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                imageList.removeAt(imagePos);
                setState(() {});
              });
            } else {
              showAlert(context, data['message'], 'Failed!');
            }
          }
      }
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }

  _showTitleSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _titleList.length,
                  (index) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index + 1} ${_titleList[index].name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    enabled: !_titleList[index].isSelected,
                    onTap: () async {
                      _titleController.text = _titleList[index].name!;
                      _titleCode = _titleList[index].id;
                      popIt(context);
                    },
                  ),
                ),
              ),
            ),
          ));
        });
  }

  showCountrySheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _countryList.length,
                  (index) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index + 1} ${_countryList[index].name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    enabled: !_countryList[index].isSelected,
                    onTap: () async {
                      _countryController.text = _countryList[index].name!;
                      _countryCode = _countryList[index].id;
                      popIt(context);
                    },
                  ),
                ),
              ),
            ),
          ));
        });
  }

  showStateSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _stateList.length,
                  (index) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index + 1} ${_stateList[index].name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    enabled: !_stateList[index].isSelected,
                    onTap: () async {
                      _stateController.text = _stateList[index].name!;
                      stateCode = _stateList[index].id;
                      _getCity();
                      popIt(context);
                    },
                  ),
                ),
              ),
            ),
          ));
        });
  }

  _showCitySheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              margin: EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  TypeAheadFormField<DataModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select city' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${itemData.name}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${itemData.stateName}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        enabled: !itemData.isSelected,
                      );
                    },
                    onSuggestionSelected: (sg) {
                      if (sg.isSelected) return;
                      Navigator.of(context).pop();
                      _cityController.text = sg.name!;
                      _stateController.text = sg.stateName!;
                      _countryController.text = sg.countryName!;
                      _cityCode = sg.id;
                      // });
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredCities(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        onChanged: (string) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: 'Search City',
                            isDense: true)),
                  ),
                ],
              ));
        });
  }

  _getFilteredCities(String char) {
    logIt('CityListSize-> ${_cityList.length}');
    return _cityList
        .where((i) => (i.name!.toLowerCase().startsWith(char.toLowerCase()) ||
            i.stateName!.toLowerCase().startsWith(char.toLowerCase())))
        .toList();
  }
}
