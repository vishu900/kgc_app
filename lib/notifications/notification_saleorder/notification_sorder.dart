import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Permissions/Permissions.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/newmodel/neworder.dart';
import 'package:dataproject2/notifications/notificationslist.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'datamodel/content.dart';

class NotificationSaleOrder extends StatefulWidget {
  final order_id, order_type, user_id, company_code, iconlink;

  const NotificationSaleOrder({
    Key? key,
    this.order_id,
    this.order_type,
    this.user_id,
    this.company_code,
    this.iconlink,
  }) : super(key: key);

  @override
  _NotificationSaleOrderState createState() => _NotificationSaleOrderState();
}

class _NotificationSaleOrderState extends State<NotificationSaleOrder> {
  TextEditingController? contactpersoncontroller;
  TextEditingController? approvedbyperson;
  List<Content>? orderdetails;
  var orderdetail;
  String? code, name;
  String companyorders = "${AppConfig.baseUrl}api/orders";
  String newapi = "${AppConfig.baseUrl}api/order_details";
  bool? isLoading, total;
  Future<NewOrder?>? _future;
  File? _image;
  final picker = ImagePicker();

  int? listitems, listorders = null;
  var jsonResponse;
  bool? hasApprovePerm = AppConfig.prefs.getBool(Permissions.SaleOrderApprove);

  void initState() {
    super.initState();

    print("details received");
    print(widget.company_code);
    print(widget.user_id);
    print(widget.order_id);
    print(widget.order_type);

    _future = getdetailsoforders(widget.user_id, widget.company_code,
        widget.order_type, widget.order_id);
    contactpersoncontroller = new TextEditingController();
    approvedbyperson = new TextEditingController();
  }

  String approvalapiurl = "${AppConfig.baseUrl}api/order_update";

  approvalbutton(String orderid, String userid, int index1, int index12) async {
    print("index1");
    print(index1);
    print("index2");
    print(index12);
  }

  int number = 1;

  Future<NewOrder?> getdetailsoforders(String? userid, String? companycode,
      String? ordertype, String? OrderId) async {
    Map data = {
      'user_id': userid,
      'company_code': companycode,
      'order_type': ordertype,
      'order_id': OrderId
    };

    debugPrint("Notification_sorder => $data}");

    var response = await http.post(Uri.parse(newapi), body: data);

    if (response.statusCode == 200) {
      print("called2 notificaiton sale oreder");
      jsonResponse = json.decode(response.body);

      print('first data');
      print(jsonResponse);
      List list1 = jsonResponse['content'];

      print('list data');

      print('list length');
      print(list1.length);

      if (list1 == 0) {
        setState(() {
          listorders == null;
        });
      } else {
        setState(() {
          listorders = list1.length;
        });
      }

//        listitems = list.length

      print('list length2');
//      print(list.length);

      return NewOrder.fromJson(jsonResponse);
    } else {
      setState(() {
        isLoading = false;
      });

      print('login error');
      print(response.body);
    }
    return null;
  }

  Future<bool> _onBackPressed() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    /*    var user_id = prefs.getString('user_id');
    var name = prefs.getString('name'); */
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationsList()));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // final heightSize = SizedBox(height: 25);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Center(
                child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
