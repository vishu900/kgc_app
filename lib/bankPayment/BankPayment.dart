import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:dataproject2/newmodel/neworder.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'BankPaymentCompanySelection.dart';

class BankPayment extends StatefulWidget {
  final companycode,
      userid,
      iconlink,
      search_user_id,
      type,
      alertType,
      orderId,
      orderType;

  const BankPayment({
    Key? key,
    this.companycode,
    this.userid,
    this.iconlink,
    this.search_user_id,
    this.orderId,
    this.alertType,
    required this.type,
    this.orderType,
  }) : super(key: key);

  @override
  _BankPaymentState createState() => _BankPaymentState();
}

enum PaymentSelection { payment, receipt }

class _BankPaymentState extends State<BankPayment> {
  TextEditingController? contactpersoncontroller;
  TextEditingController? approvedbyperson;
  List<Content>? orderdetails;
  var orderdetail;
  String? code, name;

  String newapi = "${AppConfig.baseUrl}api/bank_payment_lists";
  String alertDetails = "${AppConfig.baseUrl}api/order_details";

  bool? isLoading, total;
  Future<NewOrder?>? _future;

  int? ex2;
  int? listitems, listorders = null;
  var jsonResponse;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

//  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+$)');
  Function mathFunc = (Match match) => '${match[1]},';
  PaymentSelection? _character = PaymentSelection.payment;
  int _current = 0;

  void initState() {
    super.initState();
    _character = widget.type;

    _future =
        getPayments(widget.userid, widget.companycode, widget.search_user_id);
    contactpersoncontroller = new TextEditingController();
    approvedbyperson = new TextEditingController();
  }

  String approvalapiurl = "${AppConfig.baseUrl}api/bank_payment_order_update";

  approvalbutton(String orderid, String userid, int index1, int index12) async {
    print("index1");
    print(index1);
    print("index2");
    print(index12);
  }

  int number = 1;

