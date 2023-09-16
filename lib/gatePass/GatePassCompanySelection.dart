import 'dart:convert';

//import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/CompanySelectionModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

import 'CreateGatePass.dart';
import 'GatePass.dart';

class GatePassCompanySelection extends StatefulWidget {
  final PassType? type;

  const GatePassCompanySelection({Key? key, this.type}) : super(key: key);

  @override
  _GatePassCompanySelectionState createState() =>
      _GatePassCompanySelectionState();
}

class _GatePassCompanySelectionState extends State<GatePassCompanySelection>
    with NetworkResponse {
  List<CompanySelectionModel> _companyList = [];
  String? _baseUrl = '';
  PassType? _passType;

  @override
  void initState() {
    super.initState();
    _passType = widget.type;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Select Company',
          style: TextStyle(fontSize: 18),
        ),
      ),

      /// Main Body
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            Visibility(
              visible: false,
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          groupValue: PassType.Employee,
                          value: _passType,
                          onChanged: (dynamic v) {
                            setState(() {
                              _passType = PassType.Employee;
                            });
                            _getCompanies();
                          }),
                      Text(
                        'Employee',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          groupValue: PassType.Visitor,
                          value: _passType,
                          onChanged: (dynamic v) {
                            setState(() {
                              _passType = PassType.Visitor;
                            });
                            _getCompanies();
                          }),
                      Text(
                        'Visitor',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _companyList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _companyList.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ExpansionTileCard(
                          leading: GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _companyList[index].companyLogo!.isEmpty
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      child: Icon(
                                        Icons.error_outline,
                                        size: 36,
                                      ))
                                  : Image.network(
                                      _baseUrl! +
                                          _companyList[index].companyLogo!,
                                      width: 50.0,
                                      height: 50.0,
                                    ),
                            ),
                          ),

                          /// Company Title
                          title: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GatePass(
                                            passType: _passType,
                                            compId: _companyList[index].id,
                                          )));
                              _getCompanies(showLoader: false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_companyList[index].companyName == 'BK'
                                      ? 'BK INTERNATIONAL'
                                      : _companyList[index].companyName!),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("(${_companyList[index].count})")
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
                                      itemCount:
                                          _companyList[index].userList!.length,
                                      itemBuilder:
                                          (BuildContext ctx, int mIndex) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 60),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GatePass(
                                                            passType: _passType,
                                                            compId:
                                                                _companyList[
                                                                        index]
                                                                    .id,
                                                            entryby:
                                                                _companyList[
                                                                        index]
                                                                    .userList![
                                                                        mIndex]
                                                                    .id,
                                                          )));
                                              _getCompanies(showLoader: false);
                                            },
                                            child: ListTile(
                                              title: Text(_companyList[index]
                                                  .userList![mIndex]
                                                  .userName!),
                                              trailing: Text(_companyList[index]
                                                  .userList![mIndex]
                                                  .count
                                                  .toString()),
                                            ),
                                          ),
                                        );
                                      })),
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text('No Data Found!',
                          style: TextStyle(fontSize: 16))),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map? res = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateGatePass(passType: _passType)));
          if (res != null) {
            if (res['modified']) {
              _getCompanies();
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _getCompanies({bool showLoader = true}) {
    Map json = {'user_id': getUserId()};

    if (_passType == PassType.Employee) {
      WebService.fromApi(AppConfig.getEmployeeCompanies, this, json)
          .callPostService(context, showLoader: showLoader);
    } else {
      WebService.fromApi(AppConfig.getVisitorCompanies, this, json)
          .callPostService(context, showLoader: showLoader);
    }
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getEmployeeCompanies:
        case AppConfig.getVisitorCompanies:
          {
            var data = jsonDecode(response!);

            logIt('GatePass_onResponse-> $data');

            if (data['error'] == 'false') {
              _baseUrl = data['full_image'];

              _companyList.clear();

              var companyList = data['content'] as List;

              _companyList.addAll(companyList
                  .map((e) => CompanySelectionModel.fromJSON(e))
                  .toList());
              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err here-> $stack');
    }
  }
}
