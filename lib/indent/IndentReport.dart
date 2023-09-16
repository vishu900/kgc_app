import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/ViewImages/ImageViewer.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/newmodel/neworder.dart';
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

import 'IndentCompanySelection.dart';

class IndentReport extends StatefulWidget {
  final companycode, userid, iconlink, search_user_id, type, orderType, orderId;

  const IndentReport(
      {Key? key,
      this.companycode,
      this.userid,
      this.iconlink,
      this.search_user_id,
      this.type,
      this.orderId,
      this.orderType})
      : super(key: key);

  @override
  _IndentReportState createState() => _IndentReportState();
}

class _IndentReportState extends State<IndentReport> {
  TextEditingController? contactpersoncontroller;
  TextEditingController? approvedbyperson;
  List<Content>? orderdetails;
  var orderdetail;
  String? code, name;

  String newapi = "${AppConfig.baseUrl}api/indent_report_lists";
  String alertDetails = "${AppConfig.baseUrl}api/order_details";
  bool? isLoading, total;
  Future<NewOrder?>? _future;
  int imageCount = 0;

  int? listitems, listorders = null;
  var jsonResponse;

  File? _image;
  final picker = ImagePicker();

  bool? hasApprovePerm = AppConfig.prefs.getBool(Permissions.IndentApprove);
  double? height;
  double? width;
  int _current = 0;
  String? _imageBaseUrl = '';

  void initState() {
    super.initState();

    _future = getdetailsoforders(
        widget.userid, widget.companycode, widget.search_user_id);

    contactpersoncontroller = new TextEditingController();
    approvedbyperson = new TextEditingController();
  }

  String approvalapiurl = "${AppConfig.baseUrl}api/indent_order_update";

  approvalbutton(String orderid, String userid, int index1, int index12) async {
    print("index1");
    print(index1);
    print("index2");
    print(index12);
  }