//                      child: Image.asset('images/appstore.png', width: 50, height: 50)
                  child: Image.network(
                    widget.iconlink,
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'SALE ORDER DETAILS',
                  style: TextStyle(
                    letterSpacing: 2.17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                  ),
                )
              ],
            )),
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
                        child: Text(
                            "This Order has either been approved or has been deleted!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)));
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              "This Order has either been approved or has been deleted!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)));
//                    return Text(
//
//                      'errror   +++++++${snapshot.error}',
//                      style: TextStyle(color: Colors.red),
//                    );
                    } else {
                      return listorders == 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Center(
                                child: Text(
                                    "This Order has either been approved or has been deleted!",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    )),
                              ),
                            )
                          : PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.content!.length,
                              itemBuilder: (context, index) {
//                          String key =
//                          snapshot.data.content.elementAt(index);

                                var st = snapshot.data!.content;
                                print('content st');
                                print(st);
                                var firstdata = jsonResponse['content'];
//                          int index1 =  int.parse( firstdata[index]);

                                //        int index1 = index;
                                print(firstdata[index]['order_no']);
                                var list = firstdata[index]['order_items'];
                                print("print list");
                                print(list);

                                return Column(
                                  children: [
////                              Text(key),

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
                                                    firstdata[index]
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
                                                  firstdata[index]
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
                                                  firstdata[index]['order_no'],
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
                                                  firstdata[index]['remarks'] ==
                                                          null
                                                      ? 'N.A'
                                                      : firstdata[index]
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
                                          //   int index2 = index;

                                          return Column(
                                            children: [
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

//                                              Row(
//                                                mainAxisAlignment: MainAxisAlignment.center,
//                                                // crossAxisAlignment:CrossAxisAlignment.center,
//                                                children: <Widget>[
//                                                  Container(
//
//                                                    height: 32,
//                                                    width: 180,
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.white,
//                                                      border: Border.all(
//
//                                                        width:0.5,
//                                                        color: Color(0xFF766F6F),
//                                                      ),
//                                                      borderRadius: BorderRadius.circular(10.0),
//                                                    ),
//                                                    child: Padding(
//                                                      padding: const EdgeInsets.only(left: 20,top: 2, right:4),
//                                                      child: Text("Catalog No.",   style: TextStyle(backgroundColor: Colors.white,
//                                                        color:Color(0xFF2e2a2a),
//                                                        fontFamily: 'Roboto',
//                                                        fontSize: 12,
//
//                                                      ),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  Container(
//                                                    height: 32,
//                                                    width: 180,
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.white,
//                                                      border: Border.all(
//
//                                                        width:0.5,
//                                                        color: Color(0xFF766F6F),
//                                                      ),
//                                                      borderRadius: BorderRadius.circular(10.0),
//                                                    ),
//                                                    child: Padding(
//                                                      padding: const EdgeInsets.only(left: 20,right: 5),
//                                                      child: Text(list[index]["item_description"],   style: TextStyle(backgroundColor: Colors.white,
//                                                        color:Color(0xFF2e2a2a),
//                                                        fontFamily: 'Roboto',
//                                                        fontSize: 12,
//
//                                                      ),
//                                                      ),
//                                                    ),
//                                                  ),
//
//                                                ],),
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
                                                              ? Text('')
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
/*
                                                  /// View Images
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        list[index]["item_code"]['image_count'] == 0
                                                            ? Commons.showToast(
                                                            'No images found.')
                                                            : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ImageViewer(
                                                                        itemCode:
                                                                        list[index]["item_code"]['code'])));
                                                      },
                                                      child: Container(
                                                          width: 360,
                                                          height: 40,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: AppColor
                                                                .appBlue,
                                                            border: Border.all(
                                                              color: AppColor
                                                                  .appBlue,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                  "VIEW IMAGE(${list[index]["item_code"]['image_count']as String})",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      fontFamily:
                                                                      'Roboto',
                                                                      fontSize:
                                                                      20,
                                                                      letterSpacing:
                                                                      2.17)))),
                                                    ),
                                                  ),*/

                                                  /// View Images and Add Images
                                                  Container(
                                                    width: 360,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /// View Images
                                                        Padding(
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

                                                              /* list[index]["catalog_item"]
                                                                          [
                                                                          'image_count'] ==
                                                                      0
                                                                  ? Commons
                                                                      .showToast(
                                                                          'No images found.')
                                                                  : Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ImageViewer(itemCode: list[index]["catalog_item"]['code'])));*/
                                                            },
                                                            child: Container(
                                                                width: 170,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColor
                                                                      .appBlue,
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColor
                                                                        .appBlue,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                child: Center(
                                                                    //View Image(${(list[index]["item_code"]['image_count'] as int).toString()})
                                                                    child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                2.17)))),
                                                          ),
                                                        ),

                                                        /// Add Images
                                                        Padding(
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
                                                                      ['code'],
                                                                  list[index][
                                                                          "catalog_item"]
                                                                      ['code']);
                                                            },
                                                            child: Container(
                                                                width: 170,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColor
                                                                      .appBlue,
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColor
                                                                        .appBlue,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                                            color: Colors
                                                                                .white,
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                2.17)),
                                                                    SizedBox(
                                                                        width:
                                                                            4),
                                                                    Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 24,
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

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
                                                                            .user_id
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
                                                                              _future = getdetailsoforders(widget.user_id, widget.company_code, widget.order_type, widget.order_id);
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
                                                  ),
                                                ],
                                              ),
//                                      Text(snapshot
//                                          .data.content[key][index][0].sodPk),
//                                      Text(snapshot
//                                          .data.content[key][index][0].sqdFk),
//                                      Text(snapshot.data.content[key][index][0]
//                                          .orderHeader.sohPk),
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
//      body:  PageView.builder(
//
//    scrollDirection: Axis.horizontal,
//        pageSnapping: true,
//        physics: AlwaysScrollableScrollPhysics(),
//        onPageChanged: (num){
//          print("Current page number is "+num.toString());
//        },
//        itemCount: orderdetail.content.length,
//        itemBuilder: (BuildContext ctx, int index){
//          var firstdata = jsonResponse['content'];
//
//          List<OrderContent> result = jsonResponse["content"].map<OrderContent>((item) => OrderContent.fromJson(item)).toList();
//      String ordernumber = firstdata[index]['order_header']['order_no'];
//
////      String OrderNo = result[index].qty;
//;      return OrderListing();
//        },
//  )

//
//    }}}
//
//    ));
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
        _future = getdetailsoforders(widget.user_id, widget.company_code,
            widget.order_type, widget.order_id);
      }
    }

    debugPrint('UploadImage Response ${res.body}');
    debugPrint('UploadImage ${res.statusCode}');
  }
}
