import 'dart:convert';

import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/datamodel/companydetail.dart';
import 'package:dataproject2/datamodel/content.dart';
import 'package:dataproject2/pageviewclass.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const companyApiURl = "${AppConfig.baseUrl}api/company";

/// Sale Order Company Selection
class CompanySelection extends StatefulWidget {
  final CompanyList;

  final userid, name;

  const CompanySelection({Key? key, this.CompanyList, this.userid, this.name})
      : super(key: key);

  @override
  _CompanySelectionState createState() => _CompanySelectionState();
}

class _CompanySelectionState extends State<CompanySelection> {
  dynamic jsonResponse = null;
  List<Content>? companydetails;
  var companyDetail;
  String? name;
  String? code;
  String companyApiURl = "${AppConfig.baseUrl}api/company";
  bool? isLoading;

  List<SaleOrderCompSelection> _compList = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getcompanies(widget.userid);
    });
  }

  getcompanies(String? userid) async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {'user_id': userid, 'tid': Permissions.SALE_ORDERS};

    var response = await http.post(Uri.parse(companyApiURl), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      String? errorcheck = jsonResponse['error'];

      companyDetail = CompanyDetail.fromJson(json.decode(response.body));

      if (jsonResponse['error'] == 'false') {
        var content = jsonResponse['content'] as List;

        _compList.addAll(
            content.map((e) => SaleOrderCompSelection.fromJson(e)).toList());
      }

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
                  itemCount: _compList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return _compList[index].userList!.isNotEmpty
                        ? ExpansionTileCard(
                            leading: GestureDetector(
                              onTap: () {
                                logIt('Company-> ${_compList[index].code}');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageViewClass(
                                            companycode: _compList[index].code,
                                            userid: widget.userid,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    _compList[index].logo)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  jsonResponse['full_image'] +
                                      _compList[index].logo,
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageViewClass(
                                            companycode: _compList[index].code,
                                            userid: widget.userid,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    _compList[index].logo)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_compList[index].name!),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("(${_compList[index].orderCount})")
                                  ],
                                ),
                              ),
                            ),
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
                                        itemCount:
                                            _compList[index].userList!.length,
                                        itemBuilder:
                                            (BuildContext ctx, int mIndex) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 60),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PageViewClass(
                                                              companycode:
                                                                  _compList[
                                                                          index]
                                                                      .code,
                                                              userid:
                                                                  widget.userid,
                                                              iconlink: jsonResponse[
                                                                      'full_image'] +
                                                                  _compList[
                                                                          index]
                                                                      .logo,
                                                              search_user_id:
                                                                  _compList[
                                                                          index]
                                                                      .userList![
                                                                          mIndex]
                                                                      .code,
                                                            )));
                                              },
                                              child: ListTile(
                                                title: Text(_compList[index]
                                                    .userList![mIndex]
                                                    .name!),
                                                trailing: Text(_compList[index]
                                                    .userList![mIndex]
                                                    .orderCount!),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageViewClass(
                                            companycode: _compList[index].code,
                                            userid: widget.userid,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    _compList[index].logo)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  jsonResponse['full_image'] +
                                      _compList[index].logo,
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageViewClass(
                                            companycode: _compList[index].code,
                                            userid: widget.userid,
                                            iconlink:
                                                jsonResponse['full_image'] +
                                                    _compList[index].logo)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_compList[index].name!),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("(${_compList[index].orderCount})")
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
        ),
      ),
    );
  }
}

class SaleOrderCompSelection {
  final String? code;
  final String? name;
  final String? logo;
  final String? orderCount;
  final List<SaleOrderUser>? userList;

  SaleOrderCompSelection(
      {this.code, this.name, this.logo, this.orderCount, this.userList});

  factory SaleOrderCompSelection.fromJson(Map<String, dynamic> data) {
    var usrContentList = data['user_lists'] as List;
    List<SaleOrderUser> userList = [];

    userList
        .addAll(usrContentList.map((e) => SaleOrderUser.fromJson(e)).toList());

    return SaleOrderCompSelection(
        code: getString(data, 'code'),
        name: getString(data, 'name'),
        logo: getString(data, 'logo_name'),
        orderCount: getString(data, 'order_count'),
        userList: userList);
  }
}

class SaleOrderUser {
  final String? code;
  final String? name;
  final String? orderCount;

  SaleOrderUser({this.code, this.name, this.orderCount});

  factory SaleOrderUser.fromJson(Map<String, dynamic> data) {
    return SaleOrderUser(
        code: getString(data, 'user_id'),
        name: getString(data, 'name'),
        orderCount: getString(data, 'count'));
  }
}