  int number = 1;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    //final heightSize = SizedBox(height: 25);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.iconlink,
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Indent Reports',
                )
              ],
            ),
            backgroundColor: Color(0xFFFF0000),
          ),
          body: FutureBuilder<NewOrder?>(
              future: _future,
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return Center(
                        child: Text("No Sale Orders to Approve!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)));
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text("No Sale Orders to Approve!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)));
                    } else {
                      return listorders == 0
                          ? Center(
                              child: Text("No Sale Orders to Approve!"),
                            )
                          : PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.content!.length,
                              itemBuilder: (context, pageViewIndex) {
                                //var st = snapshot.data!.content;
                                var firstdata = jsonResponse['content'];
                                //int index1 = pageViewIndex;
                                var list =
                                    firstdata[pageViewIndex]['order_items'];

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            //order container
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                  'Indent Date',
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
                                                    color: Color(0xFF2e2a2a),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                    firstdata[pageViewIndex]
                                                        ["indent_date"],
                                                    style: TextStyle(
                                                      backgroundColor:
                                                          Colors.white,
                                                      color: Color(0xFF2e2a2a),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 12,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                  'Indent No.',
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
                                                    color: Color(0xFF2e2a2a),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                  firstdata[pageViewIndex]
                                                      ['indent_no'],
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
                                                    color: Color(0xFF2e2a2a),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    color: Color(0xFF2e2a2a),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 32,
                                              width: 180,
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
                                                  firstdata[pageViewIndex]
                                                              ['remarks'] ==
                                                          null
                                                      ? 'N.A'
                                                      : firstdata[pageViewIndex]
                                                          ['remarks'],
                                                  style: TextStyle(
                                                    backgroundColor:
                                                        Colors.white,
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
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(
                                            height: 16,
                                          );
                                        },
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              /// Item Images
                                              SizedBox(
                                                height: width! / 1.5,
                                                child: Container(
                                                  width: width,
                                                  height: width! / 1.5,
                                                  child: (firstdata[pageViewIndex]
                                                                          [
                                                                          'order_items']
                                                                      [index][
                                                                  'catalog_item']
                                                              [
                                                              'image_name'] as List)
                                                          .isNotEmpty
                                                      ? Stack(
                                                          children: [
                                                            PhotoViewGallery
                                                                .builder(
                                                              backgroundDecoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white),
                                                              scrollPhysics:
                                                                  const BouncingScrollPhysics(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  int imgIndex) {
                                                                return PhotoViewGalleryPageOptions(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                          '$_imageBaseUrl/${firstdata[pageViewIndex]['order_items'][index]['catalog_item']['image_name'][imgIndex]}.png'),
                                                                  initialScale:
                                                                      PhotoViewComputedScale
                                                                              .contained *
                                                                          0.8,
                                                                );
                                                              },
                                                              onPageChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _current =
                                                                      value;
                                                                });
                                                              },
                                                              itemCount: (firstdata[pageViewIndex]['order_items']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'catalog_item']
                                                                      [
                                                                      'image_name'] as List)
                                                                  .length,
                                                              loadingBuilder:
                                                                  (context,
                                                                          event) =>
                                                                      Center(
                                                                child:
                                                                    Container(
                                                                  width: 40.0,
                                                                  height: 40.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: event ==
                                                                            null
                                                                        ? 0
                                                                        : event.cumulativeBytesLoaded /
                                                                            event.expectedTotalBytes!,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: ifHasPermission(
                                                                  permType: PermType
                                                                      .MODIFIED,
                                                                  compCode: widget
                                                                      .companycode,
                                                                  permission:
                                                                      Permissions
                                                                          .INDENT_APPROVAL)!,
                                                              child: Positioned(
                                                                  top: 12,
                                                                  right: 20,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      _updateImage(
                                                                          list[index]["item_code"]
                                                                              [
                                                                              'code'],
                                                                          list[index]["catalog_item"]
                                                                              [
                                                                              'code']);
                                                                    },
                                                                    child: Container(
                                                                        height:
                                                                            28,
                                                                        width:
                                                                            28,
                                                                        decoration: BoxDecoration(
                                                                            color: AppColor
                                                                                .appRed,
                                                                            borderRadius: BorderRadius.circular(
                                                                                14)),
                                                                        child: Icon(
                                                                            Icons
                                                                                .edit,
                                                                            color:
                                                                                Colors.white,
                                                                            size: 16)),
                                                                  )),
                                                            )
                                                          ],
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: (firstdata[
                                                                    pageViewIndex]
                                                                ['order_items'][
                                                            index]['catalog_item']
                                                        ['image_name'] as List)
                                                    .map((item) {
                                                  int mIndex = (firstdata[
                                                                      pageViewIndex]
                                                                  [
                                                                  'order_items']
                                                              [
                                                              index]['catalog_item']
                                                          [
                                                          'image_name'] as List)
                                                      .indexOf(item);

                                                  return Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _current == mIndex
                                                          ? Color.fromRGBO(
                                                              0, 0, 0, 0.9)
                                                          : Color.fromRGBO(
                                                              0, 0, 0, 0.4),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),

                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 40,
                                                    width: 360,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFF0000),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFFF0000),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'ITEM DETAILS - ' +
                                                            (index + 1)
                                                                .toString() +
                                                            "/" +
                                                            list.length
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    // crossAxisAlignment:CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8,
                                                                  right: 4),
                                                          child: Text(
                                                            "Catalog Name",
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8,
                                                                  right: 5),
                                                          child: Text(
                                                            list[index][
                                                                    "catalog_item"]
                                                                ['code'],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    // crossAxisAlignment:CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 96,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 10,
                                                                  right: 4),
                                                          child: Text(
                                                            "Catalog Item Name",
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 96,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 10,
                                                                  right: 5),
                                                          child: Text(
                                                            list[index][
                                                                    "catalog_name"]
                                                                .toString()
                                                                .trim(),
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 48,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Party Item Name',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 48,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index][
                                                                "party_item_name"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'QTY.',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["qty"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Uom',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]
                                                                ["qty_uom"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Purchaser Name
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Purchaser Name',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["purchaser_name"] ==
                                                                    null
                                                                ? 'N.A.'
                                                                : list[index][
                                                                    "purchaser_name"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Insert User Name
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Insert User Name',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["insert_user_name"] ==
                                                                    null
                                                                ? 'N.A.'
                                                                : list[index][
                                                                    "insert_user_name"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Party Name
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Party Name',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["sale_items"] !=
                                                                    null
                                                                ? list[index][
                                                                            "sale_items"]
                                                                        [
                                                                        'order_header']
                                                                    [
                                                                    'acc_party_detail']['name']
                                                                : '',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Sale Order Number & Date
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 60,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Sale Order Number\n& Date',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 60,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["sale_items"] !=
                                                                    null
                                                                ? '${list[index]["sale_items"]['order_header']['order_no']} - ${list[index]["sale_items"]['order_header']['order_date']}'
                                                                : '',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Sale Order Qty
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Sale Order Quantity',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["sale_items"] ==
                                                                    null
                                                                ? 'N.A.'
                                                                : list[index][
                                                                        'sale_items']
                                                                    ['qty'],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// New From PO
                                                  /// Sale BOM Order Qty
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Sale Order BOM Quantity',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["sale_items"] ==
                                                                    null
                                                                ? 'N.A.'
                                                                : (int.parse(list[index]['sale_items']
                                                                            [
                                                                            'qty']) *
                                                                        (list[index]['sale_bom_items'] ==
                                                                                null
                                                                            ? 0
                                                                            : double.parse(list[index]['sale_bom_items']['qty'])))
                                                                    .toString(),
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// BOM Percentage
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'BOM Percentage',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["sale_items"] ==
                                                                    null
                                                                ? 'N.A.'
                                                                : (list[index][
                                                                            'sale_bom_items'] ==
                                                                        null
                                                                    ? 'N.A'
                                                                    : (list[index]['sale_bom_items']['qty']
                                                                            .toString()
                                                                            .startsWith(
                                                                                '.')
                                                                        ? '0${list[index]['sale_bom_items']['qty']}%'
                                                                        : list[index]['sale_bom_items']
                                                                            [
                                                                            'qty'])),
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Item Remarks
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            'Remarks',
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 32,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Color(
                                                                0xFF766F6F),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 8),
                                                          child: Text(
                                                            list[index]["remarks"] ==
                                                                    null
                                                                ? 'N.A'
                                                                : list[index]
                                                                    ["remarks"],
                                                            style: TextStyle(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              color: Color(
                                                                  0xFF2e2a2a),
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// View Item Detail and Add Images
                                                  Container(
                                                    width: 360,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /// View Images
                                                        Visibility(
                                                          visible: ifHasPermission(
                                                              permType: PermType
                                                                  .SEARCH,
                                                              compCode: widget
                                                                  .companycode,
                                                              permission:
                                                                  Permissions
                                                                      .INDENT_APPROVAL)!,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8,
                                                                    bottom: 8),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ViewItemDetail(
                                                                              selectedItem: [
                                                                                ItemResultModel(id: list[index]["catalog_item"]['code'], itemType: '2')
                                                                              ],
                                                                            )));
                                                              },
                                                              child: Container(
                                                                  width: 170,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColor
                                                                        .appBlue,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColor
                                                                          .appBlue,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child: Center(
                                                                      child: Text(
                                                                          //View Image(${(list[index]["catalog_item"]['image_count'] as int).toString()})
                                                                          "View",
                                                                          style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 16, letterSpacing: 2.17)))),
                                                            ),
                                                          ),
                                                        ),

                                                        /// Add Images
                                                        Visibility(
                                                          visible: ifHasPermission(
                                                              permType: PermType
                                                                  .INSERT,
                                                              compCode: widget
                                                                  .companycode,
                                                              permission:
                                                                  Permissions
                                                                      .INDENT_APPROVAL)!,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8,
                                                                    bottom: 8),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _imageBottomSheet(
                                                                    context,
                                                                    list[index][
                                                                            "item_code"]
                                                                        [
                                                                        'code'],
                                                                    list[index][
                                                                            "catalog_item"]
                                                                        [
                                                                        'code']);
                                                              },
                                                              child: Container(
                                                                  width: 170,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColor
                                                                        .appBlue,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: AppColor
                                                                          .appBlue,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "Add Image",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 16,
                                                                              letterSpacing: 2.17)),
                                                                      SizedBox(
                                                                          width:
                                                                              4),
                                                                      Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  /// Approve Button
                                                  Visibility(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  'APPROVE ALERT',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      ListBody(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                          'Are You Sure You Want To Approve this Item?'),
                                                                      //Text('please enter the country?'),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  ElevatedButton(
                                                                    child: Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.red)),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
