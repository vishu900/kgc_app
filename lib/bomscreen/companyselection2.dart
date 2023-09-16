import 'dart:convert';

import 'package:dataproject2/Permissions/Permissions.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/bomscreen/salebomScreen.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/datamodel/companydetail.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'extra class.dart';

const companyApiURl = "${AppConfig.baseUrl}api/company";

class CompanySelection2 extends StatefulWidget {
  final CompanyList;

  final userid, name;

  const CompanySelection2({Key? key, this.CompanyList, this.userid, this.name})
      : super(key: key);

  @override
  _CompanySelection2State createState() => _CompanySelection2State();
}

class _CompanySelection2State extends State<CompanySelection2> {
  dynamic jsonResponse = null;
  List<Content>? companydetails;
  late var companyDetail;
  String? name;
  String? code;

  bool? isLoading;
  String companyApiURl = "${AppConfig.baseUrl}api/bom_company";

  void initState() {
    getcompanies(widget.userid);
    print('Names of Companies-> Sale Order Bom Approval');
    super.initState();
  }

  getcompanies(String userid) async {
    print("user name   " + userid);

    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'user_id': userid, 'tid': Permissions.SO_BOM_APPROVAL};

    var response = await http.post(Uri.parse(companyApiURl), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String? errorcheck = jsonResponse['error'];

      companyDetail = CompanyDetail.fromJson(json.decode(response.body));

      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        // sharedPreferences.setString("token", jsonResponse['token']);
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
                  userid: widget.userid,
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
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Select Company',
          ),
          backgroundColor: Color(0xFFFF0000),
        ),
        body: Container(
          decoration: BoxDecoration(),
          constraints: BoxConstraints.expand(),
          child: jsonResponse == null
              ? Container(
                  child: Center(
                    child: Text('LOADING'),
                  ),
                )
              : ListView.builder(
                  itemCount: companyDetail.content.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    var firstdata = jsonResponse['content'];

                    code = firstdata[index]['code'];
                    name = firstdata[index]['name'];
                    // List list1 = firstdata;
                    List? list2 = firstdata[index]['user_lists'];
                    // print("list length of users");
                    // print(list1.length);

                    companyDetail.content;

                    return firstdata[index]['user_lists'] != null
                        ? ExpansionTileCard(
                            leading: GestureDetector(
                              onTap: () {
                                var firstdata = jsonResponse['content'];

                                code = firstdata[index]['code'];
                                name = firstdata[index]['name'];

                                debugPrint('Select Company $firstdata');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SaleBomScreen(
                                              companycode: firstdata[index]
                                                  ['code'],
                                              userid: widget.userid,
                                              iconlink:
                                                  jsonResponse['full_image'] +
                                                      firstdata[index]
                                                          ['logo_name'],
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
                                        builder: (context) => SaleBomScreen(
                                              companycode: code,
                                              userid: widget.userid,
                                              iconlink:
                                                  jsonResponse['full_image'] +
                                                      firstdata[index]
                                                          ['logo_name'],
                                            )));
                              },
//                    child: Text(firstdata[index]['name'] ?? 'NULL PASSED')
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
                                        "(${firstdata[index]['bom_order_count'].toString()})")
                                    // Text("(${firstdata[index]['bom_order_count'].toString()})")
                                  ],
                                ),
                              ),
                            ),
//                trailing: Text(firstdata[index]['order_count'].toString()),
                            children: <Widget>[
                              Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
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
                                                //  code = firstdata[index]['code'];
                                                //   name = firstdata[index]['name'];

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SaleBomScreen(
                                                              companycode: list2[
                                                                      index][
                                                                  'company_code'],
                                                              userid:
                                                                  widget.userid,
                                                              iconlink: jsonResponse[
                                                                      'full_image'] +
                                                                  list2[index][
                                                                      'logo_name'],
                                                              search_user_id:
                                                                  list2[index][
                                                                      'user_id'],
                                                            )));
                                              },
                                              child: ListTile(
                                                title:
                                                    Text(list2[index]['name']),
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
                                        builder: (context) => SaleBomScreen(
                                              companycode: firstdata[index]
                                                  ['code'],
                                              userid: widget.userid,
                                              iconlink:
                                                  jsonResponse['full_image'] +
                                                      firstdata[index]
                                                          ['logo_name'],
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
//                      child: Image.asset('images/appstore.png', width: 50, height: 50)
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
                                        builder: (context) => SaleBomScreen(
                                              companycode: code,
                                              userid: widget.userid,
                                              iconlink:
                                                  jsonResponse['full_image'] +
                                                      firstdata[index]
                                                          ['logo_name'],
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
                                        "(${firstdata[index]['bom_order_count'].toString()})")
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
//
        ),
      ),
    );
  }
}
