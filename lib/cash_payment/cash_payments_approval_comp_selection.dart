import 'dart:convert';
import 'package:dataproject2/cash_payment/cash_payment_approval.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

class CashPaymentApprovalCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashPaymentApprovalCompSelection();
}

class _CashPaymentApprovalCompSelection
    extends State<CashPaymentApprovalCompSelection> with NetworkResponse {
  List<CashPayApprCompanyModel> cashpaycompanylist = [];
  var cashpayappruserlist = '';
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
      appBar: AppBar(
        title: Text('Cash Payment Company Selection'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: cashpaycompanylist.length,
        itemBuilder: (ctx, index) => ExpansionTile(
            title: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CashPaymentApproval(
                          compId: cashpaycompanylist[index].id,
                          type: 'comp',
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        child: (cashpaycompanylist[index].image!.isNotEmpty)
                            ? Image.network(
                                '${AppConfig.small_image}${cashpaycompanylist[index].image}')
                            : Image.asset('images/noImage.png')),
                    SizedBox(width: 10),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (Flexible(
                            child: Text(
                              '${cashpaycompanylist[index].name}(${cashpaycompanylist[index].count})',
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            children: List.generate(
                cashpaycompanylist[index].cashpayappruserlist!.length,
                (subIndex) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CashPaymentApproval(
                                    compId: cashpaycompanylist[index].id,
                                    empid: cashpaycompanylist[index]
                                        .cashpayappruserlist![subIndex]
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
                                  cashpaycompanylist[index]
                                      .cashpayappruserlist![subIndex]
                                      .name!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  cashpaycompanylist[index]
                                      .cashpayappruserlist![subIndex]
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

  _getCompanyList() async {
    Map jsonBody = {
      'user_id': getUserId(),
    };

    WebService.fromApi(AppConfig.companydetailApiURl, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    if (requestCode == AppConfig.companydetailApiURl) {
      var data = jsonDecode(response!);
      if (data['error'] == 'false') {
        var cashpaycompanycontent = data['content'] as List;
        cashpaycompanylist.addAll(cashpaycompanycontent
            .map((e) => CashPayApprCompanyModel.parsejson(e))
            .toList());
        setState(() {});
      }
    }
  }
}

class CashPayApprCompanyModel {
  String? name;
  String? image;
  String? count;
  String? id;
  List<CashPayApprUserModel>? cashpayappruserlist;

  CashPayApprCompanyModel(
      {this.name, this.image, this.count, this.id, this.cashpayappruserlist});
  factory CashPayApprCompanyModel.parsejson(Map<String, dynamic> data) {
    List<CashPayApprUserModel> cashpayappruserlist = [];
    var cashpayapprusercontent = data['user_lists'] as List;
    cashpayappruserlist.addAll(cashpayapprusercontent
        .map((e) => CashPayApprUserModel.parsejson(e))
        .toList());
    return CashPayApprCompanyModel(
        name: getString(data, 'name'),
        count: getString(data, 'cash_payment_order_count'),
        image: getString(data, 'logo_name'),
        id: getString(data, 'code'),
        cashpayappruserlist: cashpayappruserlist);
  }
}

class CashPayApprUserModel {
  String? name, id, count;
  CashPayApprUserModel({this.name, this.id, this.count});
  factory CashPayApprUserModel.parsejson(Map<String, dynamic> data) {
    return CashPayApprUserModel(
        name: getString(data, 'name'),
        id: getString(data, 'user_id'),
        count: getString(data, 'count'));
  }
}
