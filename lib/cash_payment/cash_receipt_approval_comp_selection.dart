import 'dart:convert';

//import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/cash_payment/cash_receipt_approval.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

class CashReceiptApprovalCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashReceiptApprovalCompSelection();
}

class _CashReceiptApprovalCompSelection
    extends State<CashReceiptApprovalCompSelection> with NetworkResponse {
  List<CashRecApprCompanyModel> cashreccompanylist = [];
  var cashrecappruserlist = '';
  var name = '';
  var id;
  var count;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCompanyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cash Receipt Company Selection')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: cashreccompanylist.length,
        itemBuilder: (ctx, index) => ExpansionTile(
            title: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CashReceiptApproval(
                        compId: cashreccompanylist[index].id)));
              },
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        child: (cashreccompanylist[index].image!.isNotEmpty)
                            ? Image.network(
                                '${AppConfig.small_image}${cashreccompanylist[index].image}')
                            : Image.asset('images/noImage.png')),
                    SizedBox(width: 10),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${cashreccompanylist[index].name}(${cashreccompanylist[index].count})',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            children: List.generate(
                cashreccompanylist[index].cashrecappruserlist!.length,
                (subIndex) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CashReceiptApproval(
                                    compId: cashreccompanylist[index].id,
                                    empid: cashreccompanylist[index]
                                        .cashrecappruserlist![subIndex]
                                        .id,
                                    type: 'emp',
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  cashreccompanylist[index]
                                      .cashrecappruserlist![subIndex]
                                      .name!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  cashreccompanylist[index]
                                      .cashrecappruserlist![subIndex]
                                      .count!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))),
      ),
    );
  }

  _getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
    };
    WebService.fromApi(AppConfig.companydetailRecApiURl, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    if (requestCode == AppConfig.companydetailRecApiURl) {
      var data = jsonDecode(response!);
      if (data['error'] == 'false') {
        var cashreccompanycontent = data['content'] as List;
        cashreccompanylist.addAll(cashreccompanycontent
            .map((e) => CashRecApprCompanyModel.parsejson(e))
            .toList());
        setState(() {});
      }
    }
  }
}

class CashRecApprCompanyModel {
  String? name;
  String? image;
  String? count;
  String? id;
  List<CashRecApprUserModel>? cashrecappruserlist;

  CashRecApprCompanyModel(
      {this.name, this.image, this.count, this.id, this.cashrecappruserlist});
  factory CashRecApprCompanyModel.parsejson(Map<String, dynamic> data) {
    List<CashRecApprUserModel> cashrecappruserlist = [];
    var cashrecapprusercontent = data['user_lists'] as List;
    cashrecappruserlist.addAll(cashrecapprusercontent
        .map((e) => CashRecApprUserModel.parsejson(e))
        .toList());
    return CashRecApprCompanyModel(
        name: getString(data, 'name'),
        count: getString(data, 'cash_payment_order_count'),
        image: getString(data, 'logo_name'),
        id: getString(data, 'code'),
        cashrecappruserlist: cashrecappruserlist);
  }
}

class CashRecApprUserModel {
  String? name, id, count;
  CashRecApprUserModel({this.name, this.id, this.count});
  factory CashRecApprUserModel.parsejson(Map<String, dynamic> data) {
    return CashRecApprUserModel(
        name: getString(data, 'name'),
        id: getString(data, 'user_id'),
        count: getString(data, 'count'));
  }
}
