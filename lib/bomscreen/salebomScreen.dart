import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/ViewImages/ImageViewer.dart';
import 'package:dataproject2/bommodel/bom_order_model.dart';
import 'package:dataproject2/bomscreen/companyselection2.dart';
import 'package:dataproject2/bomscreen/process_items_screen.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sale_bom_order_model.dart';

class SaleBomScreen extends StatefulWidget {
  final companycode, userid, iconlink, search_user_id;

  const SaleBomScreen(
      {Key? key,
      this.companycode,
      this.userid,
      this.iconlink,
      this.search_user_id})
      : super(key: key);

  @override
  _SaleBomScreenState createState() => _SaleBomScreenState();
}

class _SaleBomScreenState extends State<SaleBomScreen> {
  String bomOrderApiUrl = "${AppConfig.baseUrl}api/order_bom_lists";
  String approvalapiurl = "${AppConfig.baseUrl}api/bom_order_update";

  bool isLoading = false;
  var jsonResponse;
  Future<BomOrderModel?>? future;
  int? listitems, listorders;

  List? list1;
  List? list;

  bool checkOrdertype = true;
  var firstdata;

  File? _image;
  final picker = ImagePicker();

  double? height;
  double? width;
  int _current = 0;
  String? _imageBaseUrl = '';
  List<SaleOrderBomModel> _list = [];

