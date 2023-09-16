import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/bommodel/bom_order_model.dart';
import 'package:dataproject2/bomscreen/process_items_screen.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/notifications/notificationslist.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSaleBomScreen extends StatefulWidget {
  final order_id, order_type, user_id, company_code, iconlink;

  const NotificationSaleBomScreen({
    Key? key,
    this.order_id,
    this.order_type,
    this.user_id,
    this.company_code,
    this.iconlink,
  }) : super(key: key);

  @override
  _NotificationSaleBomScreenState createState() =>
      _NotificationSaleBomScreenState();
}

class _NotificationSaleBomScreenState extends State<NotificationSaleBomScreen> {
  String bomOrderApiUrl = "${AppConfig.baseUrl}api/order_details";
  String approvalapiurl = "${AppConfig.baseUrl}api/bom_order_update";

  var jsonResponse;
  Future<BomOrderModel?>? _future;
  int? listitems, listorders;

  List? list1;
  List? list;

  bool checkOrdertype = true;
  var firstdata;

  bool? isLoading;
  File? _image;
  final picker = ImagePicker();

  void initState() {
    super.initState();

    print("company credentials notification_sbom");

    print(widget.company_code);
    print(widget.user_id);
    print(widget.order_id);
    print(widget.order_type);

    _future = getdetailsoforders(widget.user_id, widget.company_code,
        widget.order_type, widget.order_id);
  }

  Future<bool> _onBackPressed() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    /*    var user_id = prefs.getString('user_id');
    var name = prefs.getString('name'); */
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationsList()));
    return Future.value(false);
  }

  Future<BomOrderModel?> getdetailsoforders(String? userid, String? companycode,
      String? ordertype, String? OrderId) async {
    Map data = {
      'user_id': userid,
      'company_code': companycode,
      'order_type': ordertype,
      'order_id': OrderId
    };

    print("notification_sbom $data");

    var response = await http.post(Uri.parse(bomOrderApiUrl), body: data);

    if (response.statusCode == 200) {
      print("bom screen7");
      jsonResponse = json.decode(response.body);

      print(jsonResponse);

      firstdata = jsonResponse['content'];
      list1 = jsonResponse['content'];

      list = firstdata[list1!.length - 1]['order_items'];

      print("bom screen5");
      print(firstdata);

      print("bom screen4");
      print(list);

      print("bom screen2");
      print(list1);

      setState(() {
        listorders = list1!.length;

        listitems = list!.length;
      });

      print('list length2');
      print(list!.length);

      return BomOrderModel.fromJson(jsonResponse);
    } else {
      setState(() {
        isLoading = false;
      });

      print('login error');
      print(response.body);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final heightSize = SizedBox(height: 25);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
                _onBackPressed();
                //Navigator.pop(context, false);
              },
            ),
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  'SALE ORDER BOM',
                  style: TextStyle(
                    letterSpacing: 2.17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                  ),
                ),
              ],
            )),
            backgroundColor: Color(0xFFFF0000),
          ),
          body: FutureBuilder(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'This Order has either bee   n approved or has been deleted!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            'This Order has either been approved or has been deleted!',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return jsonResponse == null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "This Order has either been approved or has been deleted!"),
                              ),
                            )
                          : PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: firstdata.length,
                              itemBuilder: (context, index) {
//                          String key =
//                          snapshot.data.content.elementAt(index);

                                var st = firstdata.length;
                                print('content st');
                                print(st);
//                              var firstdata = jsonResponse['content'];
//                          int index1 =  int.parse( firstdata[index]);

                                //           int index1 = index;
                                print(firstdata[index]['order_no']);
                                var list = firstdata[index]['order_items'];
//                            var listprocessitems = list[index]['process_items'];
                                print("print list");
//                            print(listprocessitems);
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
                                              height: 40,
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
                                              height: 40,
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
                                                  left: 20,
                                                  top: 8,
                                                ),
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
                                                  'Sale Order No.',
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

                                        /// Remarks.
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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