//                                                                avatarImageFile1 =null;
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                  ),
                                                                  ElevatedButton(
                                                                    child: Text(
                                                                      'Yes',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
//                                                              getImage1();

                                                                      Map data =
                                                                          {
                                                                        'order_item_id':
                                                                            list[index]["indent_dtl_pk"].toString(),
                                                                        'user_id': widget
                                                                            .userid
                                                                            .toString()
                                                                      };
                                                                      dynamic
                                                                          jsonResponse =
                                                                          null;

                                                                      var response = await http.post(
                                                                          Uri.parse(
                                                                              approvalapiurl),
                                                                          body:
                                                                              data);
                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        jsonResponse =
                                                                            json.decode(response.body);
                                                                        print(
                                                                            'Response status: ${response.statusCode}');
                                                                        print(
                                                                            'Response body: ${response.body}');
                                                                        String?
                                                                            errorcheck =
                                                                            jsonResponse['error'];
                                                                        debugPrint(
                                                                            'NotificationCount ${list.length}');

                                                                        if (errorcheck ==
                                                                            "false") {
                                                                          list.removeAt(
                                                                              index);
                                                                          print(
                                                                              index);

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          //
                                                                          if (AppConfig.prefs.getInt('fcmCount')! >
                                                                              0) {
                                                                            AppConfig.prefs.setInt('fcmCount',
                                                                                AppConfig.prefs.getInt('fcmCount')! - 1);
                                                                          }
                                                                          if (list.length ==
                                                                              0) {
                                                                            print("final calling");
                                                                            setState(() {
                                                                              _future = getdetailsoforders(widget.userid, widget.companycode, widget.search_user_id);
                                                                            });
                                                                          } else {
                                                                            print('no calling');
                                                                          }

                                                                          Fluttertoast.showToast(
                                                                              msg: "Approved successfully.",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: Colors.red,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);

                                                                          setState(
                                                                              () {});
                                                                        } else {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: "Approval Not Successful",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: Colors.red,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);
                                                                        }
                                                                      }
                                                                      // approvalbutton(list[index]["sod_pk"].toString(),widget.userid.toString(), index1, index2);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });

