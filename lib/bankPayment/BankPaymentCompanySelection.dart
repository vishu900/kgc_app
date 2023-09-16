import 'dart:convert';

import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/datamodel/companydetail.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

import 'BankPayment.dart';

const companyApiURl = "${AppConfig.baseUrl}api/company";
//enum PaymentSelection { payment, receipt }

class BankPaymentCompanySelection extends StatefulWidget {
  final CompanyList;
  final userId, name;

  const BankPaymentCompanySelection(
      {Key? key, this.CompanyList, this.userId, this.name})
      : super(key: key);

  @override
  _BankPaymentCompanySelectionState createState() =>
      _BankPaymentCompanySelectionState();
}

class _BankPaymentCompanySelectionState
    extends State<BankPaymentCompanySelection> {
  dynamic jsonResponse = null;
  List<Content>? companydetails;
  late var companyDetail;
  String? name;
  String? code;

  bool? isLoading;
  String companyApiURl = "${AppConfig.baseUrl}api/bank_payment_company";

  PaymentSelection? _character = PaymentSelection.payment;

  void initState() {
    super.initState();
    print('userId ${widget.userId}');

    getCompanies(widget.userId);
  }

  getCompanies(String? userId) async {
    print("getCompanies Fired");
    Map data = {
      'user_id': userId,
      'type': _character == PaymentSelection.payment ? 'P' : 'R'
    };

    print('Payment_Params => : $data');

    var response = await http.post(Uri.parse(companyApiURl), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response : $jsonResponse');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String errorcheck = jsonResponse['error'];

      companyDetail = CompanyDetail.fromJson(json.decode(response.body));
      print('names of companies');
      print(companyDetail.content);

      print('names of companies');

      print("errorche " + errorcheck);

      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        // sharedPreferences.setString("token", jsonResponse['token']);
      }

      var contentList = jsonResponse['content'] as List;

      if (contentList.isEmpty && _character == PaymentSelection.payment) {
        _character = PaymentSelection.receipt;
        getCompanies(userId);
      }

      if (errorcheck == "false") {
        // print()
        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Dashboard()), (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(msg: "Wrong User Credentials!");
      }

      print('sign in successful');
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  userid: widget.userId,
                  name: widget.name,
                )));
    return Future.value(false);
  }

  String? companyName;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        /// App Bar
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Select Company',
          ),
          backgroundColor: Color(0xFFFF0000),
        ),

        /// Main Body
        body: Container(
            constraints: BoxConstraints.expand(),
            child: _getWidgets(jsonResponse)
            /* */

            ),
      ),
    );
  }

  _getWidgets(jsonResponse) {
    if (jsonResponse == null) {
      return Center(
        child: Text('LOADING'),
      );
    } else {
      var dataList = jsonResponse['content'] as List;

      if (dataList.isNotEmpty) {
        return Column(
          children: [
            /// Radio Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Payment
                Row(
                  children: [
                    Radio(
                        value: PaymentSelection.payment,
                        groupValue: _character,
                        onChanged: (PaymentSelection? value) {
                          setState(() {
                            _character = value;
                            jsonResponse = null;
                            getCompanies(widget.userId);
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
                        onChanged: (PaymentSelection? value) {
                          setState(() {
                            _character = value;
                            jsonResponse = null;
                            getCompanies(widget.userId);
                          });
                        }),
                    Text('Receipt')
                  ],
                )
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: companyDetail.content.length,
                itemBuilder: (BuildContext ctx, int index) {
                  var firstdata = jsonResponse['content'];

                  code = firstdata[index]['code'];
                  name = firstdata[index]['name'];
                  List? list2 = firstdata[index]['user_lists'];

                  companyDetail.content;

                  return firstdata[index]['user_lists'] != null
                      ? ExpansionTileCard(
                          ///
                          leading: GestureDetector(
                            onTap: () {
                              var firstdata = jsonResponse['content'];

                              code = firstdata[index]['code'];
                              name = firstdata[index]['name'];

                              debugPrint('Select Company logo $firstdata');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BankPayment(
                                            companycode: firstdata[index]
                                                ['code'],
                                            userid: widget.userId,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    firstdata[index]
                                                        ['logo_name'],
                                            type: _character,
                                          )));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                jsonResponse['full_image'] +
                                    firstdata[index]['logo_name'],
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                          ),

                          /// Company Title
                          title: GestureDetector(
                            onTap: () {
                              var firstdata = jsonResponse['content'];

                              code = firstdata[index]['code'];
                              name = firstdata[index]['name'];

                              debugPrint('Select Company title $firstdata');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BankPayment(
                                            companycode: code,
                                            userid: widget.userId,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    firstdata[index]
                                                        ['logo_name'],
                                            type: _character,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(firstdata[index]['name'] ??
                                      'NULL PASSED'),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                      "(${firstdata[index]['inder_order_count'].toString()})")
                                ],
                              ),
                            ),
                          ),
                          children: <Widget>[
                            Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),

                            /// User List
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: list2!.length,
                                      itemBuilder:
                                          (BuildContext ctx, int index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 60),
                                          child: GestureDetector(
                                            onTap: () {
                                              var firstdata =
                                                  jsonResponse['content'];
                                              debugPrint(
                                                  'Select Company $index  data => $firstdata');

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BankPayment(
                                                            companycode: list2[
                                                                    index][
                                                                'company_code'],
                                                            userid:
                                                                widget.userId,
                                                            iconlink: jsonResponse[
                                                                    'full_image'] +
                                                                list2[index][
                                                                    'logo_name'],
                                                            search_user_id:
                                                                list2[index]
                                                                    ['user_id'],
                                                            type: _character,
                                                          )));
                                            },
                                            child: ListTile(
                                              title: Text(list2[index]['name']),
                                              trailing: Text(list2[index]
                                                      ['count']
                                                  .toString()),
                                            ),
                                          ),
                                        );
                                      })),
                            ),
                          ],
                        )
                      : ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              var firstdata = jsonResponse['content'];

                              code = firstdata[index]['code'];
                              name = firstdata[index]['name'];
                              debugPrint('Select Company $firstdata');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BankPayment(
                                            companycode: firstdata[index]
                                                ['code'],
                                            userid: widget.userId,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    firstdata[index]
                                                        ['logo_name'],
                                            type: _character,
                                          )));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                jsonResponse['full_image'] +
                                    firstdata[index]['logo_name'],
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              var firstdata = jsonResponse['content'];

                              code = firstdata[index]['code'];
                              name = firstdata[index]['name'];
                              debugPrint('Select Company $firstdata');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BankPayment(
                                            companycode: code,
                                            userid: widget.userId,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    firstdata[index]
                                                        ['logo_name'],
                                            type: _character,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(firstdata[index]['name'] ??
                                      'NULL PASSED'),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                      "(${firstdata[index]['order_count'].toString()})")
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),

            /// Radio Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Payment
                Row(
                  children: [
                    Radio(
                        value: PaymentSelection.payment,
                        groupValue: _character,
                        onChanged: (PaymentSelection? value) {
                          setState(() {
                            _character = value;
                            jsonResponse = null;
                            getCompanies(widget.userId);
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
                        onChanged: (PaymentSelection? value) {
                          setState(() {
                            _character = value;
                            jsonResponse = null;
                            getCompanies(widget.userId);
                          });
                        }),
                    Text('Receipt')
                  ],
                )
              ],
            ),

            SizedBox(
              height: 30,
            ),
            Center(child: Text("No payments available!")),
          ],
        );
      }
    }
  }
}
