//import 'package:dataproject2/newmodel/neworder.dart';
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
//    print("called");
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
//      print("called2");
//      jsonResponse = json.decode(response.body);
//
//
//      print("jsonresponse check");
//
//      //OrderContent content = new OrderContent.fromJson(jsonResponse);
//      // print(content.sohFk);
//      print(jsonResponse);
//      print("jsonresponse check2");
//
//      orderdetail = NewOrder.fromJson(json.decode(response.body));
//      print('new order check');
//      print(orderdetail);
//
//
//
//      // return payloadFromJson(response.body);
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
//   return PageView.builder(
//                        scrollDirection: Axis.horizontal,
//                        itemCount: snapshot.data.content.keys.length,
//
//                        itemBuilder: (context, index) {
//                          String key =
//                          snapshot.data.content.keys.elementAt(index);
//                  return Column(
//                            children: [
//                              SizedBox(height: 25,),
//                              Column(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment:CrossAxisAlignment.center,
//                                children: <Widget>[
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
//                                ],),
//                              SizedBox(height: 30,),
//                              Expanded(
//
//                                child:
//                                ListView.builder(
//
//                                  shrinkWrap: true,
//                                  itemCount: snapshot.data.content[key].length,
//                                  itemBuilder: (context, index) {
//                                   return Column(
//                                      children: [
//
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
//
//  }
//}