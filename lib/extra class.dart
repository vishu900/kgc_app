//import 'package:dataproject2/orderlisting/orderlisting.dart';
//import 'package:dataproject2/ordermodel/ordercontent.dart';
//import 'package:dataproject2/ordermodel/ordermodel.dart';
//import 'package:flutter/material.dart';
//import 'package:dataproject2/pageviewclass.dart';
//import 'package:flutter/material.dart';
//import 'package:dataproject2/utilities/constants.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:convert';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;
//
//import 'datamodel/companydetail.dart';
//import 'datamodel/content.dart';
//import 'ordermodel/payload.dart';
//class PageViewClass extends StatefulWidget {
//
//  final companycode, userid;
//
//  const PageViewClass({Key key, this.companycode, this.userid}) : super(key: key);
//
//  @override
//  _PageViewClassState createState() => _PageViewClassState();
//}
//
//class _PageViewClassState extends State<PageViewClass> {
//
//  TextEditingController contactpersoncontroller;
//  TextEditingController approvedbyperson;
//  List<Content> orderdetails;
//  var orderdetail;
//  String code, name;
//  String companyorders = "http://103.141.115.18:24976/bkintl/public/api/orders";
//  String newapi = "http://103.141.115.18:24976/bkintl/public/api/orders_new";
//  bool _isLoading;
//  Future<Payload> _future;
//  int index2;
//  var jsonResponse;
////  ScrollController _scrollController;
//  void initState(){
//    super.initState();
//    print("details received");
//    print(widget.companycode);
//    print(widget.userid);
//
//    _future = getdetailsoforders(widget.userid, widget.companycode);
//    contactpersoncontroller = new TextEditingController();
//    approvedbyperson = new TextEditingController();
//
//  }
//
//  Future<Payload> getdetailsoforders(String userid, String companycode) async {
//
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    Map data = {
//      'user_id': userid,
//      'company_code':companycode
////      'password': pass
//    };
//
//
//    // var response2 = await http.get(companyApiURl, body: data);
//    var response = await http.post(newapi, body: data);
//    if(response.statusCode == 200) {
//
//      jsonResponse = json.decode(response.body);
//
//
//
//      return payloadFromJson(response.body);
//
//    }
//    else {
//      setState(() {
//        _isLoading = false;
//      });
//
//
//      print('login error');
//      print(response.body);
//    }
//
//  }
//  @override
//  Widget build(BuildContext context) {
//
//    final heightSize = SizedBox(height:25);
//    return Scaffold(
//        appBar: AppBar(title: Center(child: Text('SALE ORDER DETAILS', style:TextStyle(letterSpacing: 2.17, fontWeight: FontWeight.bold,
//          fontFamily: 'Roboto',
//          fontSize: 20,), )),backgroundColor: Color(0xFFFF0000),),
//
//        body:
//
//        FutureBuilder(
//            future: _future,
//            builder: (context, AsyncSnapshot<Payload> snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                  return Text('none');
//                case ConnectionState.waiting:
//                  return Center(child: CircularProgressIndicator());
//                case ConnectionState.active:
//                  return Text('');
//                case ConnectionState.done:
//                  if (snapshot.hasError) {
//                    return Text(
//                      '${snapshot.error}',
//                      style: TextStyle(color: Colors.red),
//                    );
//                  } else {
////                    return PageView.builder(
////
////    scrollDirection: Axis.horizontal,
////    pageSnapping: true,
////    physics: AlwaysScrollableScrollPhysics(),
////    onPageChanged: (num){
////    print("Current page number is "+num.toString());
////    },
////    itemCount: snapshot.data.content.keys.length,
////    itemBuilder: (BuildContext ctx, int index){
////    String key =
////    snapshot.data.content.keys.elementAt(index);
////
////    var firstdata = jsonResponse['content'];
////
////    int t = snapshot.data.content[key].length;
////    print("printing of total numner ttttt");
////    print(t);
////    String ordernumber = snapshot.data.content[key][index][0]
////        .orderHeader.orderNo;
////
////    var ordernumber1 = snapshot.data.content[key][index];
////    print('printing order number 1');
////    print(ordernumber1);
////
////    var diff = snapshot.data.content[key][index][0].sodPk;
////    var w = snapshot.data.content[key][index][0].sodPk;
////
////    print(snapshot
////        .data.content[key][index][0].sodPk);
////    print('difffff');
////    print(diff);
//////      String OrderNo = result[index].qty;
////    return OrderListing(ordernumber: ordernumber,diff: snapshot
////        .data.content[key][index][0].sodPk,itemcount: t,ordernumber1: ordernumber1,
////    key1: key,
////    );
////    },
////    );
//                    return PageView.builder(
//                        scrollDirection: Axis.horizontal,
//                        itemCount: snapshot.data.content.keys.length,
//
//                        itemBuilder: (context, index) {
//                          String key =
//                          snapshot.data.content.keys.elementAt(index);
//
//                          var firstdata = jsonResponse['content'];
//                          print(firstdata[index]['order_no']);
//
//
//                          return Column(
//                            children: [
//////                              Text(key),
//                              SizedBox(height: 25,),
//                              Column(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment:CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      //order container
//                                      Container(
//
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//
//
//                                          ),
//
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Order Date',
//                                            style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text(firstdata[index]['order_no']),
//                                        ),
//                                      ),
//
//                                    ],),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Container(
//
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Party',
//                                            style: TextStyle(backgroundColor: Colors.white,
//                                              color:Color(0xFF2e2a2a),
//                                              fontFamily: 'Roboto',
//                                              fontSize: 12,
//
//                                            ),),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Vardhman Textiles Ltd',                               style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
//                                        ),
//                                      ),
//
//                                    ],),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Container(
//
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Order No.', style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text(key, style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),
//                                          ),
//                                        ),
//
//                                      )]
//                                    ,),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Container(
//
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Contact Person', style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text(snapshot.data.content[key][index][0]
//                                              .orderHeader.cont_person_code, style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
////                                          child: TextField(
////                                            decoration: InputDecoration(
////                                              border: InputBorder.none,
////                                              //hintText: 'Username',
////                                            ),
////
////                                            textAlign: TextAlign.center,
//////                              controller:contactpersoncontroller,
////                                            keyboardType:TextInputType.text,
////                                            style: TextStyle(backgroundColor: Colors.white,
////                                              color:Color(0xFF2e2a2a),
////                                              fontFamily: 'Roboto',
////                                              fontSize: 12,
////
////                                            ),
//
//                                        ),
////                                  child: TextFormField(
////
////                                      keyboardType: TextInputType.text,
////                                    controller:contactpersoncontroller
////
////
////
////                                  ),
//                                      ),
//
//
//                                    ],),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    crossAxisAlignment:CrossAxisAlignment.center,
//                                    children: <Widget>[
//                                      Container(
//
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text('Approval By', style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 32,
//                                        width: 160,
//                                        decoration: BoxDecoration(
//                                          color: Colors.white,
//                                          border: Border.all(
//                                            width:0.5,
//                                            color: Color(0xFF766F6F),
//                                          ),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        child: Center(
//                                          child: Text(snapshot.data.content[key][index][0]
//                                              .orderHeader.approval_uid, style: TextStyle(backgroundColor: Colors.white,
//                                            color:Color(0xFF2e2a2a),
//                                            fontFamily: 'Roboto',
//                                            fontSize: 12,
//
//                                          ),),
//
////                                          child: TextFormField(
////                                            decoration: InputDecoration(
////                                              border: InputBorder.none,
////                                              //hintText: 'Username',
////                                            ),
////                                            textAlign: TextAlign.center,
////                                            keyboardType: TextInputType.text,
//////                              controller:approvedbyperson,
////                                            style: TextStyle(backgroundColor: Colors.white,
////                                              color:Color(0xFF2e2a2a),
////                                              fontFamily: 'Roboto',
////                                              fontSize: 12,
////
////                                            ),
////
////
////
////                                          ),
//                                        ),
//                                      ),
//
//                                    ],),
//                                ],),
//                              SizedBox(height: 30,),
//                              Expanded(
//
//                                child: ListView.separated(
//                                  separatorBuilder:
//                                      (BuildContext context, int index) {
//                                    return SizedBox(
//                                      height: 16,
//                                    );
//                                  },
//                                  shrinkWrap: true,
//                                  itemCount: snapshot.data.content[key].length,
//                                  itemBuilder: (context, index) {
//
//
//                                    return Column(
//                                      children: [
//
//                                        Column(
//                                          mainAxisAlignment: MainAxisAlignment.center,
//                                          crossAxisAlignment: CrossAxisAlignment.center,
//                                          children: <Widget>[
//
//                                            Container(
//                                              height: 40,
//                                              width: 320,
//                                              decoration: BoxDecoration(
//                                                color: Color(0xFFFF0000),
//                                                border: Border.all(
//                                                  color: Color(0xFFFF0000),
//                                                ),
//                                                borderRadius: BorderRadius.circular(10.0),
//                                              ),
//                                              child: Center(
//                                                child: Text('ITEM DETAILS - ' + "1/" +(index+1).toString(),
//                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                                                    fontFamily: 'Roboto',
//                                                    fontSize: 20,
//
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              // crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text("Catalog Item",   style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].party_item_name,   style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),
//                                                    ),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('QTY.',   style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].qty, style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Quantity Uom', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].qty_uom,  style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ), ),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Net Rate',   style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].net_rate, style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Rate Uom', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].rate_uom,style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),
//                                                    ),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Amount ', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('10', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Party Order No.', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: snapshot
//                                                        .data.content[key][index][0].party_order_no == null?Text(''):Text(snapshot
//                                                        .data.content[key][index][0].party_order_no,
//                                                      style: TextStyle(backgroundColor: Colors.white,
//                                                        color:Color(0xFF2e2a2a),
//                                                        fontFamily: 'Roboto',
//                                                        fontSize: 12,
//
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              crossAxisAlignment:CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Container(
//
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text('Delivery Date', style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  height: 32,
//                                                  width: 160,
//                                                  decoration: BoxDecoration(
//                                                    color: Colors.white,
//                                                    border: Border.all(
//                                                      width:0.5,
//                                                      color: Color(0xFF766F6F),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(
//                                                    child: Text(snapshot
//                                                        .data.content[key][index][0].delv_date, style: TextStyle(backgroundColor: Colors.white,
//                                                      color:Color(0xFF2e2a2a),
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 12,
//
//                                                    ),),
//                                                  ),
//                                                ),
//
//                                              ],),
//                                            GestureDetector(
//                                              onTap:  () {
//
//
//                                                String sodpk = snapshot
//                                                    .data.content[key][index][0].sodPk;
//
//                                                Fluttertoast.showToast(msg: "item id" + snapshot
//                                                    .data.content[key][index][0].sodPk,
//                                                    toastLength: Toast.LENGTH_SHORT,
//                                                    gravity: ToastGravity.CENTER,
//                                                    timeInSecForIosWeb: 1,
//                                                    backgroundColor: Colors.red,
//                                                    textColor: Colors.white,
//                                                    fontSize: 16.0);
//
////                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
//                                              },
//                                              child:  Container(
//                                                  width:320,
//                                                  height:40,
//                                                  decoration: BoxDecoration(
//                                                    color: Color(0xFFFF0000),
//                                                    border: Border.all(
//                                                      color: Color(0xFFFF0000),
//                                                    ),
//                                                    borderRadius: BorderRadius.circular(10.0),
//                                                  ),
//                                                  child: Center(child: Text("APPROVE",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                                                      fontFamily: 'Roboto',
//                                                      fontSize: 20,
//                                                      letterSpacing: 2.17
//
//                                                  )))),
//                                            ),
//
//
//
//
//                                          ],
//                                        ),
////                                      Text(snapshot
////                                          .data.content[key][index][0].sodPk),
////                                      Text(snapshot
////                                          .data.content[key][index][0].sqdFk),
////                                      Text(snapshot.data.content[key][index][0]
////                                          .orderHeader.sohPk),
//                                      ],
//                                    );
//                                  },
//                                ),
//                              )
//                            ],
//                          );
//                        });
//                  }
//              }
//            })
//    );
////      body:  PageView.builder(
////
////    scrollDirection: Axis.horizontal,
////        pageSnapping: true,
////        physics: AlwaysScrollableScrollPhysics(),
////        onPageChanged: (num){
////          print("Current page number is "+num.toString());
////        },
////        itemCount: orderdetail.content.length,
////        itemBuilder: (BuildContext ctx, int index){
////          var firstdata = jsonResponse['content'];
////
////          List<OrderContent> result = jsonResponse["content"].map<OrderContent>((item) => OrderContent.fromJson(item)).toList();
////      String ordernumber = firstdata[index]['order_header']['order_no'];
////
//////      String OrderNo = result[index].qty;
////;      return OrderListing();
////        },
////  )
//
////
////    }}}
////
////    ));
//  }
//}
//
//
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  Future<Payload> _future;
//
//  Future<Payload> getData() async {
//    String jsonString = '''
//    {
//    "error": "false",
//    "content": {
//        "16": [
//            [
//                {
//                    "sod_pk": "31688",
//                    "soh_fk": "23660",
//                    "sqd_fk": "33294",
//                    "order_header": {
//                        "soh_pk": "23660",
//                        "order_no": "16"
//                    }
//                }
//            ],
//            [
//                {
//                    "sod_pk": "31689",
//                    "soh_fk": "23660",
//                    "sqd_fk": "33293",
//                    "order_header": {
//                        "soh_pk": "23660",
//                        "order_no": "16"
//                    }
//                }
//            ]
//        ],
//        "18": [
//            [
//                {
//                    "sod_pk": "31744",
//                    "soh_fk": "23702",
//                    "sqd_fk": "33354",
//                    "order_header": {
//                        "soh_pk": "23702",
//                        "order_no": "18"
//                    }
//                }
//            ],
//            [
//                {
//                    "sod_pk": "31745",
//                    "soh_fk": "23702",
//                    "sqd_fk": "33356",
//                    "order_header": {
//                        "soh_pk": "23702",
//                        "order_no": "18"
//                    }
//                }
//            ]
//
//        ]
//    }
//}
//    ''';
//
//    http.Response response = http.Response(jsonString, 200);
//    if (response.statusCode == 200) {
//      return payloadFromJson(response.body);
//    }
//  }
//
//  @override
//  void initState() {
//    _future = getData();
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text(widget.title),
//        ),
//        body:
//        FutureBuilder(
//            future: _future,
//            builder: (context, AsyncSnapshot<Payload> snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                  return Text('none');
//                case ConnectionState.waiting:
//                  return Center(child: CircularProgressIndicator());
//                case ConnectionState.active:
//                  return Text('');
//                case ConnectionState.done:
//                  if (snapshot.hasError) {
//                    return Text(
//                      '${snapshot.error}',
//                      style: TextStyle(color: Colors.red),
//                    );
//                  } else {
//                    return ListView.separated(
//                        separatorBuilder: (BuildContext context, int index) {
//                          return SizedBox(
//                            height: 30,
//                          );
//                        },
//                        itemCount: snapshot.data.content.keys.length,
//                        itemBuilder: (context, index) {
//                          String key =
//                          snapshot.data.content.keys.elementAt(index);
//
//                          return Column(
//                            children: [
//                              Text(key),
//                              ListView.separated(
//                                separatorBuilder:
//                                    (BuildContext context, int index) {
//                                  return SizedBox(
//                                    height: 10,
//                                  );
//                                },
//                                shrinkWrap: true,
//                                itemCount: snapshot.data.content[key].length,
//                                itemBuilder: (context, index) {
//                                  return Column(
//                                    children: [
//                                      Text(snapshot
//                                          .data.content[key][index][0].sodPk),
//                                      Text(snapshot
//                                          .data.content[key][index][0].sqdFk),
//                                      Text(snapshot.data.content[key][index][0]
//                                          .orderHeader.sohPk),
//                                    ],
//                                  );
//                                },
//                              )
//                            ],
//                          );
//                        });
//                  }
//              }
//            }));
//  }
//}