//                                      Row(
//                                        mainAxisAlignment: MainAxisAlignment.center,
//                                        crossAxisAlignment:CrossAxisAlignment.center,
//                                        children: <Widget>[
//                                          Container(
//
//                                            height: 32,
//                                            width: 185,
//                                            decoration: BoxDecoration(
//                                              color: Colors.white,
//                                              border: Border.all(
//                                                width:0.5,
//                                                color: Color(0xFF766F6F),
//                                              ),
//                                              borderRadius: BorderRadius.circular(10.0),
//                                            ),
//                                            child: Padding(
//                                              padding: const EdgeInsets.only(left: 20,top: 8),
//                                              child: Text('Contact Person', style: TextStyle(backgroundColor: Colors.white,
//                                                color:Color(0xFF2e2a2a),
//                                                fontFamily: 'Roboto',
//                                                fontSize: 12,
//
//                                              ),),
//                                            ),
//                                          ),
//                                          Container(
//                                            height: 32,
//                                            width: 160,
//                                            decoration: BoxDecoration(
//                                              color: Colors.white,
//                                              border: Border.all(
//                                                width:0.5,
//                                                color: Color(0xFF766F6F),
//                                              ),
//                                              borderRadius: BorderRadius.circular(10.0),
//                                            ),
//                                            child: Padding(
//                                              padding: const EdgeInsets.only(left: 20, top: 3 , ),
//                                              child: Text(firstdata[index]['cont_person'], style: TextStyle(backgroundColor: Colors.white,
//                                                color:Color(0xFF2e2a2a),
//                                                fontFamily: 'Roboto',
//                                                fontSize: 12,
//
//                                              ),),
//                                            ),
////                                  child: TextFormField(
////
////                                      keyboardType: TextInputType.text,
////                                    controller:contactpersoncontroller
////
////
////
////                                  ),
//                                          ),
//
//
//                                        ],),
//                                      Row(
//                                        mainAxisAlignment: MainAxisAlignment.center,
//                                        crossAxisAlignment:CrossAxisAlignment.center,
//                                        children: <Widget>[
//                                          Container(
//
//                                            height: 32,
//                                            width: 185,
//                                            decoration: BoxDecoration(
//                                              color: Colors.white,
//                                              border: Border.all(
//                                                width:0.5,
//                                                color: Color(0xFF766F6F),
//                                              ),
//                                              borderRadius: BorderRadius.circular(10.0),
//                                            ),
//                                            child: Padding(
//                                              padding: const EdgeInsets.only(left: 20,top: 8),
//                                              child: Text('Approved By', style: TextStyle(backgroundColor: Colors.white,
//                                                color:Color(0xFF2e2a2a),
//                                                fontFamily: 'Roboto',
//                                                fontSize: 12,
//
//                                              ),),
//                                            ),
//                                          ),
//                                          Container(
//                                            height: 32,
//                                            width: 185,
//                                            decoration: BoxDecoration(
//                                              color: Colors.white,
//                                              border: Border.all(
//                                                width:0.5,
//                                                color: Color(0xFF766F6F),
//                                              ),
//                                              borderRadius: BorderRadius.circular(10.0),
//                                            ),
//                                            child: Padding(
//                                              padding: const EdgeInsets.only(left: 20, top: 8,right: 5),
//                                              child: Text(firstdata[index]['bom_approval_uid'], style: TextStyle(backgroundColor: Colors.white,
//                                                color:Color(0xFF2e2a2a),
//                                                fontFamily: 'Roboto',
//                                                fontSize: 12,
//
//                                              ),),
//                                            ),
//                                          ),
//
//                                        ],),
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
                                          print("length of items");
                                          List list2 =
                                              list[index]["process_items"];
                                          int processTotal = list2.length;
                                          var listvar =
                                              list[index]["order_type"];
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

                                          print(list.length);
                                          //    int index2 = index;

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
                                                    width: 370,
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
                                                        width: 185,
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
                                                        width: 185,
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 96,
                                                        width: 185,
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
                                                                  top: 10),
                                                          child: Text(
                                                            'Catalog Item Name',
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
                                                        width: 185,
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
                                                                  right: 2),
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
                                                        width: 185,
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
                                                            'Party Order Number',
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
                                                        width: 185,
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
                                                                  right: 2),
                                                          child: Text(
                                                            list[index][
                                                                    "party_order_no"]
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
                                                        width: 185,
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
                                                            'Qty.',
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
                                                        width: 185,
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
                                                                ["order_qty"],
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
                                                        width: 185,
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
                                                        width: 185,
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
                                                        width: 185,
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
                                                            'Order Type',
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
                                                        width: 185,
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
                                                            ordertype
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
                                                        width: 185,
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
                                                            'MFG Qty ',
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
                                                        width: 185,
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
                                                                ["mfg_qty"],
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
                                                        width: 185,
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
                                                            'Trading Qty',
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
                                                        width: 185,
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
                                                                      "trd_qty"] ==
                                                                  null
                                                              ? Text('')
                                                              : Text(
                                                                  list[index][
                                                                      "trd_qty"],
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
                                                        width: 185,
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
                                                        width: 185,
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

                                                  /// SO Order Approval UserName
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
                                                        width: 185,
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
                                                            'Sale Order Approved By:',
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
                                                        width: 185,
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
                                                                "so_approved_user_name"],
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

                                                  /// SO Order Approval Date
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
                                                        width: 185,
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
                                                            'Sale Order Approved Date:',
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
                                                        width: 185,
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
                                                                "so_approved_date"],
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

                                                  /// Remarks
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
                                                        width: 185,
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
                                                        width: 185,
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

                                                              /*list[index]["catalog_item"]
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
                                                                              ImageViewer(itemCode: list[index]["catalog_item"]['code'])));
                                                            */
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
                                                                    //View Image(${(list[index]["catalog_item"]['image_count'] as int).toString()})
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

                                                  /// View Process
                                                  processTotal == 0
                                                      ? SizedBox()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProcessItemsScreen(
                                                                              datareceived: list[index]["process_items"],
                                                                              iconlink: widget.iconlink,
                                                                            )));
                                                          },
                                                          child: Container(
                                                              width: 370,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFFFF0000),
                                                                border:
                                                                    Border.all(
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
                                                                      "VIEW PROCESS",
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
                                                  /*
                                                  'order_item_id':  list[index]["sod_pk"].toString(),
                                                  'user_id': widget.user_id.toString(),
                                                  "company_code":widget.company_code.toString()

                                                  */

                                                  /// Approve
                                                  ordertype == "Trading"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'APPROVE ALERT',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
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
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.red)),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
//                                                                avatarImageFile1 =null;
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        },
                                                                      ),
                                                                      ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20,
                                                                              color: Colors.green),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          Map data =
                                                                              {
                                                                            'order_item_id':
                                                                                list[index]["sod_pk"].toString(),
                                                                            'user_id':
                                                                                widget.user_id.toString(),
                                                                            "company_code":
                                                                                widget.company_code.toString()
                                                                          };
                                                                          dynamic
                                                                              jsonResponse =
                                                                              null;

                                                                          var response = await http.post(
                                                                              Uri.parse(approvalapiurl),
                                                                              body: data);
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            jsonResponse =
                                                                                json.decode(response.body);
                                                                            print('Response status: ${response.statusCode}');
                                                                            print('Response body: ${response.body}');
                                                                            String?
                                                                                errorcheck =
                                                                                jsonResponse['error'];

                                                                            if (errorcheck ==
                                                                                "false") {
                                                                              list.removeAt(index);
                                                                              print(index);
                                                                              Navigator.of(context).pop();
                                                                              //
                                                                              if (AppConfig.prefs.getInt('fcmCount')! > 0) {
                                                                                AppConfig.prefs.setInt('fcmCount', AppConfig.prefs.getInt('fcmCount')! - 1);
                                                                              }
                                                                              if (list.length == 0) {
                                                                                print("final calling");
                                                                                setState(() {
                                                                                  _future = getdetailsoforders(widget.user_id, widget.company_code, widget.order_type, widget.order_id);
                                                                                });
                                                                              } else {
                                                                                print('no calling');
                                                                              }

                                                                              Fluttertoast.showToast(msg: "Order Item has been approved successfully.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                              setState(() {
                                                                                //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                              });
                                                                            } else {
                                                                              Navigator.of(context).pop();
                                                                              Fluttertoast.showToast(msg: "Approval Not Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFF006C66),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xFF006C66),
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
                                                        )
                                                      : (checkOrdertype ==
                                                                  false ||
                                                              (checkOrdertype ==
                                                                      true &&
                                                                  (processTotal ==
                                                                      0))
                                                          ? SizedBox()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          'APPROVE ALERT',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              ListBody(
                                                                            children: <Widget>[
                                                                              Text('Are You Sure You Want To Approve this Item?'),
                                                                              //Text('please enter the country?'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          ElevatedButton(
                                                                            child:
                                                                                Text('No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
//                                                                avatarImageFile1 =null;
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                            },
                                                                          ),
                                                                          ElevatedButton(
                                                                            child:
                                                                                Text(
                                                                              'Yes',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
//                                                              getImage1();

                                                                              Map data = {
                                                                                'order_item_id': list[index]["sod_pk"].toString(),
                                                                                'user_id': widget.user_id.toString(),
                                                                                "company_code": widget.company_code.toString()
                                                                              };
                                                                              dynamic jsonResponse = null;

                                                                              var response = await http.post(Uri.parse(approvalapiurl), body: data);
                                                                              if (response.statusCode == 200) {
                                                                                jsonResponse = json.decode(response.body);
                                                                                print('Response status: ${response.statusCode}');
                                                                                print('Response body: ${response.body}');
                                                                                String? errorcheck = jsonResponse['error'];

                                                                                if (errorcheck == "false") {
                                                                                  list.removeAt(index);
                                                                                  print(index);
                                                                                  Navigator.of(context).pop();
                                                                                  //

                                                                                  if (list.length == 0) {
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

                                                                                  Fluttertoast.showToast(msg: "Order Item has been approved successfully.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                                  setState(() {
                                                                                    //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                                  });
                                                                                } else {
                                                                                  Navigator.of(context).pop();
                                                                                  Fluttertoast.showToast(msg: "Approval Not Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
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
                                                                  width: 370,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF006C66),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Color(
                                                                          0xFF006C66),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child: Center(
                                                                      child: Text(
                                                                          "APPROVE",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 20,
                                                                              letterSpacing: 2.17)))),
                                                            )),

                                                  /// Reject
                                                  ordertype == "Trading"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'REJECT ALERT',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
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
                                                                              'Are You Sure You Want To Reject this Item?'),
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
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.red)),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
//                                                                avatarImageFile1 =null;
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        },
                                                                      ),
                                                                      ElevatedButton(
                                                                        child:
                                                                            Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20,
                                                                              color: Colors.green),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          Map data =
                                                                              {
                                                                            'reject_status':
                                                                                '1',
                                                                            'order_item_id':
                                                                                list[index]["sod_pk"].toString(),
                                                                            'user_id':
                                                                                widget.user_id.toString(),
                                                                            "company_code":
                                                                                widget.company_code.toString()
                                                                          };
                                                                          dynamic
                                                                              jsonResponse =
                                                                              null;

                                                                          var response = await http.post(
                                                                              Uri.parse(approvalapiurl),
                                                                              body: data);
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            jsonResponse =
                                                                                json.decode(response.body);
                                                                            print('Response status: ${response.statusCode}');
                                                                            print('Response body: ${response.body}');
                                                                            String?
                                                                                errorcheck =
                                                                                jsonResponse['error'];

                                                                            if (errorcheck ==
                                                                                "false") {
                                                                              list.removeAt(index);
                                                                              print(index);
                                                                              Navigator.of(context).pop();
                                                                              //
                                                                              if (AppConfig.prefs.getInt('fcmCount')! > 0) {
                                                                                AppConfig.prefs.setInt('fcmCount', AppConfig.prefs.getInt('fcmCount')! - 1);
                                                                              }
                                                                              if (list.length == 0) {
                                                                                print("final calling");
                                                                                setState(() {
                                                                                  _future = getdetailsoforders(widget.user_id, widget.company_code, widget.order_type, widget.order_id);
                                                                                });
                                                                              } else {
                                                                                print('no calling');
                                                                              }

                                                                              Fluttertoast.showToast(msg: "Order Item has been Rejected successfully.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                              setState(() {
                                                                                //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                              });
                                                                            } else {
                                                                              Navigator.of(context).pop();
                                                                              Fluttertoast.showToast(msg: "Reject Not Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFF006C66),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xFF006C66),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                      "REJECT",
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
                                                        )
                                                      : (checkOrdertype ==
                                                                  false ||
                                                              (checkOrdertype ==
                                                                      true &&
                                                                  (processTotal ==
                                                                      0))
                                                          ? SizedBox()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          'REJECT ALERT',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              ListBody(
                                                                            children: <Widget>[
                                                                              Text('Are You Sure You Want To Reject this Item?'),
                                                                              //Text('please enter the country?'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          ElevatedButton(
                                                                            child:
                                                                                Text('No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
//                                                                avatarImageFile1 =null;
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                            },
                                                                          ),
                                                                          ElevatedButton(
                                                                            child:
                                                                                Text(
                                                                              'Yes',
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
//                                                              getImage1();

                                                                              Map data = {
                                                                                'reject_status': '1',
                                                                                'order_item_id': list[index]["sod_pk"].toString(),
                                                                                'user_id': widget.user_id.toString(),
                                                                                "company_code": widget.company_code.toString()
                                                                              };
                                                                              dynamic jsonResponse = null;

                                                                              var response = await http.post(Uri.parse(approvalapiurl), body: data);
                                                                              if (response.statusCode == 200) {
                                                                                jsonResponse = json.decode(response.body);
                                                                                print('Response status: ${response.statusCode}');
                                                                                print('Response body: ${response.body}');
                                                                                String? errorcheck = jsonResponse['error'];

                                                                                if (errorcheck == "false") {
                                                                                  list.removeAt(index);
                                                                                  print(index);
                                                                                  Navigator.of(context).pop();
                                                                                  //

                                                                                  if (list.length == 0) {
                                                                                    print("final calling");
                                                                                    setState(() {
                                                                                      _future = getdetailsoforders(widget.user_id, widget.company_code, widget.order_type, widget.order_id);
                                                                                    });
                                                                                  } else {
                                                                                    print('no calling');
                                                                                  }
                                                                                  Fluttertoast.showToast(msg: "Order Item has been Rejected successfully.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                                  setState(() {
                                                                                    //  _future = getdetailsoforders(widget.userid,widget.companycode);
                                                                                  });
                                                                                } else {
                                                                                  Navigator.of(context).pop();
                                                                                  Fluttertoast.showToast(msg: "Reject Not Successful", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
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
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF006C66),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Color(
                                                                          0xFF006C66),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child: Center(
                                                                      child: Text(
                                                                          "REJECT",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 20,
                                                                              letterSpacing: 2.17)))),
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
                              });
                    }
                }
              })),
    );
  }

  void _imageBottomSheet(context, String? itemCode, String? catCode) async {
    var mFile = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageEditor()));

    if (mFile == null) return;
    _image = mFile['file'];

    _uploadImage(_image!.absolute.path, itemCode!, catCode!);
  }

  Future getImage(ImageSource imgSrc, String itemCode, String catCode) async {
    final dir = await getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    final pickedFile = await picker.pickImage(source: imgSrc);

    if (pickedFile != null) {
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