//                                                Fluttertoast.showToast(msg: "item id " + list[index]["sod_pk"] ,
//                                                    toastLength: Toast.LENGTH_SHORT,
//                                                    gravity: ToastGravity.CENTER,
//                                                    timeInSecForIosWeb: 1,
//                                                    backgroundColor: Colors.red,
//                                                    textColor: Colors.white,
//                                                    fontSize: 16.0);

//                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
                                                      },
                                                      child: Container(
                                                          width: 360,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFFF0000),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFFF0000),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  "APPROVE",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          20,
                                                                      letterSpacing:
                                                                          2.17)))),
                                                    ),
                                                    visible: hasApprovePerm!,
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                );
                              });
                    }
                }
              })),
    );
  }

  Future<NewOrder?> getdetailsoforders(
      String? userid, String? companycode, String? search_user_id) async {
    if (search_user_id != null) {
      Map data;

      if (widget.type == null) {
        print('IndentReport data is null');

        data = {
          'user_id': userid,
          'company_code': companycode,
          'search_user_id': search_user_id
        };
      } else {
        print('IndentReport data is Not null');

        data = {
          'user_id': userid,
          'company_code': companycode,
          'order_type': widget.orderType,
          'order_id': widget.orderId,
        };
      }

      debugPrint("ApiUrl ==> $newapi");
      debugPrint("Params ==> $data");

      var response = await http.post(
          Uri.parse(widget.type == null ? newapi : alertDetails),
          body: data);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');

        List? list1 = jsonResponse['content'];

        setState(() {});

        if (list1 == 0 || list1 == null) {
          setState(() {
            listorders == null;
          });
        } else {
          setState(() {
            listorders = list1.length;
          });
        }

        return NewOrder.fromJson(jsonResponse);
      } else {
        setState(() {
          isLoading = false;
        });

        print('login error');
        print(response.body);
      }
    } else {
      Map data;

      if (widget.type == null) {
        print('IndentReport data is null');

        data = {
          'user_id': userid,
          'company_code': companycode,
        };
      } else {
        print('IndentReport data is Not null');

        data = {
          'user_id': userid,
          'company_code': companycode,
          'order_type': widget.orderType,
          'order_id': widget.orderId,
        };
      }

      var response = await http.post(
          Uri.parse(widget.type == null ? newapi : alertDetails),
          body: data);

      if (response.statusCode == 200) {
        print("called2");
        jsonResponse = json.decode(response.body);
        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');
        debugPrint('IndentRepo $jsonResponse');

        List? list1 = jsonResponse['content'];
        setState(() {});
        if (list1 == 0 || list1 == null) {
          setState(() {
            listorders == null;
          });
        } else {
          setState(() {
            listorders = list1.length;
          });
        }

        return NewOrder.fromJson(jsonResponse);
      } else {
        setState(() {
          isLoading = false;
        });

        print('login error');
        print('IndentReport Response ' + response.body);
      }
    }
    return null;
  }

  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var user_id = prefs.getString('user_id');
    var name = prefs.getString('name');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IndentCompanySelection(
                  userId: widget.userid,
                  name: name,
                )));
    return Future.value(false);
  }

  void _imageBottomSheet(context, String? itemCode, String? catCode) async {
    debugPrint('ImageBottomSheet ItemCode $itemCode');

    var mFile = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageEditor()));

    if (mFile == null) return;
    _image = mFile['file'];

    _uploadImage(_image!.absolute.path, itemCode!, catCode!);

    /* showModalBottomSheet(
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
                      getImage(ImageSource.camera, itemCode, catCode);
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
                      getImage(ImageSource.gallery, itemCode, catCode);
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
        });*/
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
      /*   File? compFile = await Commons.compressAndGetFile(_image!, targetPath);
      _image = compFile; */

      _uploadImage(_image!.absolute.path, itemCode, catCode);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  _uploadImage(String filename, String itemCode, String catCode) async {
    Commons().showProgressbar(this.context);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_id = prefs.getString('user_id')!;
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConfig.baseUrl + AppConfig.uploadItemImages));

    request.files.add(await http.MultipartFile.fromPath(
      'filename',
      filename,
    ));

    request.files.forEach((element) {
      debugPrint('Upload_Files ${element.field} ${element.filename}');
    });

    request.fields['user_id'] = user_id;
    request.fields['item_code'] = itemCode;
    request.fields['catalog_code'] = catCode;

    debugPrint('UploadImage ${AppConfig.baseUrl + AppConfig.uploadItemImages}');

    // var res = await request.send();

    request.fields.forEach((key, value) {
      debugPrint('Upload_Image Param $key $value');
    });

    http.Response res = await http.Response.fromStream(await request.send());
    Navigator.of(this.context).pop();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data['error'] == 'false') {
        debugPrint('UploadImage Response Ready to fire');
        _future = getdetailsoforders(
            widget.userid, widget.companycode, widget.search_user_id);
      }
    }

    debugPrint('UploadImage Response ${res.body}');
    debugPrint('UploadImage ${res.statusCode}');
  }
}
