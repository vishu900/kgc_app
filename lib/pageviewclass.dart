import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/company_selection.dart';
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

import 'Commons/Commons.dart';
import 'ViewImages/ImageViewer.dart';
import 'datamodel/content.dart';
import 'imageEditor/ImageEditor.dart';
import 'itemMaster/ViewItemDetail.dart';

/// Sale Order
class PageViewClass extends StatefulWidget {
  final companycode, userid, iconlink, search_user_id;

  const PageViewClass(
      {Key? key,
      this.companycode,
      this.userid,
      this.iconlink,
      this.search_user_id})
      : super(key: key);

  @override
  _PageViewClassState createState() => _PageViewClassState();
}

class _PageViewClassState extends State<PageViewClass> {
  TextEditingController? contactpersoncontroller;
  TextEditingController? approvedbyperson;
  List<Content>? orderdetails;
  var orderdetail;
  String? code, name;
  String companyorders = "${AppConfig.baseUrl}api/orders";
  String newapi = "${AppConfig.baseUrl}api/orders_new";
  bool? isLoading, total;
  Future<NewOrder?>? _future;
  File? _image;
  final picker = ImagePicker();
  bool? hasApprovePerm = AppConfig.prefs.getBool(Permissions.SaleOrderApprove);

//  int index2;
  int? listitems, listorders = null;
  var jsonResponse;
  double? height;
  double? width;
  int _current = 0;
  String? _imageBaseUrl = '';

//  ScrollController _scrollController;
  void initState() {
    super.initState();
    print("details received");
    print(widget.companycode);
    print(widget.userid);
    print(widget.iconlink);
    print(widget.search_user_id);

    _future = getdetailsoforders(
        widget.userid, widget.companycode, widget.search_user_id);
    contactpersoncontroller = new TextEditingController();
    approvedbyperson = new TextEditingController();
  }

  String approvalapiurl = "${AppConfig.baseUrl}api/order_update";

  approvalbutton(
      String orderid, String userid, int index1, int index12) async {}

  int number = 1;

