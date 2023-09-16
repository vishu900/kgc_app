import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/datamodel/TermsModel.dart';
import 'package:dataproject2/datamodel/UomModel.dart';
import 'package:dataproject2/itemMaster/ItemSearch.dart';
import 'package:dataproject2/itemMaster/ItemSearchCatalog.dart';
import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart' as web;
import 'package:dataproject2/newmodel/ItemMasterModel.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/quotation/PartyModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/RegExInputFormatter.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddressModel.dart';
import 'SendEmail.dart';
import 'ViewPdf.dart';

class QuotationForm extends StatefulWidget {
  final qtnId;

  const QuotationForm({Key? key, this.qtnId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuotationForm();
}

class _QuotationForm extends State<QuotationForm> with NetworkResponse {
  int _currentPosition = 1;
  List<ItemMasterModel> itemList = [];
  List<TermsModel> termsList = [];
  List<TermsModel> selectedTermsList = [];

  var diff = SizedBox(
    height: 12,
  );

  TextEditingController _companyController = TextEditingController();
  TextEditingController _partyController = TextEditingController();
  TextEditingController _entryDateController = TextEditingController();
  TextEditingController _finYearController = TextEditingController();
  TextEditingController _QtyNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _termController = TextEditingController();
  TextEditingController _addCatalogController = TextEditingController();

  PageController _pageController = PageController(initialPage: 0);
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  GlobalKey<FormState> _catalogKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<QCompanyModel> companyList = [];
  List<PartyModel> partyList = [];
  List<PartyModel> mainPartyList = [];
  List<AddressModel> addressList = [];
  List<UomModel> uomList = [];
  List<UomModel> brandList = [];
  List<UomModel> shadeList = [];
  List<UomModel> catParamsList = [];

  final picker = ImagePicker();
  bool isEditable = false;
  DateTime now = DateTime.now();
  bool isDownloading = false;
  var response;
  String? date;
  late File _image;
  String? companyCode = '';
  String addressCode = '';
  String? uploadImageName = '';
  String? partyCode = '';
  String? rankCode = '';
  String? imageBaseUrl = '';
  String? imageCatalogBaseUrl = '';
  String imageSize = '';
  BuildContext? ctx;
  String? imgBaseUrl = '';
  int _current = 0;

  final numberReg = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _getUomList();
      _getBrandList();
      _getShadeList();

      _getCompanyList();
      _getTerms();
      if (widget.qtnId != null) {
        /*_getCompanyList();
        _getTerms();*/
        _getQtnDetail();
      }
    });