  void initState() {
    logIt('WhatRuns-> SaleBomScreen');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() async {
    Commons().showProgressbar(context);
    var future = await getdetailsoforders(
        widget.userid, widget.companycode, widget.search_user_id);
    popIt(context);
  }

  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompanySelection2(
                  userid: widget.userid,
                  name: name,
                )));
    return Future.value(false);
  }

  Future<BomOrderModel?> getdetailsoforders(
      String? userid, String? companycode, String? search_user_id) async {
    /// Search UserId
    if (search_user_id != null) {
      Map data = {
        'user_id': userid,
        'company_code': companycode,
        'search_user_id': search_user_id
      };

      // Commons().showProgressbar(context);

      var response = await http.post(Uri.parse(bomOrderApiUrl), body: data);

      logIt('SaleBomScreen W/o UserId-> $bomOrderApiUrl \n $data');

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');
        var content = jsonResponse['content'] as List;

        _list.clear();
        _list
            .addAll(content.map((e) => SaleOrderBomModel.fromJSON(e)).toList());

        firstdata = jsonResponse['content'];
        list1 = jsonResponse['content'];
        list = firstdata[list1!.length - 1]['order_items'];

        setState(() {
          listorders = list1!.length;
          listitems = list!.length;
        });

        return BomOrderModel.fromJson(jsonResponse);
      } else {
        setState(() {
          isLoading = false;
        });
      }

      // popIt(context);
    } else {
      Map data = {
        'user_id': userid,
        'company_code': companycode,
      };

      debugPrint('Params-> $data');

      // Commons().showProgressbar(context);

      var response = await http.post(Uri.parse(bomOrderApiUrl), body: data);

      logIt('SaleBomScreen -> $bomOrderApiUrl \n $data');

      if (response.statusCode == 200) {
        print("bom screen7");
        jsonResponse = json.decode(response.body);

        _list.clear();

        var content = jsonResponse['content'] as List;

        _list
            .addAll(content.map((e) => SaleOrderBomModel.fromJSON(e)).toList());

        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');

        print("SaleBomScreen $jsonResponse");
        firstdata = jsonResponse['content'];
        list1 = jsonResponse['content'];

        list = firstdata[list1!.length - 1]['order_items'];

        setState(() {
          listorders = list1!.length;

          listitems = list!.length;
        });

        return BomOrderModel.fromJson(jsonResponse);
      } else {
        setState(() {
          isLoading = false;
        });
      }

      // popIt(context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
//                      child: Image.asset('images/appstore.png', width: 50, height: 50)
                  child: Image.network(
                    widget.iconlink,
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Sale Order Bom1',
                ),
              ],
            ),
            backgroundColor: Color(0xFFFF0000),
          ),
          body: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _list.length,
            itemBuilder: (context, pageViewIndex) {
              var list = firstdata[pageViewIndex]['order_items'];

              return Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /// Order Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Order Date',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(_list[pageViewIndex].date!,
                                  style: TextStyle(
                                    backgroundColor: Colors.white,
                                    color: Color(0xFF2e2a2a),
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      /// Order Date & Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //order container
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Insert Date Time',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(_list[pageViewIndex].insertDateTime!,
                                  style: TextStyle(
                                    backgroundColor: Colors.white,
                                    color: Color(0xFF2e2a2a),
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                  )),
                            ),
                          ),
                        ],
                      ),

                      /// Party Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Party',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 8,
                              ),
                              child: Text(
                                _list[pageViewIndex].party!,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Order No.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Sale Order No.',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                _list[pageViewIndex].saleOrderNo!,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      /// Remarks.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Remarks',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 185,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                _list[pageViewIndex].remarks!.handleEmpty(),
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 16,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: _list[pageViewIndex].itemList!.length,
                      itemBuilder: (context, index) {
                        List list2 = list[index]["process_items"];
                        int processTotal = list2.length;
                        var listvar = list[index]["order_type"];
                        var ordertype;

                        if (listvar == "M") {
                          ordertype = "Manufacturing";
                          checkOrdertype = true;
                        } else if (listvar == "T") {
                          ordertype = "Trading";
                          checkOrdertype = true;
                        } else if (listvar == "B") {
                          ordertype = "Both";
                          checkOrdertype = true;
                        } else if (listvar == "N") {
                          ordertype = "N/A";
                          checkOrdertype = false;
                        } else if (listvar == "S") {
                          ordertype = "Stock";
                          checkOrdertype = true;
                        } else if (listvar == "O") {
                          ordertype = "Others Stock";
                          checkOrdertype = true;
                        } else {
                          ordertype = "";
                        }
                        logIt('Change ->>> ');
                        /*if(!kReleaseMode){
                          ordertype = "N/A";
                          checkOrdertype = false;
                        }*/

                        return Column(
                          children: [
                            /// Item Images
                            SizedBox(
                              height: width! / 1.5,
                              child: Container(
                                width: width,
                                height: width! / 1.5,
                                child: _list[pageViewIndex]
                                        .itemList![index]
                                        .imageList!
                                        .isNotEmpty
                                    ? Stack(
                                        children: [
                                          PhotoViewGallery.builder(
                                            backgroundDecoration: BoxDecoration(
                                                color: Colors.white),
                                            scrollPhysics:
                                                const BouncingScrollPhysics(),
                                            builder: (BuildContext context,
                                                int imgIndex) {
                                              return PhotoViewGalleryPageOptions(
                                                imageProvider: NetworkImage(
                                                    '$_imageBaseUrl/${_list[pageViewIndex].itemList![index].imageList![imgIndex]}.png'),
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
                                            itemCount: _list[pageViewIndex]
                                                .itemList![index]
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
                                          ),
                                          Visibility(
                                            visible: ifHasPermission(
                                                permType: PermType.INSERT,
                                                compCode: widget.companycode,
                                                permission: Permissions
                                                    .SO_BOM_APPROVAL)!,
                                            child: Positioned(
                                                top: 12,
                                                right: 20,
                                                child: InkWell(
                                                  onTap: () {
                                                    _updateImage(
                                                        _list[pageViewIndex]
                                                            .itemList![index]
                                                            .id,
                                                        _list[pageViewIndex]
                                                            .itemList![index]
                                                            .catalogName);
                                                  },
                                                  child: Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColor.appRed,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      14)),
                                                      child: Icon(Icons.edit,
                                                          color: Colors.white,
                                                          size: 16)),
                                                )),
                                          )
                                        ],
                                      )
                                    : Container(
                                        color: Colors.white,
                                        child: Center(
                                          child:
                                              Image.asset('images/noImage.png'),
                                        ),
                                      ),
                                //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
                              ),
                            ),

                            /// Carousel Indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _list[pageViewIndex]
                                  .itemList![index]
                                  .imageList!
                                  .map((item) {
                                int mIndex = _list[pageViewIndex]
                                    .itemList![index]
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

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 370,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF0000),
                                    border: Border.all(
                                      color: Color(0xFFFF0000),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ITEM DETAILS - ' +
                                          (index + 1).toString() +
                                          "/" +
                                          _list[pageViewIndex]
                                              .itemList!
                                              .length
                                              .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment:CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8, right: 4),
                                        child: Text(
                                          "Catalog Name",
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8, right: 5),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .catalogName!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 96,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10),
                                        child: Text(
                                          'Catalog Item Name',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 96,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10, right: 2),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .catalogItemName!
                                              .trim()
                                              .handleEmpty(),
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Party Order No.',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8, right: 2),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .partyOrderNo!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Qty.',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .qty!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Uom',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .qtyUom!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Order Type',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .orderType!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'MFG Qty ',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .mfgQty!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Trading Qty',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .tradingQty!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Delivery Date',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .deliveryDate!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// SO Order Approval UserName
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Sale Order Approved By:',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .saleOrderApprovedBy!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// SO Order Approval Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Sale Order Approved Date:',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .saleOrderApprovedDate!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// Remarks
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          'Remarks',
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 185,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color(0xFF766F6F),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8),
                                        child: Text(
                                          _list[pageViewIndex]
                                              .itemList![index]
                                              .remarks!,
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Color(0xFF2e2a2a),
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// View  and Add Images
                                Container(
                                  width: 360,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// View Images
                                      Visibility(
                                        visible: ifHasPermission(
                                            permType: PermType.SEARCH,
                                            compCode: widget.companycode,
                                            permission:
                                                Permissions.SO_BOM_APPROVAL)!,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewItemDetail(
                                                            selectedItem: [
                                                              ItemResultModel(
                                                                  id: _list[
                                                                          pageViewIndex]
                                                                      .itemList![
                                                                          index]
                                                                      .catalogName,
                                                                  itemType: '2')
                                                            ],
                                                          )));
                                            },
                                            child: Container(
                                                width: 170,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColor.appBlue,
                                                  border: Border.all(
                                                    color: AppColor.appBlue,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Center(
                                                    //View Image(${(list[index]["catalog_item"]['image_count'] as int).toString()})
                                                    child: Text("View",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            letterSpacing:
                                                                2.17)))),
                                          ),
                                        ),
                                      ),

                                      /// Add Images
                                      Visibility(
                                        visible: ifHasPermission(
                                            permType: PermType.INSERT,
                                            compCode: widget.companycode,
                                            permission:
                                                Permissions.SO_BOM_APPROVAL)!,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              _imageBottomSheet(
                                                  context,
                                                  _list[pageViewIndex]
                                                      .itemList![index]
                                                      .id,
                                                  _list[pageViewIndex]
                                                      .itemList![index]
                                                      .catalogName);
                                            },
                                            child: Container(
                                                width: 170,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColor.appBlue,
                                                  border: Border.all(
                                                    color: AppColor.appBlue,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Add Image",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 16,
                                                            letterSpacing:
                                                                2.17)),
                                                    SizedBox(width: 4),
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// View Process
                                processTotal == 0
                                    ? SizedBox()
                                    : Visibility(
                                        visible: ifHasPermission(
                                            permType: PermType.MODIFIED,
                                            compCode: widget.companycode,
                                            permission:
                                                Permissions.SO_BOM_APPROVAL)!,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProcessItemsScreen(
                                                            //datareceived: list[index]["process_items"],
                                                            datareceived: _list[
                                                                    pageViewIndex]
                                                                .itemList![index],
                                                            iconlink:
                                                                widget.iconlink,
                                                          )));
                                            },
                                            child: Container(
                                                width: 370,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF0000),
                                                  border: Border.all(
                                                    color: Color(0xFFFF0000),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Center(
                                                    child: Text("VIEW PROCESS",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 20,
                                                            letterSpacing:
                                                                2.17)))),
                                          ),
                                        ),
                                      ),

                                /// Approve
                                ordertype == "Trading"
                                    ? Visibility(
                                        visible: ifHasPermission(
                                            permType: PermType.MODIFIED,
                                            compCode: widget.companycode,
                                            permission:
                                                Permissions.SO_BOM_APPROVAL)!,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'APPROVE ALERT',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Are You Sure You Want To Approve this Item?'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: Text('No',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .red)),
                                                        onPressed: () {
                                                          setState(() {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        onPressed: () async {
                                                          Map data = {
                                                            'order_item_id':
                                                                _list[pageViewIndex]
                                                                    .itemList![
                                                                        index]
                                                                    .itemId,
                                                            'user_id': widget
                                                                .userid
                                                                .toString(),
                                                            "company_code":
                                                                widget
                                                                    .companycode
                                                                    .toString()
                                                          };

                                                          var jsonResponse;

                                                          var response =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      approvalapiurl),
                                                                  body: data);
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            jsonResponse = json
                                                                .decode(response
                                                                    .body);
                                                            print(
                                                                'Response status: ${response.statusCode}');
                                                            print(
                                                                'Response body: ${response.body}');
                                                            String? errorcheck =
                                                                jsonResponse[
                                                                    'error'];

                                                            if (errorcheck ==
                                                                "false") {
                                                              _list.removeAt(
                                                                  index);
                                                              print(index);

                                                              if (AppConfig
                                                                      .prefs
                                                                      .getInt(
                                                                          'fcmCount')! >
                                                                  0) {
                                                                AppConfig.prefs.setInt(
                                                                    'fcmCount',
                                                                    AppConfig
                                                                            .prefs
                                                                            .getInt('fcmCount')! -
                                                                        1);
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              if (_list
                                                                      .length ==
                                                                  0) {
                                                                setState(() {
                                                                  future = getdetailsoforders(
                                                                      widget
                                                                          .userid,
                                                                      widget
                                                                          .companycode,
                                                                      widget
                                                                          .search_user_id);
                                                                });
                                                              } else {
                                                                print(
                                                                    'no calling');
                                                              }

                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Order Item has been approved successfully.",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);

                                                              setState(() {});
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Approval Not Successful",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                              width: 370,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF006C66),
                                                border: Border.all(
                                                  color: Color(0xFF006C66),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                  child: Text("APPROVE",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 20,
                                                          letterSpacing:
                                                              2.17)))),
                                        ),
                                      )
                                    : (checkOrdertype == false ||
                                            (checkOrdertype == true &&
                                                (processTotal == 0))
                                        ? SizedBox()
                                        : Visibility(
                                            visible: ifHasPermission(
                                                permType: PermType.MODIFIED,
                                                compCode: widget.companycode,
                                                permission: Permissions
                                                    .SO_BOM_APPROVAL)!,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'APPROVE ALERT',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    'Are You Sure You Want To Approve this Item?'),
                                                                //Text('please enter the country?'),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: Text('No',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .red)),
                                                              onPressed: () {
                                                                setState(() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Map data = {
                                                                  'order_item_id': _list[
                                                                          pageViewIndex]
                                                                      .itemList![
                                                                          index]
                                                                      .itemId,
                                                                  'user_id': widget
                                                                      .userid
                                                                      .toString(),
                                                                  "company_code": widget
                                                                      .companycode
                                                                      .toString()
                                                                };

                                                                var jsonResponse;

                                                                var response =
                                                                    await http.post(
                                                                        Uri.parse(
                                                                            approvalapiurl),
                                                                        body:
                                                                            data);
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  jsonResponse =
                                                                      json.decode(
                                                                          response
                                                                              .body);
                                                                  String?
                                                                      errorcheck =
                                                                      jsonResponse[
                                                                          'error'];

                                                                  if (errorcheck ==
                                                                      "false") {
                                                                    _list.removeAt(
                                                                        index);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    if (_list
                                                                            .length ==
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        future = getdetailsoforders(
                                                                            widget.userid,
                                                                            widget.companycode,
                                                                            widget.search_user_id);
                                                                      });
                                                                    }

                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Order Item has been approved successfully.",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Approval Not Successful",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                  }
                                                                }
                                                                // approvalbutton(list[index]["sod_pk"].toString(),widget.userid.toString(), index1, index2);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                    width: 370,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF006C66),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFF006C66),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                        child: Text("APPROVE",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    2.17)))),
                                              ),
                                            ),
                                          )),

                                /// Reject
                                ordertype == "Trading"
                                    ? Visibility(
                                        visible: ifHasPermission(
                                            permType: PermType.MODIFIED,
                                            compCode: widget.companycode,
                                            permission:
                                                Permissions.SO_BOM_APPROVAL)!,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'REJECT ALERT',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Are You Sure You Want To Reject this Item?'),
                                                          //Text('please enter the country?'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        child: Text('No',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .red)),
                                                        onPressed: () {
                                                          setState(() {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        onPressed: () async {
                                                          Map data = {
                                                            'reject_status':
                                                                '1',
                                                            'order_item_id':
                                                                _list[pageViewIndex]
                                                                    .itemList![
                                                                        index]
                                                                    .itemId,
                                                            'user_id': widget
                                                                .userid
                                                                .toString(),
                                                            "company_code":
                                                                widget
                                                                    .companycode
                                                                    .toString()
                                                          };

                                                          var jsonResponse;

                                                          var response =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      approvalapiurl),
                                                                  body: data);

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            jsonResponse = json
                                                                .decode(response
                                                                    .body);
                                                            String? errorcheck =
                                                                jsonResponse[
                                                                    'error'];

                                                            if (errorcheck ==
                                                                "false") {
                                                              _list.removeAt(
                                                                  index);

                                                              if (AppConfig
                                                                      .prefs
                                                                      .getInt(
                                                                          'fcmCount')! >
                                                                  0) {
                                                                AppConfig.prefs.setInt(
                                                                    'fcmCount',
                                                                    AppConfig
                                                                            .prefs
                                                                            .getInt('fcmCount')! -
                                                                        1);
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              setState(() {
                                                                future = getdetailsoforders(
                                                                    widget
                                                                        .userid,
                                                                    widget
                                                                        .companycode,
                                                                    widget
                                                                        .search_user_id);
                                                              });
                                                              /*if (_list.length == 0) {
                                                          setState(() {
                                                            _future = getdetailsoforders(widget.userid, widget.companycode, widget.search_user_id);
                                                          });
                                                        } else {
                                                          print('no calling');
                                                        }*/

                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Order Item has been Rejected successfully.",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                              setState(() {});
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Reject Not Successful",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                              width: 370,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColor.appRed,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                  child: Text("REJECT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 20,
                                                          letterSpacing:
                                                              2.17)))),
                                        ),
                                      )
                                    : (checkOrdertype == false ||
                                            (checkOrdertype == true &&
                                                (processTotal == 0))
                                        ? SizedBox()
                                        : Visibility(
                                            visible: ifHasPermission(
                                                permType: PermType.MODIFIED,
                                                compCode: widget.companycode,
                                                permission: Permissions
                                                    .SO_BOM_APPROVAL)!,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'REJECT ALERT',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    'Are You Sure You Want To Reject this Item?'),
                                                                //Text('please enter the country?'),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: Text('No',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .red)),
                                                              onPressed: () {
                                                                setState(() {
//                                                                avatarImageFile1 =null;
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Map data = {
                                                                  'reject_status':
                                                                      '1',
                                                                  'order_item_id': _list[
                                                                          pageViewIndex]
                                                                      .itemList![
                                                                          index]
                                                                      .itemId,
                                                                  'user_id': widget
                                                                      .userid
                                                                      .toString(),
                                                                  "company_code": widget
                                                                      .companycode
                                                                      .toString()
                                                                };

                                                                logIt(
                                                                    'Rejection_Clicked-> $data');
                                                                var jsonResponse;
                                                                var response =
                                                                    await http.post(
                                                                        Uri.parse(
                                                                            approvalapiurl),
                                                                        body:
                                                                            data);
                                                                print(
                                                                    'Response status: ${response.statusCode}');
                                                                print(
                                                                    'Response body: ${response.body}');

                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  jsonResponse =
                                                                      json.decode(
                                                                          response
                                                                              .body);

                                                                  String?
                                                                      errorcheck =
                                                                      jsonResponse[
                                                                          'error'];

                                                                  if (errorcheck ==
                                                                      "false") {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();

                                                                    logIt(
                                                                        'LengthReject- ${list.length}');

                                                                    if (list.length >
                                                                        1) {
                                                                      list.removeAt(
                                                                          index);
                                                                    } else {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                    setState(
                                                                        () {
                                                                      future = getdetailsoforders(
                                                                          widget
                                                                              .userid,
                                                                          widget
                                                                              .companycode,
                                                                          widget
                                                                              .search_user_id);
                                                                    });
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Order Item has been Rejected successfully.",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Reject Not Successful",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                    width: 370,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: AppColor.appRed,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                        child: Text("REJECT",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    2.17)))),
                                              ),
                                            ),
                                          )),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              );
            },
            onPageChanged: (v) {
              setState(() {
                _current = 0;
              });
            },
          )),
    );
  }

  void _imageBottomSheet(context, String? itemCode, String? catCode) async {
    debugPrint('ImageBottomSheet ItemCode $itemCode');

    var mFile = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageEditor()));

    if (mFile == null) return;
    _image = mFile['file'];

    _uploadImage(_image!.absolute.path, itemCode!, catCode!);
  }

  _updateImage(String? itemCode, String? catCode) async {
    var mFile = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageViewer(
                  itemCode: catCode,
                )));

    logIt('uploadImageMap-> $mFile');

    if (mFile != null) {
      _image = mFile['file'];
      updateToServer(
          _image!.absolute.path, mFile['codePk'], catCode!, itemCode!);
    }
  }

  updateToServer(String filename, String codePk, String catalogCode,
      String itemCode) async {
    Commons().showProgressbar(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_id = prefs.getString('user_id')!;

    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.updateCatalogImage));

    request.files.add(await http.MultipartFile.fromPath(
      'filename',
      filename,
    ));

    request.fields['user_id'] = user_id;
    request.fields['catalog_code'] = catalogCode;
    request.fields['item_code'] = itemCode;
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
        Commons.showToast('Image Updated Successfully');
      } else {
        Commons.showToast('Something went wrong!');
      }
    }
    getdetailsoforders(
        widget.userid, widget.companycode, widget.search_user_id);
    debugPrint('UploadImage ${res.body}');
  }

  Future getImage(ImageSource imgSrc, String itemCode, String catCode) async {
    final dir = await getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    final pickedFile = await picker.pickImage(source: imgSrc);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      /*  File? compFile = await Commons.compressAndGetFile(_image!, targetPath);
      _image = compFile; */

      _uploadImage(_image!.absolute.path, itemCode, catCode);
      setState(() {});
      debugPrint("Image Path is ${pickedFile.path}");
      debugPrint("Image File Path is $_image");
    } else {
      print('No image selected.');
    }
  }

  _uploadImage(String filename, String itemCode, String catalogCode) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_id = prefs.getString('user_id')!;
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.uploadItemImages));

    request.files.add(await http.MultipartFile.fromPath(
      'filename',
      filename,
    ));

    debugPrint('ItemCode $itemCode catalogCode $catalogCode');

    request.files.forEach((element) {
      debugPrint('Upload_Files ${element.field} ${element.filename}');
    });

    request.fields['user_id'] = user_id;
    request.fields['item_code'] = itemCode;
    request.fields['catalog_code'] = catalogCode;

    debugPrint('UploadImage ${AppConfig.baseUrl + AppConfig.uploadItemImages}');

    request.fields.forEach((key, value) {
      debugPrint('Upload_Image Param $key $value');
    });

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        debugPrint('UploadImage Response Ready to fire');
        future = getdetailsoforders(
            widget.userid, widget.companycode, widget.search_user_id);
      }
    }

    debugPrint('UploadImage Response ${res.body}');
    debugPrint('UploadImage ${res.statusCode}');
  }
}