  Future<NewOrder?> getdetailsoforders(
      String? userid, String? companycode, String? search_user_id) async {
    if (search_user_id != null) {
      Map data = {
        'user_id': userid,
        'company_code': companycode,
        'search_user_id': search_user_id
      };

      debugPrint('Data=> $data');

      var response = await http.post(Uri.parse(newapi), body: data);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');
        debugPrint('JsonResponse $jsonResponse');

        List? list1 = jsonResponse['content'];

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
      }
    } else {
      Map data = {
        'user_id': userid,
        'company_code': companycode,
      };

      var response = await http.post(Uri.parse(newapi), body: data);
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        _imageBaseUrl = getString(jsonResponse, 'image_tiff_path');
        List? list1 = jsonResponse['content'];

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
            builder: (context) => CompanySelection(
                  userid: widget.userid,
                  name: name,
                )));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // final heightSize = SizedBox(height: 25);
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
                  child: Image.network(
                    widget.iconlink,
                    width: 36.0,
                    height: 36.0,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Sale Order Details',
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
                      debugPrint('Snapshot => ${snapshot.data}');
                      return Center(
                          child: Text("Some thing went wrong !",
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
                                var st = snapshot.data!.content;
                                print(st);
                                var firstdata = jsonResponse['content'];
                                //   int index1 = pageViewIndex;
                                print(firstdata[pageViewIndex]['order_no']);
                                var list =
                                    firstdata[pageViewIndex]['order_items'];
                                print("print list");
                                print(list);

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
                                                  'Order Date',
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
                                                        ["order_date"],
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

                                        /// Order Date & Time
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
                                                  'Insert Date Time',
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
                                                        ["order_date_time"],
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
                                              height: 50,
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
                                                  'Party',
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
                                              height: 50,
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
                                                    left: 20, top: 8, right: 4),
                                                child: Text(
                                                  firstdata[pageViewIndex]
                                                      ['party_name'],
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
                                                  'Order No.',
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
                                                      ['order_no'],
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
                                                  'Remarks.',
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

//                                    Row(
//                                      mainAxisAlignment: MainAxisAlignment.center,
//                                      crossAxisAlignment:CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Container(
//
//                                          height: 32,
//                                          width: 180,
//                                          decoration: BoxDecoration(
//                                            color: Colors.white,
//                                            border: Border.all(
//                                              width:0.5,
//                                              color: Color(0xFF766F6F),
//                                            ),
//                                            borderRadius: BorderRadius.circular(10.0),
//                                          ),
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(left: 20,top: 8),
//                                            child: Text('Contact Person', style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),),
//                                          ),
//                                        ),
//                                        Container(
//                                          height: 32,
//                                          width: 180,
//                                          decoration: BoxDecoration(
//                                            color: Colors.white,
//                                            border: Border.all(
//                                              width:0.5,
//                                              color: Color(0xFF766F6F),
//                                            ),
//                                            borderRadius: BorderRadius.circular(10.0),
//                                          ),
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(left: 20, top: 2 , ),
//                                            child: Text(firstdata[index]['cont_person'], style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),),
//                                          ),
////                                  child: TextFormField(
////
////                                      keyboardType: TextInputType.text,
////                                    controller:contactpersoncontroller
////
////
////
////                                  ),
//                                        ),
//
//
//                                      ],),
//                                    Row(
//                                      mainAxisAlignment: MainAxisAlignment.center,
//                                      crossAxisAlignment:CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        Container(
//
//                                          height: 32,
//                                          width: 180,
//                                          decoration: BoxDecoration(
//                                            color: Colors.white,
//                                            border: Border.all(
//                                              width:0.5,
//                                              color: Color(0xFF766F6F),
//                                            ),
//                                            borderRadius: BorderRadius.circular(10.0),
//                                          ),
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(left: 20,top: 8),
//                                            child: Text('Approval By', style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),),
//                                          ),
//                                        ),
//                                        Container(
//                                          height: 32,
//                                          width: 180,
//                                          decoration: BoxDecoration(
//                                            color: Colors.white,
//                                            border: Border.all(
//                                              width:0.5,
//                                              color: Color(0xFF766F6F),
//                                            ),
//                                            borderRadius: BorderRadius.circular(10.0),
//                                          ),
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(left: 20, top: 2,right: 5),
//                                            child: Text(firstdata[index]['approval_user_name'], style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),),
//                                          ),
//                                        ),
//
//                                      ],),
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
                                          print("length of items");

                                          print(list.length);
                                          //     int index2 = index;

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
                                                                _current =
                                                                    imgIndex;

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
                                                                          .SALE_ORDERS)!,
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
                                                                    "item_description"]
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
                                                            'Quantity Uom',
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
                                                            'Net Rate',
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
                                                                ["net_rate"],
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
                                                            'Rate Uom',
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
                                                                ["rate_uom"],
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
                                                            'Amount ',
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
                                                                ["amount"],
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
                                                            'Party Order No.',
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
                                                          child: list[index][
                                                                      "party_order_no"] ==
                                                                  null
                                                              ? Text('N.A')
                                                              : Text(
                                                                  list[index][
                                                                      "party_order_no"],
                                                                  style:
                                                                      TextStyle(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Color(
                                                                        0xFF2e2a2a),
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        12,
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
                                                            'Delivery Date',
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
                                                                ["delv_date"],
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

                                                  /// View Images and Add Images
                                                  Container(
                                                    width: 360,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /// View Item
                                                        Visibility(
                                                          visible: ifHasPermission(
                                                              permType: PermType
                                                                  .SEARCH,
                                                              compCode: widget
                                                                  .companycode,
                                                              permission:
                                                                  Permissions
                                                                      .SALE_ORDERS)!,
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
                                                                          "View",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 16,
                                                                              letterSpacing: 2.17)))),
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
                                                                      .SALE_ORDERS)!,
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
                                                    visible: hasApprovePerm!,
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
                                                                          20),
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
                                                                            list[index]["sod_pk"].toString(),
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

                                                                          /// Count
                                                                          debugPrint(
                                                                              'NotificationCount before ${AppConfig.prefs.getInt('fcmCount')}');

                                                                          if (AppConfig.prefs.getInt('fcmCount')! >
                                                                              0) {
                                                                            AppConfig.prefs.setInt('fcmCount',
                                                                                AppConfig.prefs.getInt('fcmCount')! - 1);
                                                                          }

                                                                          debugPrint(
                                                                              'NotificationCount after ${AppConfig.prefs.getInt('fcmCount')}');

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          //

                                                                          if (list.length ==
                                                                              0) {
                                                                            print("final calling");
                                                                            setState(() {
                                                                              _future = getdetailsoforders(widget.userid, widget.companycode, widget.search_user_id);
//                                                                      print("order lengths");
//
//                                                                      firstdata.removeAt(index);
//                                                                      print(snapshot.data.content.length);
//
//                                                                      print("first data length");
//                                                                      if(firstdata.length == 0){
//
//                                                                        setState(() {
//                                                                          total = true;
//                                                                        });
//                                                                      }
//                                                                      print(firstdata.length);
                                                                              //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                            });
                                                                          } else {
                                                                            print('no calling');
                                                                          }

//                                                                  Map data = {
//                                                                    'user_id': widget.userid,
//                                                                    'company_code':widget.companycode
//
//                                                                  };

//                                                                  var response = await http.post(newapi, body: data);
//                                                                  if(response.statusCode == 200) {
//                                                                    print("called2");
//                                                                    jsonResponse = json.decode(response.body);
//
//
//
//                                                                    var firstdata = jsonResponse['content'];
//                                                                    List list1 = jsonResponse['content'];
//
//                                                                    List list = firstdata[list1.length -1]['order_items'];
//                                                                    print('first data');
//                                                                    print(firstdata);
//
//
//                                                                    print('list data');
//                                                                    print(list);
//
//                                                                    print('list length');
//                                                                    print(list1.length);
//
//                                                                    setState(() {
//                                                                      listorders = list1.length;
//
//                                                                      listitems = list.length;
//                                                                    });
//
//                                                                    print('list length2');
//                                                                    print(list.length);
//
//
//
//
//                                                                    return NewOrder.fromJson(jsonResponse);
//
//
//
//                                                                  }
//                                                                  else {
//                                                                    setState(() {
//                                                                      _isLoading = false;
//                                                                    });
//
//
//                                                                    print('login error');
//                                                                    print(response.body);
//                                                                  }

                                                                          Fluttertoast.showToast(
                                                                              msg: "Order Item has been approved successfully.",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: Colors.red,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);
                                                                          setState(
                                                                              () {
                                                                            //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                          });
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
                              },
                              onPageChanged: (v) {
                                setState(() {
                                  _current = 0;
                                });
                              },
                            );
                    }
                }
              })),
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
      /* ß */

      _uploadImage(_image!.absolute.path, itemCode, catCode);
      setState(() {});
      debugPrint("Image Path is ${pickedFile.path}");
      debugPrint("Image File Path is $_image");
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