    if (widget.qtnId == null) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.qtnId == null
              ? 'Sale Quotation'
              : (isEditable ? 'Edit Sale Quotation' : 'View Sale Quotation'),
        ),
        backgroundColor: Color(0xFFFF0000),
        actions: [
          Visibility(
              visible: (widget.qtnId != null && !isEditable),
              maintainState: widget.qtnId != null,
              maintainAnimation: widget.qtnId != null,
              child: Visibility(
                visible: ifHasPermission(
                    permType: PermType.MODIFIED,
                    compCode: companyCode,
                    permission: Permissions.SALE_QTN)!,
                child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditable = true;
                      });
                      //Commons.showToast('This functionality is under maintenance.');
                    }),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),

                /// Enter Date
                TextFormField(
                  onTap: () {
                    if (isEditable || widget.qtnId == null) {
                      _selectDate();
                    }
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter date' : null,
                  controller: _entryDateController,
                  readOnly: true,
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Enter Date',
                    // labelText: 'Enter Date'
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Financial Year
                TextFormField(
                  //  readOnly: !(isEditable || widget.qtnId == null),
                  readOnly: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter financial year' : null,
                  controller: _finYearController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Financial Year',
                      labelText: 'Financial Year'),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Number
                TextFormField(
                  readOnly: !(isEditable || widget.qtnId == null),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter number' : null,
                  controller: _QtyNumberController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Number',
                      labelText: 'Number'),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Company Name
                TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select company name' : null,
                    onTap: () {
                      if (isEditable || widget.qtnId == null) {
                        _companyBottomSheet(context);
                      }
                    },
                    controller: _companyController,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        border: OutlineInputBorder(),
                        hintText: 'Company Name',
                        isDense: true)),

                SizedBox(
                  height: 20,
                ),

                /// Party Name
                TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select party name' : null,
                    onTap: () {
                      if (isEditable || widget.qtnId == null) {
                        if (partyList.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select a company first.',
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red);
                        } else {
                          _partyBottomSheet(context);
                        }
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _partyController,
                    readOnly: true,
                    style: TextStyle(),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        border: OutlineInputBorder(),
                        hintText: 'Party Name',
                        isDense: true)),

                SizedBox(
                  height: 20,
                ),

                /// Address
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please select address' : null,
                  controller: _addressController,
                  readOnly: true,
                  style: TextStyle(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () {
                    if (isEditable || widget.qtnId == null) {
                      if (partyList.isEmpty) {
                        Commons.showToast('Please select a party first.');
                      } else {
                        _partyAddressSheet(context);
                      }
                    }
                  },
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Address',
                    // labelText: 'Address'
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Remarks
                TextFormField(
                  style: TextStyle(),
                  readOnly: !(isEditable || widget.qtnId == null),
                  controller: _remarksController,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  minLines: 3,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Remarks',
                      hintStyle: TextStyle(),
                      labelText: 'Remarks'),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Upload Image
                TextFormField(
                  controller: _imageController,
                  // validator: (value) => value.isEmpty ? 'Please select image' : null,
                  readOnly: true,
                  onTap: () {
                    if (isEditable || widget.qtnId == null) {
                      _imageBottomSheet(context);
                    } else {
                      if (uploadImageName!.isNotEmpty) {
                        _imageViewerBottomSheet(context);
                      } else {
                        Commons.showToast('No Image Found');
                      }
                    }
                  },
                  style: TextStyle(),
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.file_upload),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Upload Image',
                  ),
                ),

                SizedBox(
                  height: 12,
                ),

                Visibility(
                  visible: imageSize.isNotEmpty,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 1),
                        child: Text(
                          'Size: $imageSize',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: List.generate(
                      selectedTermsList.length,
                      (index) => ListTile(
                            title: Text(
                                '${index + 1}. ${selectedTermsList[index].name}'),
                            subtitle: Text(selectedTermsList[index].remarks),
                            trailing: Visibility(
                              visible: (isEditable || widget.qtnId == null),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.delete,
                                          color: AppColor.appRed),
                                      onPressed: () {
                                        setState(() {
                                          selectedTermsList[index].isAdded =
                                              false;
                                          selectedTermsList[index].isDefault =
                                              false;
                                          selectedTermsList[index].remarks = '';
                                          selectedTermsList.removeAt(index);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.comment,
                                          color: AppColor.appRed),
                                      onPressed: () {
                                        _addTermRemarks(index);
                                      }),
                                ],
                              ),
                            ),
                          )),
                ),

                Visibility(
                  visible: widget.qtnId == null ? true : isEditable,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(20))),
                        onPressed: () {
                          _termsBottomSheet(context);
                        },
                        child: Text(
                          'Add Terms',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        // color: AppColor.appRed,
                      ),
                      ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(20))),
                        onPressed: () {
                          _addItemBottomSheet(context);
                        },
                        child: Text(
                          'Add Items',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        // color: AppColor.appRed,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                /// Items
                Visibility(
                  visible: itemList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1400 + screenWidth / 1.35,
                        child: PageView.builder(
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                /// Item Detail & Delete Button
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Item ${index + 1}/${itemList.length}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Visibility(
                                        visible: (isEditable ||
                                            widget.qtnId == null),
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  Icons.remove_red_eye,
                                                  color: AppColor.appRed,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewItemDetail(
                                                                selectedItem: [
                                                                  ItemResultModel(
                                                                      id: itemList[index].type ==
                                                                              '1'
                                                                          ? itemList[index]
                                                                              .itemCode
                                                                          : itemList[index]
                                                                              .catalogCode,
                                                                      itemType:
                                                                          itemList[index]
                                                                              .type)
                                                                ],
                                                              )));
                                                }),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: AppColor.appRed,
                                                ),
                                                onPressed: () {
                                                  showDeleteWarning(
                                                      context, index);
                                                }),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),

                                /// Item Images
                                SizedBox(
                                  height: screenWidth / 1.5,
                                  child: Container(
                                    width: screenWidth,
                                    height: screenWidth / 1.5,
                                    child: itemList[index].imageList!.isNotEmpty
                                        ? PhotoViewGallery.builder(
                                            backgroundDecoration: BoxDecoration(
                                                color: Colors.white),
                                            scrollPhysics:
                                                const BouncingScrollPhysics(),
                                            builder: (BuildContext context,
                                                int imgIndex) {
                                              _current = imgIndex;
                                              logIt(
                                                  'ImageUrl-> $imageCatalogBaseUrl${itemList[index].imageList![imgIndex]}.png');
                                              return PhotoViewGalleryPageOptions(
                                                imageProvider: NetworkImage(
                                                    '$imageCatalogBaseUrl${itemList[index].imageList![imgIndex]}.png'),
                                                initialScale:
                                                    PhotoViewComputedScale
                                                            .contained *
                                                        0.8,
                                              );
                                            },
                                            onPageChanged: (value) {
                                              setState(() {
                                                _current = value;
                                              });
                                            },
                                            itemCount: itemList[index]
                                                .imageList!
                                                .length,
                                            loadingBuilder: (context, event) =>
                                                Center(
                                              child: Container(
                                                width: 40.0,
                                                height: 40.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: event == null
                                                      ? 0
                                                      : event.cumulativeBytesLoaded /
                                                          event
                                                              .expectedTotalBytes!,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.white,
                                            child: Center(
                                              child: Image.asset(
                                                  'images/noImage.png'),
                                            ),
                                          ),
                                    //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
                                  ),
                                ),

                                /// Carousel Indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      itemList[index].imageList!.map((item) {
                                    int mIndex = itemList[index]
                                        .imageList!
                                        .indexOf(item);
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current == mIndex
                                            ? Color.fromRGBO(0, 0, 0, 0.9)
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                /// Item Details
                                Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            /// Item
                                            Flexible(
                                              child: TextFormField(
                                                  initialValue: itemList[index]
                                                              .type ==
                                                          '2'
                                                      ? itemList[index].itemCode
                                                      : itemList[index]
                                                          .itemCode,
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      // suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Item',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Catalog
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: true,
                                                  initialValue:
                                                      itemList[index].type ==
                                                              '2'
                                                          ? itemList[index]
                                                              .catalogCode
                                                          : '',
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      //  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Catalog',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        diff,
                                        TextFormField(
                                            readOnly: !(isEditable ||
                                                widget.qtnId == null),
                                            controller: TextEditingController(
                                                text: itemList[index].itemName),
                                            onChanged: (val) {
                                              itemList[index].itemName = '';
                                              itemList[index].itemName =
                                                  val.trim();
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                //suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                isDense: true,
                                                labelText: 'Party Item Name',
                                                border: OutlineInputBorder())),

                                        /// Quantity && Uom
                                        diff,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Quantity
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  initialValue:
                                                      itemList[index].quantity,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onChanged: (char) {
                                                    itemList[index].quantity =
                                                        '';
                                                    itemList[index].quantity =
                                                        char.trim();
                                                    setState(() {});
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Quantity',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .quantityUom),
                                                  readOnly: true,
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(context,
                                                          'qtyUom', index);
                                                  },
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        /// Include Tax & Tax
                                        diff,
                                        Row(
                                          children: [
                                            /// Include
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .includeTax),
                                                  readOnly: true,
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _includeTaxBottomSheet(
                                                          context, index);
                                                  },
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Include',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Tax
                                            Flexible(
                                              child: TextFormField(
                                                  onChanged: (value) {
                                                    itemList[index].tax = '';
                                                    itemList[index].tax =
                                                        value.trim();
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      updateRate(
                                                          itemList[index]
                                                              .basicRate,
                                                          index);
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .tax),
                                                  enabled: (itemList[index]
                                                          .includeTax ==
                                                      'Yes'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [numberReg],
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      //  suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Tax',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        diff,

                                        /// Basic Rate
                                        TextFormField(
                                            readOnly: !(isEditable ||
                                                widget.qtnId == null),
                                            /*controller: TextEditingController(
                                              text:
                                                    itemList[index].basicRate),*/
                                            onChanged: (value) {
                                              itemList[index].basicRate = '';
                                              itemList[index].basicRate =
                                                  value.trim();
                                              updateRate(value.trim(), index);
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [numberReg],
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            initialValue:
                                                itemList[index].basicRate,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Basic Rate',
                                                border: OutlineInputBorder())),

                                        diff,

                                        /// Rate $ Uom
                                        Row(
                                          children: [
                                            /// Rate
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                    text: itemList[index].rate,
                                                  ),
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onChanged: (value) {
                                                    itemList[index].rate = '';
                                                    setState(() {
                                                      itemList[index].rate =
                                                          value.trim();
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Rate',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .rateUom),
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(context,
                                                          'rateUom', index);
                                                  },
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        /// Clb Quantity $ Uom
                                        diff,
                                        Row(
                                          children: [
                                            /// Clb Quantity
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  initialValue: itemList[index]
                                                      .clbQuantity,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onChanged: (value) {
                                                    itemList[index]
                                                        .clbQuantity = '';
                                                    itemList[index]
                                                        .clbQuantity = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Clb Quantity',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .clbQuantityUom),
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(context,
                                                          'clbQtyUom', index);
                                                  },
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        /// Clb Rate $ Uom
                                        diff,
                                        Row(
                                          children: [
                                            /// Clb Rate
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  controller:
                                                      TextEditingController(
                                                    text:
                                                        itemList[index].clbRate,
                                                  ),
                                                  // readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onChanged: (value) {
                                                    itemList[index].clbRate =
                                                        '';
                                                    itemList[index].clbRate =
                                                        value.trim();
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Clb Rate',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .clbRateUom),
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(context,
                                                          'clbRateUom', index);
                                                  },
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        diff,
                                        Row(
                                          children: [
                                            /// Count
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  initialValue:
                                                      itemList[index].Count,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onChanged: (char) {
                                                    itemList[index].Count = '';
                                                    setState(() {
                                                      itemList[index].Count =
                                                          char.trim();
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Count',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Material
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  initialValue:
                                                      itemList[index].Material,
                                                  // readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      // suffixIcon: Icon(Icons.keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Material',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        diff,

                                        /// Brand
                                        TextFormField(
                                            controller: TextEditingController(
                                                text: itemList[index].Brand),
                                            readOnly: true,
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _brandBottomSheet(
                                                    context, index);
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                labelText: 'Brand',
                                                border: OutlineInputBorder())),

                                        diff,

                                        /// Shade
                                        TextFormField(
                                            controller: TextEditingController(
                                                text: itemList[index].Shade),
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _shadeBottomSheet(
                                                    context, index);
                                            },
                                            readOnly: true,
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                labelText: 'Shade',
                                                border: OutlineInputBorder())),

                                        diff,

                                        /// Item Parameter 1
                                        TextFormField(
                                            controller: TextEditingController(
                                                text: itemList[index]
                                                    .itemParameter1),
                                            readOnly: true,
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _itemParamBottomSheet(
                                                    context, '1', index);
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                labelText: 'Item Parameter',
                                                border: OutlineInputBorder())),

                                        /// Value & Uom
                                        diff,
                                        Row(
                                          children: [
                                            /// Value
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  initialValue: itemList[index]
                                                      .itemValue1,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onChanged: (value) {
                                                    itemList[index].itemValue1 =
                                                        '';
                                                    itemList[index].itemValue1 =
                                                        value.trim();
                                                  },
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Value',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .itemUom1),
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(
                                                          context,
                                                          'itemParam1Uom',
                                                          index);
                                                  },
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, bottom: 12),
                                          child: Container(
                                            height: 0.8,
                                            width: double.infinity,
                                            color: Colors.grey,
                                          ),
                                        ),

                                        /// Item Parameter 2
                                        TextFormField(
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _itemParamBottomSheet(
                                                    context, '2', index);
                                            },
                                            controller: TextEditingController(
                                                text: itemList[index]
                                                    .itemParameter2),
                                            readOnly: true,
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            /*  onChanged: (value) {
                                              itemList[index].itemParameter2 = '';
                                              itemList[index].itemParameter2 =
                                                  value.trim();
                                            },*/
                                            decoration: InputDecoration(
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                isDense: true,
                                                labelText: 'Item Parameter',
                                                border: OutlineInputBorder())),

                                        /// Value & Uom
                                        diff,
                                        Row(
                                          children: [
                                            /// Value
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .itemValue2),
                                                  onChanged: (value) {
                                                    itemList[index].itemValue2 =
                                                        '';
                                                    itemList[index].itemValue2 =
                                                        value.trim();
                                                  },
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Value',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .itemUom2),
                                                  readOnly: true,
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(
                                                          context,
                                                          'itemParam2Uom',
                                                          index);
                                                  },
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, bottom: 12),
                                          child: Container(
                                            height: 0.8,
                                            width: double.infinity,
                                            color: Colors.grey,
                                          ),
                                        ),

                                        /// Item Parameter 3
                                        TextFormField(
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _itemParamBottomSheet(
                                                    context, '3', index);
                                            },
                                            controller: TextEditingController(
                                                text: itemList[index]
                                                    .itemParameter3),
                                            readOnly: true,
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                isDense: true,
                                                labelText: 'Item Parameter',
                                                border: OutlineInputBorder())),

                                        /// Value & Uom
                                        diff,
                                        Row(
                                          children: [
                                            /// Value
                                            Flexible(
                                              child: TextFormField(
                                                  readOnly: !(isEditable ||
                                                      widget.qtnId == null),
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .itemValue3),
                                                  onChanged: (value) {
                                                    itemList[index].itemValue3 =
                                                        '';
                                                    itemList[index].itemValue3 =
                                                        value.trim();
                                                  },
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Value',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Uom
                                            Flexible(
                                              child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: itemList[index]
                                                              .itemUom3),
                                                  onTap: () {
                                                    if (isEditable ||
                                                        widget.qtnId == null)
                                                      _uomBottomSheet(
                                                          context,
                                                          'itemParam3Uom',
                                                          index);
                                                  },
                                                  readOnly: true,
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_down),
                                                      isDense: true,
                                                      labelText: 'Uom',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),

                                        diff,

                                        /// Catalog Item Code
                                        TextFormField(
                                            readOnly: !(isEditable ||
                                                widget.qtnId == null),
                                            controller: TextEditingController(
                                                text: itemList[index]
                                                    .catalogItemCode),
                                            onChanged: (value) {
                                              itemList[index].catalogItemCode =
                                                  '';
                                              itemList[index].catalogItemCode =
                                                  value.trim();
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Catalog Item Code',
                                                border: OutlineInputBorder())),

                                        diff,
                                        /* /// Unnamed & Unnamed
                                        Row(
                                          children: [
                                            /// Unnamed
                                            Flexible(
                                              child: TextFormField(
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Unnamed',
                                                      border:
                                                          OutlineInputBorder())),
                                            ),

                                            SizedBox(
                                              width: 12,
                                            ),

                                            /// Unnamed
                                            Flexible(
                                              child: TextFormField(
                                                  cursorColor: Colors.black,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      labelText: 'Unnamed',
                                                      border:
                                                          OutlineInputBorder())),
                                            )
                                          ],
                                        ),*/

                                        /// Remarks
                                        TextFormField(
                                            readOnly: !(isEditable ||
                                                widget.qtnId == null),
                                            initialValue:
                                                itemList[index].remarks,
                                            onChanged: (value) {
                                              itemList[index].remarks = '';
                                              itemList[index].remarks =
                                                  value.trim();
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Remarks',
                                                border: OutlineInputBorder())),
                                        diff,

                                        /// Status
                                        TextFormField(
                                            controller: TextEditingController(
                                                text: itemList[index].status),
                                            readOnly: true,
                                            onTap: () {
                                              if (isEditable ||
                                                  widget.qtnId == null)
                                                _statusBottomSheet(
                                                    context, index);
                                            },
                                            cursorColor: Colors.black,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                isDense: true,
                                                labelText: 'Status',
                                                border: OutlineInputBorder())),
                                      ],
                                    ),
                                  ),
                                )),
                              ],
                            );
                          },
                          itemCount: itemList.length,
                          // physics: BouncingScrollPhysics(),
                          onPageChanged: (position) {
                            _getItemParamList(itemList[position].itemCode);
                            setState(() {
                              _currentPosition = position + 1;
                              debugPrint('onChanged $_currentPosition');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                /// Add Button
                Visibility(
                  visible: widget.qtnId == null ? true : isEditable,
                  child: Visibility(
                    visible: ifHasPermission(
                        permType: PermType.INSERT,
                        compCode: companyCode,
                        permission: Permissions.SALE_QTN)!,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          isEditable ? 'Update' : 'Save',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        // color: AppColor.appRed,
                        onPressed: () {
                          if (_key.currentState!.validate() &&
                              _isAllValidated()) {
                            if (isEditable) {
                              _updateQtnForm();
                            } else {
                              _saveQtnForm();
                            }
                          } else {
                            debugPrint('Not validated');
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isAllValidated() {
    if (itemList.isEmpty) {
      Commons.showToast('Please add items');
      return false;
    }

    for (int i = 0; i < itemList.length; i++) {
      var obj = itemList[i];

      if (obj.itemName.trim().isEmpty) {
        _throwError(i + 1, 'Please enter party item name');
        return false;
      } else if (obj.Count!.trim().isEmpty) {
        // _throwError(i + 1, 'Please enter count');
        return true;
      } else if (obj.materialCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please enter material');
        return false;
      } else if (obj.quantity.trim().isEmpty) {
        _throwError(i + 1, 'Please enter quantity');
        return false;
      } else if (obj.quantity.trim().isNotEmpty &&
          obj.quantityUomCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select quantity uom');
        return false;
      } else if (obj.rate.trim().isEmpty) {
        _throwError(i + 1, 'Please enter rate');
        return false;
      } else if (obj.rate.trim().isNotEmpty &&
          obj.rateUomCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select rate uom');
        return false;
      } else if (obj.clbQuantity.trim().isEmpty) {
        _throwError(i + 1, 'Please enter clb quantity');
        return false;
      } else if (obj.clbQuantity.trim().isNotEmpty &&
          obj.clbQuantityUomCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select clb quantity uom');
        return false;
      } else if (obj.clbRate.trim().isEmpty) {
        _throwError(i + 1, 'Please enter clb rate');
        return false;
      } else if (obj.clbRate.trim().isNotEmpty &&
          obj.clbRateUomCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select clb rate uom');
        return false;
      }
      /*else if (obj.catalogItemCode.trim().isEmpty) {
        _throwError(i + 1, 'Please enter catalog item code');
        return false;
      }*/
      else if (obj.includeTax == 'Yes' && obj.tax.trim().isEmpty) {
        _throwError(i + 1, 'Please enter tax value');
        return false;
      } else if (obj.basicRate.trim().isEmpty) {
        _throwError(i + 1, 'Please enter basic rate');
        return false;
      } else if (obj.brandCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select brand');
        return false;
      } else if (obj.shadeCode!.trim().isEmpty) {
        _throwError(i + 1, 'Please select shade');
        return false;
      }

      /// Item Parameter 1
      else if (obj.itemParameter1!.trim().isEmpty) {
        _throwError(i + 1, 'Please select item parameter 1');
        return false;
      } else if (obj.itemParameter1Code!.trim().isNotEmpty &&
          obj.itemValue1!.isEmpty) {
        _throwError(i + 1, 'Please select item value 1');
        return false;
      } else if (obj.itemParameter1Code!.trim().isNotEmpty &&
          obj.itemValue1!.trim().isNotEmpty &&
          obj.itemUom1Code!.isEmpty) {
        _throwError(i + 1, 'Please select item uom 1');
        return false;
      }

      /// Item Parameter 2
      else if (obj.itemParameter2!.trim().isEmpty) {
        _throwError(i + 1, 'Please select item parameter 2');
        return false;
      } else if (obj.itemParameter2Code!.trim().isNotEmpty &&
          obj.itemValue2!.isEmpty) {
        _throwError(i + 1, 'Please select item value 2');
        return false;
      } else if (obj.itemParameter2Code!.trim().isNotEmpty &&
          obj.itemValue2!.trim().isNotEmpty &&
          obj.itemUom2Code!.isEmpty) {
        _throwError(i + 1, 'Please select item uom 2');
        return false;
      }

      /// Item Parameter 3
      else if (obj.itemParameter3!.trim().isEmpty) {
        _throwError(i + 1, 'Please select item parameter 3');
        return false;
      } else if (obj.itemParameter3Code!.trim().isNotEmpty &&
          obj.itemValue3!.isEmpty) {
        _throwError(i + 1, 'Please select item value 3');
        return false;
      } else if (obj.itemParameter3Code!.trim().isNotEmpty &&
          obj.itemValue3!.trim().isNotEmpty &&
          obj.itemUom3Code!.isEmpty) {
        _throwError(i + 1, 'Please select item uom 3');
        return false;
      }
    }

    return true;
  }

  _throwError(int i, String error) {
    Commons.showToast(error + ' on ${_getSuffix(i)} item.');
  }

  String _getSuffix(int i) {
    if (i == 1) {
      return '1st';
    } else if (i == 2) {
      return '2nd';
    } else if (i == 3) {
      return '3rd';
    } else {
      return '${i}th';
    }
  }

  void _imageViewerBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        backgroundColor: AppColor.black,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext conxt, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageBaseUrl! + uploadImageName!),
                initialScale: PhotoViewComputedScale.contained * 0.8,
              );
            },
            itemCount: 1,
            loadingBuilder: (conxt, event) => Center(
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
          );
        });
  }

  _init() async {
    _entryDateController.text = '${now.month}/${now.day}/${now.year}';

    if (now.month <= 4) {
      _finYearController.text = '${now.year - 1}${now.year}';
      print('YearIs  April ${_finYearController.text}');
    } else {
      _finYearController.text = '${now.year}${now.year + 1}';
      print('YearIs  AfterApril ${_finYearController.text}');
    }
  }

  Future getImage(ImageSource imgSrc) async {
    final dir = await getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/qtnImage.jpg";
    final pickedFile = await picker.pickImage(source: imgSrc);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      /*  File? compFile = await Commons.compressAndGetFile(_image, targetPath);
      if (compFile == null) return;
      _image = compFile; */

      debugPrint('AfterCompression ${filesize(_image.lengthSync())}');
      _uploadImage(_image.absolute.path);
      _imageController.text = basename(_image.path);
      imageSize = filesize(_image.lengthSync());
      setState(() {});
      debugPrint("Image  Path is ${pickedFile.path}");
      debugPrint("Image File Path is $_image");
    } else {
      print('No image selected.');
    }
  }

  _getCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getCompany,
            jsonEncode(<String, dynamic>{
              'user_id': user_id,
              'tid': Permissions.SALE_QTN,
              'mode_flag': widget.qtnId != null ? 'M,A' : 'I,A'
            }))
        .then((value) => {
              Navigator.of(this.context).pop(),
              debugPrint('getCompanyList ${value!.body}'),
              _parseCompanyList(value)
            });
  }

  _parseCompanyList(Response value) {
    if (value.statusCode == 200) {
      var res = jsonDecode(value.body);

      if (res['error'] == 'false') {
        var content = res['content'] as List;

        companyList.clear();

        companyList
            .addAll(content.map((e) => QCompanyModel.fromJson(e)).toList());
        setState(() {});
      }
    }
  }

  _getQtNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getQtNumber,
            jsonEncode(<String, dynamic>{
              'user_id': user_id,
              'comp_code': companyCode,
              'qtn_finyear': _finYearController.text.trim()
            }))
        .then((value) => {
              Navigator.of(this.context).pop(),
              //_QtyNumberController.text=
              debugPrint('getQtNumber ${value!.body}'),
              _parse(value)
            });
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);
      if (data['error'] == 'false') {
        _QtyNumberController.text = data['max_qtn_no'].toString();
      }
    }
  }

  _getPartyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getParty,
            jsonEncode(<String, dynamic>{
              'user_id': user_id,
              'comp_code': companyCode
            }))
        .then((value) => {
              Navigator.of(this.context).pop(),
              debugPrint('getPartyList ${value!.body}'),
              _parsePartyList(value)
            });
  }

  _parsePartyList(Response value) {
    if (value.statusCode == 200) {
      var res = jsonDecode(value.body);

      if (res['error'] == 'false') {
        var content = res['content'] as List;
        partyList.clear();
        mainPartyList.clear();
        partyList.addAll(content.map((e) => PartyModel.fromJson(e)).toList());
        mainPartyList
            .addAll(content.map((e) => PartyModel.fromJson(e)).toList());
        setState(() {});
        debugPrint('PartyListSize ${partyList.length}');
      }
    }
  } //,file_path=quotations,filename

  _uploadImage(String filename) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id')!;
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.addUploadAttachment));
    request.files.add(await http.MultipartFile.fromPath(
      'filename', filename,
      // filename: '${DateTime.now().millisecondsSinceEpoch}.${_image.path.split('.').last}'
    ));
    request.fields['user_id'] = user_id;
    request.fields['file_path'] = 'quotations';

    debugPrint(
        'UploadImage ${AppConfig.baseUrl + AppConfig.addUploadAttachment}');

    // var res = await request.send();

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        uploadImageName = data['filename'];
      }
    }

    debugPrint('UploadImage ${res.body}');
    debugPrint('UploadImage ${res.statusCode}');
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    WebService()
        .post(
            this.context,
            AppConfig.getAddressList,
            jsonEncode(
                <String, dynamic>{'user_id': user_id, 'acc_code': partyCode}))
        .then((value) => {
              Navigator.of(this.context).pop(),
              //  debugPrint('_getAddress ${value.body}'),
              _parseAddress(value!)
            });
  }

  _parseAddress(Response res) {
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;
        addressList.clear();
        addressList
            .addAll(contentList.map((e) => AddressModel.fromJson(e)).toList());

        /// Selecting Default Address if there is only one address
        if (addressList.length == 1) {
          _addressController.text = addressList[0].add0! +
              ' ' +
              addressList[0].add1! +
              ' ' +
              addressList[0].add2! +
              ' ' +
              addressList[0].city!;
          rankCode = addressList[0].id;
        }
      }
    }
  }

  _showSuccessAlert(String message, String? code) {
    AlertDialog alert = AlertDialog(
      title: Text('Success'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('Dismiss'),
          onPressed: () {
            popIt(this.context);
            popIt(this.context);
          },
        ),
        TextButton(
          child: Text('View Pdf'),
          onPressed: () {
            popIt(this.context);
            _downloadPdf(code);
          },
        ),
        TextButton(
          child: Text('Send Email'),
          onPressed: () {
            popIt(this.context);
            popIt(this.context);
            Navigator.push(
                this.context,
                MaterialPageRoute(
                    builder: (context) => SendEmail(
                          codePk: code,
                          partyCode: partyCode,
                          companyName: _partyController.text,
                          type: Qtn,
                        )));
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
      context: this.context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  _downloadPdf(String? docCode) async {
    List<int> bytes = [];

    var url = '${AppConfig.downloadSaleQtn}$docCode';

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode.pdf';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    if (file2.existsSync()) {
      logIt('File does EXIST -> $file2');
      _viewPdf(file2, docCode);
    } else {
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
          popIt(this.context);
          _viewPdf(file2, docCode);
        },
        onError: (e) {
          popIt(this.context);
          showAlert(this.context, 'Error occurred while downloading', 'Error!');
          print(e);
        },
        cancelOnError: true,
      );
    }
  }

  _viewPdf(File data, String? docCode) async {
    FocusScope.of(this.context).unfocus();

    Navigator.of(this.context).push(MaterialPageRoute(
        builder: (context) => ViewPdf(
            type: Qtn,
            data: data,
            id: docCode,
            partyName: _partyController.text,
            partyCode: partyCode)));
  }

  String? getCodes(String type) {
    switch (type) {
      //

      case 'b_rate':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.basicRate}';
          } else {
            data = "$data,${element.basicRate}";
          }
        });
        return data;
      //break;

      case 'tax_per':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.tax}';
          } else {
            data = "$data,${element.tax}";
          }
        });
        return data;
      // break;

      case 'tax_tag':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.includeTax[0]}';
          } else {
            data = "$data,${element.includeTax[0]}";
          }
        });
        return data;
      // break;

      case 'remarks':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.remarks}';
          } else {
            data = "$data,${element.remarks}";
          }
        });
        return data;
      // break;

      case 'code_pk_status':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.status[0]}';
          } else {
            data = "$data,${element.status[0]}";
          }
        });
        return data;
      // break;

      case 'clb_rate_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.clbRateUomCode}';
          } else {
            data = "$data,${element.clbRateUomCode}";
          }
        });
        return data;
      //break;

      case 'clb_rate':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.clbRate}';
          } else {
            data = "$data,${element.clbRate}";
          }
        });
        return data;
      //break;

      case 'clb_qty_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.clbQuantityUomCode}';
          } else {
            data = "$data,${element.clbQuantityUomCode}";
          }
        });
        return data;
      //break;

      case 'clb_qty':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.clbQuantity}';
          } else {
            data = "$data,${element.clbQuantity}";
          }
        });
        return data;
      //break;

      case 'party_item_name':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemName}';
          } else {
            data = "$data,${element.itemName}";
          }
        });
        return data;
      //break;

      case 'rate_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.rateUomCode}';
          } else {
            data = "$data,${element.rateUomCode}";
          }
        });
        return data;
      //break;

      case 'rate':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.rate}';
          } else {
            data = "$data,${element.rate}";
          }
        });
        return data;
      //break;

      case 'qty_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.quantityUomCode}';
          } else {
            data = "$data,${element.quantityUomCode}";
          }
        });
        return data;
      //break;

      case 'qty':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.quantity}';
          } else {
            data = "$data,${element.quantity}";
          }
        });
        return data;
      //break;

      case 'iop3_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemUom3Code}';
          } else {
            data = "$data,${element.itemUom3Code}";
          }
        });
        return data;
      //break;

      case 'iop2_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemUom2Code}';
          } else {
            data = "$data,${element.itemUom2Code}";
          }
        });
        return data;
      // break;

      case 'iop1_uom':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemUom1Code}';
          } else {
            data = "$data,${element.itemUom1Code}";
          }
        });
        return data;
      //break;

      case 'iop3_val':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemValue3}';
          } else {
            data = "$data,${element.itemValue3}";
          }
        });
        return data;
      //break;

      case 'iop2_val':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemValue2}';
          } else {
            data = "$data,${element.itemValue2}";
          }
        });
        return data;
      // break;

      case 'iop1_val':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemValue1}';
          } else {
            data = "$data,${element.itemValue1}";
          }
        });
        return data;
      //break;

      case 'iop3_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemParameter3Code}';
          } else {
            data = "$data,${element.itemParameter3Code}";
          }
        });
        return data;
      //break;

      case 'iop2_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemParameter2Code}';
          } else {
            data = "$data,${element.itemParameter2Code}";
          }
        });
        return data;
      // break;

      case 'iop1_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemParameter1Code}';
          } else {
            data = "$data,${element.itemParameter1Code}";
          }
        });
        return data;
      // break;

      case 'brand_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.brandCode}';
          } else {
            data = "$data,${element.brandCode}";
          }
        });
        return data;
      //break;

      case 'count_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.countCode}';
          } else {
            data = "$data,${element.countCode}";
          }
        });
        return data;
      //break;

      case 'item_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.itemCode}';
          } else {
            data = "$data,${element.itemCode}";
          }
        });
        return data;
      //break;

      case 'material_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.materialCode}';
          } else {
            data = "$data,${element.materialCode}";
          }
        });
        return data;
      //break;

      case 'shade_code':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.shadeCode}';
          } else {
            data = "$data,${element.shadeCode}";
          }
        });
        return data;
      //break;

      case 'sqd_pk':
        String? data;
        itemList.forEach((element) {
          if (data == null) {
            data = '${element.id}';
          } else {
            data = "$data,${element.id}";
          }
        });
        return data;
      // break;
    }
    return null;
  }

  _saveQtnForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    String? termsId;
    String? terms;
    String? termsRemarks;

    termsList.forEach((element) {
      if (element.isAdded) {
        if (termsId == null) {
          termsId = '${element.id}';
        } else {
          termsId = "$termsId,${element.id}";
        }
      }
    });

    termsList.forEach((element) {
      if (element.isAdded) {
        if (terms == null) {
          terms = '${element.name}';
        } else {
          terms = "$terms,${element.name}";
        }
      }
    });

    termsList.forEach((element) {
      if (element.isAdded) {
        if (termsRemarks == null) {
          termsRemarks = '${element.remarks}';
        } else {
          termsRemarks = "$termsRemarks,${element.remarks}";
        }
      }
    });

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'comp_code': companyCode,
      'acc_code': partyCode,
      'img_path': uploadImageName,
      'qtn_no': _QtyNumberController.text.trim(),
      'qtn_date': _entryDateController.text.trim(),
      'qtn_finyear': _finYearController.text.trim(),
      'remarks': _remarksController.text.trim(),
      'add_rank': rankCode,
      'count_code': getCodes('count_code'),
      'item_code': getCodes('item_code'),
      'material_code': getCodes('material_code'),
      'shade_code': getCodes('shade_code'),
      'brand_code': getCodes('brand_code'),
      'iop1_code': getCodes('iop1_code'),
      'iop2_code': getCodes('iop2_code'),
      'iop3_code': getCodes('iop3_code'),
      'iop1_val': getCodes('iop1_val'),
      'iop2_val': getCodes('iop2_val'),
      'iop3_val': getCodes('iop3_val'),
      'iop1_uom': getCodes('iop1_uom'),
      'iop2_uom': getCodes('iop2_uom'),
      'iop3_uom': getCodes('iop3_uom'),
      'qty': getCodes('qty'),
      'qty_uom': getCodes('qty_uom'),
      'rate': getCodes('rate'),
      'rate_uom': getCodes('rate_uom'),
      'party_item_name': getCodes('party_item_name'),
      'clb_qty': getCodes('clb_qty'),
      'clb_qty_uom': getCodes('clb_qty_uom'),
      'clb_rate': getCodes('clb_rate'),
      'clb_rate_uom': getCodes('clb_rate_uom'),
      'code_pk_status': getCodes('code_pk_status'),
      'item_remarks': getCodes('remarks'),
      'tax_tag': getCodes('tax_tag'),
      'tax_per': getCodes('tax_per'),
      'b_rate': getCodes('b_rate'),
      'term_ids': termsId,
      'term_name': terms,
      'term_remarks': termsRemarks
    });

    debugPrint('QuotationParams-> $json');
    //  return;
    WebService()
        .post(this.context, AppConfig.saveQtnDetails, json)
        .then((value) => {
              Navigator.of(this.context).pop(),
              if (value!.statusCode == 200)
                {
                  if (jsonDecode(value.body)['error'] == 'true')
                    {
                      _showSuccessAlert(jsonDecode(value.body)['message'],
                          jsonDecode(value.body)['quotation_header'])
                    }
                  else
                    {
                      _showSuccessAlert(jsonDecode(value.body)['message'],
                          jsonDecode(value.body)['quotation_header'])
                    }
                }
            });
  }

  _updateQtnForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');

    //  Commons().showProgressbar(this.context);

    String? termsId;
    String? terms;
    String? termsRemarks;

    termsList.forEach((element) {
      if (element.isAdded) {
        if (termsId == null) {
          termsId = '${element.id}';
        } else {
          termsId = "$termsId,${element.id}";
        }
      }
    });

    termsList.forEach((element) {
      if (element.isAdded) {
        if (terms == null) {
          terms = '${element.name}';
        } else {
          terms = "$terms,${element.name}";
        }
      }
    });

    termsList.forEach((element) {
      if (element.isAdded) {
        if (termsRemarks == null) {
          termsRemarks = '${element.remarks}';
        } else {
          termsRemarks = "$termsRemarks,${element.remarks}";
        }
      }
    });

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'quotation_id': widget.qtnId,
      'comp_code': companyCode,
      'acc_code': partyCode,
      'img_path': uploadImageName,
      'qtn_no': _QtyNumberController.text.trim(),
      'qtn_date': _entryDateController.text.trim(),
      'qtn_finyear': _finYearController.text.trim(),
      'remarks': _remarksController.text.trim(),
      'add_rank': rankCode,
      'count_code': getCodes('count_code'),
      'item_code': getCodes('item_code'),
      'material_code': getCodes('material_code'),
      'shade_code': getCodes('shade_code'),
      'brand_code': getCodes('brand_code'),
      'iop1_code': getCodes('iop1_code'),
      'iop2_code': getCodes('iop2_code'),
      'iop3_code': getCodes('iop3_code'),
      'iop1_val': getCodes('iop1_val'),
      'iop2_val': getCodes('iop2_val'),
      'iop3_val': getCodes('iop3_val'),
      'iop1_uom': getCodes('iop1_uom'),
      'iop2_uom': getCodes('iop2_uom'),
      'iop3_uom': getCodes('iop3_uom'),
      'qty': getCodes('qty'),
      'qty_uom': getCodes('qty_uom'),
      'rate': getCodes('rate'),
      'rate_uom': getCodes('rate_uom'),
      'party_item_name': getCodes('party_item_name'),
      'clb_qty': getCodes('clb_qty'),
      'clb_qty_uom': getCodes('clb_qty_uom'),
      'clb_rate': getCodes('clb_rate'),
      'clb_rate_uom': getCodes('clb_rate_uom'),
      'code_pk_status': getCodes('code_pk_status'),
      'item_remarks': getCodes('remarks'),
      'tax_tag': getCodes('tax_tag'),
      'tax_per': getCodes('tax_per'),
      'b_rate': getCodes('b_rate'),
      'sqd_pk': getCodes('sqd_pk'),
      'term_ids': termsId,
      'term_name': terms,
      'term_remarks': termsRemarks
    });

    debugPrint('UpdateParams=> $json', wrapWidth: 1024);

    WebService()
        .post(this.context, AppConfig.editQuotation, json)
        .then((value) => {
              if (value!.statusCode == 200)
                {
                  if (jsonDecode(value.body)['error'] == 'true')
                    {
                      Commons().showAlert(
                          this.context,
                          jsonDecode(value.body)['message'],
                          'Success', onOk: () {
                        Navigator.of(this.context).pop();
                      })
                    }
                  else
                    {
                      showAlert(this.context, jsonDecode(value.body)['message'],
                          'Success')
                    }
                }
            });
  }

  void showAlert(BuildContext context, String msg, String title) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
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

  void _companyBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    AppConfig.small_image + companyList[index].logoName!,
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(companyList[index].name!),
                ),
                onTap: () {
                  _companyController.text = companyList[index].name!;
                  companyCode = companyList[index].id;
                  Navigator.of(context).pop();
                  partyCode = '';
                  _partyController.clear();
                  _addressController.clear();
                  rankCode = '';
                  partyList.clear();
                  mainPartyList.clear();

                  /// Not Generating Quotation number when editing
                  if (!isEditable && widget.qtnId == null) {
                    _getQtNumber();
                  }
                  _getPartyList();
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  void _addItemBottomSheet(context) {
    FocusScope.of(context).unfocus();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    'images/item_master.svg',
                    height: 24,
                    width: 24,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Search Item',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    var result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemSearch(
                                  comingFrom: ComingFrom.Quotation,
                                )));

                    if (result == null || result.isEmpty) return;
                    imgBaseUrl = result[0];
                    List<ItemMasterModel> resList = result[1];
                    //itemList.clear();
                    setState(() {});
                    await Future.delayed(Duration(milliseconds: 500));
                    itemList.addAll(resList);
                    _getItemParamList(itemList[0].itemCode);
                    setState(() {});
                    FocusScope.of(context).unfocus();
                    debugPrint('OnResultWaited => ${result.length}');
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'images/item_master.svg',
                    height: 24,
                    width: 24,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Search Catalog Item',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    var result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemSearchCatalog(
                                  comingFrom: ComingFrom.Quotation,
                                )));
                    if (result == null || result.isEmpty) return;
                    imgBaseUrl = result[0];
                    List<ItemMasterModel> resList = result[1];
                    // itemList.clear();
                    setState(() {});
                    await Future.delayed(Duration(milliseconds: 500));
                    itemList.addAll(resList);
                    _getItemParamList(itemList[0].itemCode);
                    setState(() {});
                    FocusScope.of(context).unfocus();
                    debugPrint('OnResultWaited => ${result.length}');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search, color: Colors.black, size: 24),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add Catalog Code',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _addCatalogController.clear();
                    var alert = AlertDialog(
                      title: Text('Search Catalog Code'),
                      content: Form(
                        key: _catalogKey,
                        child: TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? 'Enter Catalog Code' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _addCatalogController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              InputDecoration(labelText: 'Catalog Code'),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              popIt(context);
                            },
                            child: Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              if (!_catalogKey.currentState!.validate()) return;
                              popIt(context);
                              _getCatalog(_addCatalogController.text.trim());
                            },
                            child: Text('Add')),
                      ],
                    );
                    showAnimatedDialog(context, alert);

                    /* var result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemSearchCatalog(
                                  comingFrom: ComingFrom.Quotation,
                                )));
                    if (result == null || result.isEmpty) return;
                    imgBaseUrl = result[0];
                    List<ItemMasterModel> resList = result[1];
                    // itemList.clear();
                    setState(() {});
                    await Future.delayed(Duration(milliseconds: 500));
                    itemList.addAll(resList);
                    _getItemParamList(itemList[0].itemCode);
                    setState(() {});
                    FocusScope.of(context).unfocus();
                    debugPrint('OnResultWaited => ${result.length}');*/
                  },
                ),
              ],
            ),
          ));
        });
  }

  void _termsBottomSheet(context) {
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
                  termsList.length,
                  (index) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${index + 1} ${termsList[index].name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    enabled: !termsList[index].isAdded,
                    onTap: () async {
                      termsList[index].isDefault = true;
                      termsList[index].isAdded = true;
                      selectedTermsList.add(termsList[index]);
                      setState(() {});
                      popIt(context);
                    },
                  ),
                ),
              ),
            ),
          ));
        });
  }

  void _uomBottomSheet(BuildContext context, String type, int mainIndex) {
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
            child: ListView.builder(
              itemCount: uomList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  selectedTileColor: AppColor.appRed[500],
                  title: Text(uomList[index].abbreviation!,
                      style: TextStyle(fontSize: 16)),
                  subtitle: Text(uomList[index].name!),
                  onTap: () {
                    Navigator.pop(context);
                    switch (type) {
                      case 'qtyUom':
                        setState(() {
                          itemList[mainIndex].quantityUom =
                              uomList[index].abbreviation;
                          itemList[mainIndex].quantityUomCode =
                              uomList[index].id;
                        });
                        //  _pageController.notifyListeners();
                        break;
                      case 'rateUom':
                        itemList[mainIndex].rateUom =
                            uomList[index].abbreviation;
                        itemList[mainIndex].rateUomCode = uomList[index].id;

                        break;
                      case 'clbQtyUom':
                        itemList[mainIndex].clbQuantityUom =
                            uomList[index].abbreviation;
                        itemList[mainIndex].clbQuantityUomCode =
                            uomList[index].id;

                        break;
                      case 'clbRateUom':
                        itemList[mainIndex].clbRateUom =
                            uomList[index].abbreviation;
                        itemList[mainIndex].clbRateUomCode = uomList[index].id;

                        break;
                      case 'itemParam1Uom':
                        itemList[mainIndex].itemUom1 =
                            uomList[index].abbreviation;
                        itemList[mainIndex].itemUom1Code = uomList[index].id;

                        break;
                      case 'itemParam2Uom':
                        itemList[mainIndex].itemUom2 =
                            uomList[index].abbreviation;
                        itemList[mainIndex].itemUom2Code = uomList[index].id;

                        break;
                      case 'itemParam3Uom':
                        itemList[mainIndex].itemUom3 =
                            uomList[index].abbreviation;
                        itemList[mainIndex].itemUom3Code = uomList[index].id;

                        break;
                    }
                    setState(() {});
                  },
                );
              },
            ),
          ));
        });
  }

  void _itemParamBottomSheet(BuildContext context, String type, int mainIndex) {
    if (catParamsList.isEmpty) {
      Commons.showToast('Item Parameters does not exist for this item.');
      return;
    }

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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: catParamsList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  selectedTileColor: AppColor.appRed[500],
                  title: Text(catParamsList[index].name!,
                      style: TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.pop(context);

                    switch (type) {
                      case '1':
                        itemList[mainIndex].itemParameter1 =
                            catParamsList[index].name;
                        itemList[mainIndex].itemParameter1Code =
                            catParamsList[index].id;
                        break;
                      case '2':
                        itemList[mainIndex].itemParameter2 =
                            catParamsList[index].name;
                        itemList[mainIndex].itemParameter2Code =
                            catParamsList[index].id;
                        break;
                      case '3':
                        itemList[mainIndex].itemParameter3 =
                            catParamsList[index].name;
                        itemList[mainIndex].itemParameter3Code =
                            catParamsList[index].id;
                        debugPrint('QtyUom => ${uomList[index].name}');
                        debugPrint('QtyUom => ${uomList[index].abbreviation}');
                        break;
                    }
                    setState(() {});
                  },
                );
              },
            ),
          ));
        });
  }

  void _brandBottomSheet(BuildContext context, int mainIndex) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<UomModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select brand' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      setState(() {
                        itemList[mainIndex].Brand = sg.name;
                        itemList[mainIndex].brandCode = sg.id;
                      });
                      debugPrint('OnClicked ${itemList[mainIndex].Brand}');
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredBrandList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        //  controller: _partyController,
                        onChanged: (string) {
                          debugPrint('brandController=> $string');

                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Brand Name',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _shadeBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<UomModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select shade' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      setState(() {
                        itemList[index].Shade = sg.name;
                        itemList[index].shadeCode = sg.id;
                      });
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredShadeList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        //  controller: _partyController,
                        onChanged: (string) {
                          debugPrint('shadeController=> $string');
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Shade Name',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _includeTaxBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        'Yes',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (itemList[index].includeTax != 'Yes') {
                          itemList[index].tax = '';
                        }
                        setState(() {
                          itemList[index].includeTax = 'Yes';
                        });
                        debugPrint('Yes');
                      },
                    ),
                    ListTile(
                      dense: true,
                      title: Text('No', style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.pop(context);
                        if (itemList[index].includeTax != 'No') {
                          itemList[index].tax = '';
                        }
                        setState(() {
                          itemList[index].rate = itemList[index].basicRate;
                          itemList[index].clbRate = itemList[index].basicRate;
                          itemList[index].includeTax = 'No';
                        });
                      },
                    ),
                  ],
                ),
              )),
            ],
          );
        });
  }

  void _statusBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(
                        'Yes',
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        itemList[index].status = 'Yes';
                        setState(() {});
                        debugPrint('Yes');
                      },
                    ),
                    ListTile(
                      dense: true,
                      title: Text('No', style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.pop(context);
                        itemList[index].status = 'No';
                        debugPrint('No');
                        setState(() {});
                      },
                    ),
                  ],
                ),
              )),
            ],
          );
        });
  }

  void _partyAddressSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  //      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(addressList[index].add0! +
                            addressList[index].add1! +
                            addressList[index].add2! +
                            addressList[index].city!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _addressController.text = addressList[index].add0! +
                      ' ' +
                      addressList[index].add1! +
                      ' ' +
                      addressList[index].add2! +
                      ' ' +
                      addressList[index].city!;
                  rankCode = addressList[index].id;
                  Navigator.of(context).pop();
                },
              ),
              itemCount: addressList.length,
            ),
          );
        });
  }

  void _partyBottomSheet(context) {
    partyList.clear();
    partyList.addAll(mainPartyList);
    setState(() {});

    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<PartyModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select party name' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      _partyController.text = sg.name!;
                      partyCode = sg.id;
                      Navigator.of(context).pop();
                      _addressController.clear();
                      rankCode = '';
                      _getAddress();
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: _partyController,
                        onChanged: (string) {
                          // debugPrint('partyController=> $string');
                          _addressController.clear();
                          rankCode = '';
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Party Name',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getFilteredList(String str) {
    return partyList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getFilteredBrandList(String str) {
    return brandList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getFilteredShadeList(String str) {
    return shadeList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
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
            child: new Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text('Camera', style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 24,
                        ),
                        SizedBox(width: 14),
                        Text(
                          'Gallery',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          );
        });
  }

  _getQtnDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'quotation_id': widget.qtnId.toString(),
    });

    WebService().post(this.context, AppConfig.viewQuotation, json).then(
        (value) => {Navigator.of(this.context).pop(), _parseQtnDetail(value!)});
  }

  _parseQtnDetail(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      var content = data['content'];

      imageBaseUrl = data['image_path'];
      imageCatalogBaseUrl = data['image_item_png_path'];

      logIt('ImageBaseUrlIs-> ${data['image_path']}');

      companyCode = content['comp_code'];
      partyCode = content['acc_code'];
      rankCode = content['add_rank'];
      _remarksController.text =
          content['remarks'] == null ? '' : content['remarks'];
      _QtyNumberController.text =
          content['qtn_no'] == null ? 'N.A' : content['qtn_no'];
      _finYearController.text =
          content['qtn_finyear'] == null ? 'N.A' : content['qtn_finyear'];
      _imageController.text =
          content['img_path'] == null ? 'No Image Found' : 'View Image';
      uploadImageName = content['img_path'] == null ? '' : content['img_path'];
      _entryDateController.text =
          content['qtn_date'] == null ? 'N.A' : content['qtn_date'].toString();

      _companyController.text = content['company_detail'] == null
          ? 'N.A'
          : content['company_detail']['name'];
      _partyController.text = content['party_detail'] == null
          ? 'N.A'
          : content['party_detail']['name'];
      _getPartyList();
      var addressList = content['address_detail'] as List;

      if (addressList.isNotEmpty) {
        var add0 = addressList[0]['add0'] == null ? '' : addressList[0]['add0'];
        var add1 = addressList[0]['add1'] == null ? '' : addressList[0]['add1'];
        var add2 = addressList[0]['add2'] == null ? '' : addressList[0]['add2'];
        _addressController.text = '$add0 $add1 $add2';
      }

      var itemsList = content['order_items'] as List;

      itemList.addAll(
          itemsList.map((e) => ItemMasterModel.parseEditable(e)).toList());

      var termsList = content['quotation_items'] as List;

      selectedTermsList
          .addAll(termsList.map((e) => TermsModel.parseEdit(e)).toList());
    }

    setState(() {});
  }

  Future _selectDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: this.context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);

      if (selectedDate == null) return;

      debugPrint("SelectedDate $selectedDate ");

      setState(() {
        _entryDateController.text =
            "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  void showDeleteWarning(BuildContext context, int index) {
    AlertDialog alert = AlertDialog(
      title: Text('Delete Warning!'),
      content: Text('Are sure you want to delete this item?'),
      actions: [
        ElevatedButton(
          child: Text("Yes"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() {
              if (isEditable && widget.qtnId != null) {
                Map jsonBody = {
                  'sqd_pk': itemList[index].id,
                  'sqh_fk': widget.qtnId,
                  'user_id': getUserId()
                };
                web.WebService.fromApi(
                        AppConfig.deleteQuotation, this, jsonBody)
                    .callPostService(context);
                itemList.removeAt(index);
              } else {
                itemList.removeAt(index);
              }
            });
          },
        ),
        ElevatedButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
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

  _getUomList() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'table_name': 'UOM_MASTER'});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(this.context, AppConfig.searchItemParameters, jsonEncoder)
        .then((value) => {Navigator.pop(this.context), _parseUom(value!)});
  }

  _parseUom(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        uomList.clear();
        uomList.addAll(contentList.map((e) => UomModel.fromJSON(e)).toList());

        debugPrint('uomList ${uomList.length}');

        setState(() {});
      }
    }
  }

  _getBrandList() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'table_name': 'BRAND_MASTER'});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(this.context, AppConfig.searchItemParameters, jsonEncoder)
        .then((value) => {Navigator.pop(this.context), _parseBrand(value!)});
  }

  _parseBrand(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        brandList.clear();
        brandList.addAll(contentList.map((e) => UomModel.fromJSON(e)).toList());

        debugPrint('uomList ${brandList.length}');

        setState(() {});
      }
    }
  }

  _getShadeList() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'table_name': 'SHADE_MASTER'});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(this.context, AppConfig.searchItemParameters, jsonEncoder)
        .then((value) => {Navigator.pop(this.context), _parseShade(value!)});
  }

  _parseShade(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        shadeList.clear();
        shadeList.addAll(contentList.map((e) => UomModel.fromJSON(e)).toList());

        debugPrint('uomList ${uomList.length}');

        setState(() {});
      }
    }
  }

  _getItemParamList(String? itemCode) {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(this.context);

    var jsonEncoder =
        jsonEncode(<String, dynamic>{'user_id': userId, 'item_code': itemCode});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(this.context, AppConfig.getCatalogItemParameters, jsonEncoder)
        .then(
            (value) => {Navigator.pop(this.context), _parseCatParams(value!)});
  }

  _parseCatParams(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        catParamsList.clear();
        catParamsList
            .addAll(contentList.map((e) => UomModel.fromJSON2(e)).toList());

        debugPrint('catParamsList ${catParamsList.length}');

        setState(() {});
      }
    }
  }

  updateRate(String bRate, int index) {
    if (itemList[index].basicRate.isEmpty) return;
    double tax = itemList[index].tax.isEmpty
        ? 0.0
        : (double.parse(bRate) * double.parse(itemList[index].tax) / 100);
    itemList[index].rate = '${double.parse(bRate) - tax}';
    // itemList[index].clbRate = '${double.parse(bRate) + tax}';

    debugPrint('tax-> $tax');
    setState(() {});
  }

  _addTermRemarks(int index) {
    _termController.text = selectedTermsList[index].remarks;
    Commons().showAnimatedDialog(
        this.context,
        AlertDialog(
          title: Text('Add Remarks'),
          content: TextFormField(
            controller: _termController,
            decoration: InputDecoration(
                labelText: 'Remarks',
                floatingLabelBehavior: FloatingLabelBehavior.auto),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  popIt(this.context);
                },
                child: Text('Skip')),
            TextButton(
                onPressed: () {
                  setState(() {
                    selectedTermsList[index].remarks = _termController.text;
                  });
                  _termController.clear();
                  logIt('Term Remark-> ${selectedTermsList[index].remarks}');
                  popIt(this.context);
                },
                child: Text('Add'))
          ],
        ));
  }

  _getTerms() {
    Map jsonBody = {
      'user_id': getUserId(),
      'table_name': 'TERMS_MASTER',
      'term_type': 'sale_qtn'
    };
    web.WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(this.context);
  }

  _getCatalog(String catalogId) {
    Map jsonBody = {
      'user_id': getUserId(),
      'item_ids': catalogId,
      'item_type': '2',
      'full_detail': '1'
    };

    web.WebService.fromApi(AppConfig.getItemDetails, this, jsonBody)
        .callPostService(this.context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getItemDetails:
          {
            var data = jsonDecode(response!);

            logIt('onCatalogAdd-> $data');

            if (data['error'] == 'false') {
              bool isBlocked = false;

              var contentListCatalog = data['catalog_content'] as List;

              contentListCatalog.forEach((e) {
                isBlocked = e['block_catalog_status'] != null;
              });

              // itemList.addAll(contentListCatalog.map((e) => ItemMasterModel.fromJSONCatalog(e)).toList());

              if (!isBlocked)
                itemList.addAll(contentListCatalog
                    .map((e) => ItemMasterModel.fromJSONCatalog(e))
                    .toList());
              //contentListCatalog.map((e) => itemList.add(ItemMasterModel.fromJSONCatalog(e)));
              else
                Commons()
                    .showAlert(this.context, 'Catalog is blocked', 'Error!');

              logIt('Item Blocked -> $isBlocked');
              logIt('ItemListSize-> ${itemList.length}');

              setState(() {});
            }
          }
          break;
        case AppConfig.searchItemParameters:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;
              termsList.clear();
              if (widget.qtnId == null) selectedTermsList.clear();
              termsList.addAll(
                  contentList.map((e) => TermsModel.fromJOSN(e)).toList());
              if (widget.qtnId == null)
                selectedTermsList
                    .addAll(termsList.where((element) => element.isDefault));
              setState(() {});
            }
          }
          break;
        case AppConfig.deleteQuotation:
          {
            var data = jsonDecode(response!);
            Commons().showAlert(this.context, data['message'], 'Success');
          }
      }
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }
}