  Future<NewOrder?> getPayments(
      String? userid, String? companycode, String? search_user_id) async {
    if (search_user_id != null) {
      Map data;

      if (widget.alertType == null) {
        print('Not Null');
        data = {
          'user_id': userid,
          'company_code': companycode,
          'search_user_id': search_user_id,
          'type': _character == PaymentSelection.payment ? 'P' : 'R'
        };
      } else {
        print('Not Null');

        data = {
          'user_id': userid,
          'company_code': companycode,
          'order_type': widget.orderType,
          'order_id': widget.orderId,
        };
      }

      print("ApiUrl ==> $newapi");
      print("Params ==> $data");

      var response = await http.post(
          Uri.parse(widget.alertType == null ? newapi : alertDetails),
          body: data);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        print("jsonResponse $jsonResponse");

        List list1 = jsonResponse['content'];

        print('first data');
        print(list1.length);

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

      if (widget.alertType == null) {
        print('Not Null');
        data = {
          'user_id': userid,
          'company_code': companycode,
          'type': _character == PaymentSelection.payment ? 'P' : 'R'
        };
      } else {
        print('Not Null');

        data = {
          'user_id': userid,
          'company_code': companycode,
          'order_type': widget.orderType,
          'order_id': widget.orderId,
        };
      }

      print("ApiUrl ==> $newapi");
      print("Params ==> $data");

      var response = await http.post(
          Uri.parse(widget.alertType == null ? newapi : alertDetails),
          body: data);

      if (response.statusCode == 200) {
        print("called2");
        jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");
        List list1 = jsonResponse['content'];

        print('first data');
        print(list1.length);

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

        print('list length2');

        return NewOrder.fromJson(jsonResponse);
      } else {
        setState(() {
          isLoading = false;
        });

        print('login error');
        print(response.body);
      }
    }
    return null;
  }

  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BankPaymentCompanySelection(
                  userId: widget.userid,
                  name: name,
                )));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 32.0,
                    height: 32.0,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  _character == PaymentSelection.payment
                      ? 'Bank Payment'
                      : 'Bank Receipt',
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
                        child: Text("No bank payments available!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)));
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text("Something went wrong!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)));
                    } else {
                      return listorders == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),

                                /// Radio Selection
                                Visibility(
                                  visible: widget.type == null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      /// Payment
                                      Row(
                                        children: [
                                          Radio(
                                              value: PaymentSelection.payment,
                                              groupValue: _character,
                                              onChanged:
                                                  (PaymentSelection? value) {
                                                setState(() {
                                                  _character = value;
                                                  _future = getPayments(
                                                      widget.userid,
                                                      widget.companycode,
                                                      widget.search_user_id);
                                                });
                                              }),
                                          Text('Payment')
                                        ],
                                      ),

                                      /// Receipt
                                      Row(
                                        children: [
                                          Radio(
                                              value: PaymentSelection.receipt,
                                              groupValue: _character,
                                              onChanged:
                                                  (PaymentSelection? value) {
                                                setState(() {
                                                  _character = value;
                                                  _future = getPayments(
                                                      widget.userid,
                                                      widget.companycode,
                                                      widget.search_user_id);
                                                });
                                              }),
                                          Text('Receipt')
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),
                                Center(
                                    child: Text("No bank payments available!")),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),

                                /// Carousel Indicator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      (snapshot.data!.content!).map((item) {
                                    int mIndex =
                                        (snapshot.data!.content!).indexOf(item);
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

                                Expanded(
                                  child: Container(
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.content!.length,
                                      itemBuilder: (context, index) {
                                        var firstdata = jsonResponse['content'];

                                        print(firstdata[index]['order_no']);
                                        var list =
                                            firstdata[index]['order_items'];
                                        print("print list");
                                        print(list);

                                        return SingleChildScrollView(
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    /// Radio Selection
                                                    Visibility(
                                                      visible:
                                                          widget.type == null,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          /// Payment
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                  value: PaymentSelection
                                                                      .payment,
                                                                  groupValue:
                                                                      _character,
                                                                  onChanged:
                                                                      (PaymentSelection?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _character =
                                                                          value;
                                                                      _future = getPayments(
                                                                          widget
                                                                              .userid,
                                                                          widget
                                                                              .companycode,
                                                                          widget
                                                                              .search_user_id);
                                                                    });
                                                                  }),
                                                              Text('Payment')
                                                            ],
                                                          ),

                                                          /// Receipt
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                  value: PaymentSelection
                                                                      .receipt,
                                                                  groupValue:
                                                                      _character,
                                                                  onChanged:
                                                                      (PaymentSelection?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _character =
                                                                          value;
                                                                      _future = getPayments(
                                                                          widget
                                                                              .userid,
                                                                          widget
                                                                              .companycode,
                                                                          widget
                                                                              .search_user_id);
                                                                    });
                                                                  }),
                                                              Text('Receipt')
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    /// Company Name
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
                                                              'Company Name',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                              firstdata[index]
                                                                  ['comp_name'],
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                color: Color(
                                                                    0xFF2e2a2a),
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),

                                                    /// Document Date
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Document Date',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "doc_date"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Document No.
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Document No.',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    ["doc_no"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Bank Name
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Bank Name',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "bank_name"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Account Name
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Account Name',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                    right: 10,
                                                                    top: 8),
                                                            child: Text(
                                                                firstdata[index]
                                                                    [
                                                                    "acc_name"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Type
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Payment Type',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "payment_type"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Mode
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Payment Mode',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "payment_mode"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Doc Number
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Pay Doc Number',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "pay_doc_number"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Doc Date
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Pay Doc Date',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "pay_doc_date"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: AppColor
                                                                      .appRed,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Amount
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Payment Amount',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                    right: 8,
                                                                    top: 8),
                                                            child: Text(
                                                                firstdata[index]
                                                                        [
                                                                        "pay_amount"]
                                                                    ['amount'],
                                                                //'${NumberFormat.currency(locale: 'en_US', name: '').format(firstdata[index]["pay_amount"]['amount'])}',
                                                                //   '${firstdata[index]["pay_amount"]['amount'].toString().replaceAllMapped(reg, mathFunc)}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 14,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Payment Amount In Words
                                                    IntrinsicHeight(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          //order container
                                                          Container(
                                                            width: 180,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  Border.all(
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
                                                                'Payment Amount In Words',
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
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
                                                            //   height: 60,
                                                            width: 180,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  Border.all(
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
                                                                      right: 8,
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                              child: Text(
                                                                  '${firstdata[index]["pay_amount"]['amount_in_words'].toString().trim()} Only',
                                                                  // ["pay_amount"].toString().replaceAllMapped(reg, mathFunc),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                            .green[
                                                                        900],
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        14,
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    /// On Acc Amount
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'On Account Amount',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                        [
                                                                        "on_acc_amount"]
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 14,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Against Bill Amount
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Against Bill Amount',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                        [
                                                                        "ag_bill_amount"]
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 14,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Ledger Balance
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Ledger Balance',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                _getDebitCreditAmount(
                                                                    firstdata[index]
                                                                            [
                                                                            "acc_ledger_bal"]
                                                                        .toString()),
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 14,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Account Ledger Due Balance
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
                                                        Container(
                                                          height: 50,
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
                                                              'Due Balance',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                          height: 50,
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
                                                                _getDebitCreditAmount(firstdata[index]
                                                                            [
                                                                            "acc_due_bal"] ==
                                                                        null
                                                                    ? '0'
                                                                    : firstdata[index]
                                                                            [
                                                                            "acc_due_bal"]
                                                                        .toString()),
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 14,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    /// Created By
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        //order container
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
                                                              'Created By',
                                                              style: TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                    [
                                                                    "insert_user_name"],
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
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
                                                        //order container
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
                                                                    Colors
                                                                        .white,
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
                                                                firstdata[index]
                                                                        [
                                                                        "remarks"]
                                                                    .toString()
                                                                    .handleEmpty(),
                                                                style:
                                                                    TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Color(
                                                                      0xFF2e2a2a),
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12,
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 20,
                                                    ),

                                                    /// Approve
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (firstdata[index]
                                                                ["acc_name"] !=
                                                            null) {
                                                          if (firstdata[index]
                                                                  ["acc_name"]
                                                              .toString()
                                                              .trim()
                                                              .toLowerCase()
                                                              .contains(
                                                                  'bank interest')) {
                                                            _approveRestricted(
                                                                firstdata,
                                                                index);
                                                          } else {
                                                            _approvePayment(
                                                                firstdata,
                                                                index);
                                                          }
                                                        } else {
                                                          _approvePayment(
                                                              firstdata, index);
                                                        }
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
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: List.generate(
                                                        list.length,
                                                        (index) => list[index][
                                                                    "pur_bill_hdr_pk"] !=
                                                                '0'
                                                            ?

                                                            /// Payment
                                                            Column(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            360,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFFF0000),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0xFFFF0000),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'ITEM DETAILS - ' +
                                                                                (index + 1).toString() +
                                                                                "/" +
                                                                                list.length.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      /// Document No.
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill No.",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['pur_detail'] != null ? list[index]['pur_detail']["doc_no"] : 'N/A',
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

                                                                      /// doc_date
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill Date",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['pur_detail'] != null ? list[index]['pur_detail']["doc_date"] : 'N/A',
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

                                                                      /// net_amount
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill Amount",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['pur_detail'] != null ? list[index]['pur_detail']["net_amount"] : 'N/A',
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

                                                                      /// Amount
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Amount",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]["amount"],
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
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 14,
                                                                  ),
                                                                ],
                                                              )
                                                            :

                                                            /// Receipt
                                                            Column(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            360,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFFFF0000),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Color(0xFFFF0000),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'ITEM DETAILS - ' +
                                                                                (index + 1).toString() +
                                                                                "/" +
                                                                                list.length.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      /// bill_no
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill No",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['bill_detail']["bill_no"],
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

                                                                      /// bill_date
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill Date",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['bill_detail']["bill_date"],
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

                                                                      /// net_amount
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Bill Amount",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]['bill_detail']["net_amount"],
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

                                                                      /// Amount
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        // crossAxisAlignment:CrossAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 4),
                                                                              child: Text(
                                                                                "Amount",
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
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                180,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(
                                                                                width: 0.5,
                                                                                color: Color(0xFF766F6F),
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 20, top: 8, right: 5),
                                                                              child: Text(
                                                                                list[index]["amount"],
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
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      onPageChanged: (pos) {
                                        _current = pos;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }
                }
              })),
    );
  }

  String _getDebitCreditAmount(String amount) {
    String val = amount; //.replaceAllMapped(reg, mathFunc);

    if (val.trim().startsWith('-')) {
      return '$val (cr)';
    } else {
      return '$val (dr)';
    }
  }

  _approveRestricted(dynamic firstdata, int index) {
    /// Only Balwinder Singh Can approve Bank Interest Payment.
    if (getUserId() == 'BALWINDER') {
      showAlert(context, 'Have you confirmed the Bank Interest from statement.',
          'Confirmation',
          ok: 'Yes, Approve', notOk: 'No', onOk: () {
        _approvePayment(firstdata, index);
      }, onNo: () {
        popIt(context);
      }, okColor: Colors.green);
    } else {
      showAlert(
          context, 'You are not authorised to approve Bank Interest.', 'Oops');
    }
  }

  _approvePayment(dynamic firstdata, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'APPROVE ALERT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are You Sure You Want To Approve this payment?'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('No',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red)),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
              ElevatedButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green),
                ),
                onPressed: () async {
                  Map data = {
                    'order_item_id': firstdata[index]["code_pk"].toString(),
                    'user_id': widget.userid.toString()
                  };

                  var jsonResponse;

                  var response =
                      await http.post(Uri.parse(approvalapiurl), body: data);

                  if (response.statusCode == 200) {
                    jsonResponse = json.decode(response.body);
                    String? errorcheck = jsonResponse['error'];

                    if (errorcheck == "false") {
                      firstdata.removeAt(index);
                      Navigator.of(context).pop();

                      if (AppConfig.prefs.getInt('fcmCount')! > 0) {
                        AppConfig.prefs.setInt('fcmCount',
                            AppConfig.prefs.getInt('fcmCount')! - 1);
                      }

                      setState(() {
                        _future = getPayments(widget.userid, widget.companycode,
                            widget.search_user_id);
                      });

                      Fluttertoast.showToast(
                          msg: "Order Item has been approved successfully.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      setState(() {});
                    } else {
                      Navigator.of(context).pop();
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
  }
}
