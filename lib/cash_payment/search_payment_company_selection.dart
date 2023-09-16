import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/cash_payment/search_cash_payment.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'cash_payment_comp_selection.dart';
import 'cash_payments_approval_comp_selection.dart';

class CashCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashCompSelection();
}

class _CashCompSelection extends State<CashCompSelection> with NetworkResponse {
  List<CashPayApprCompanyModel> cashpaycompanylist = [];
  // List<QCompanyModel> companyList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //_getCompanyList();
      _getCashCompany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment Company Selection'),
      ),
      /* body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: companyList.length,
        itemBuilder: (ctx, index) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () async {

              if(ifHasPermission(
                  compCode:companyList[index].id,
                  permission: Permissions.CASH_PAYMENT,
                  permType: PermType.SEARCH
              )) {

             await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SearchCashPayment(compId: companyList[index].id,compName: companyList[index].name,)));

              }
              else{
                Commons.showToast('You don\'t have permission');
              }

            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    child: Image.network(
                        '${AppConfig.small_image}${companyList[index].logoName}'),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            companyList[index].name,
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
        ),
      ),*/
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: cashpaycompanylist.length,
        itemBuilder: (ctx, index) => ExpansionTile(
            title: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () async {
                if (ifHasPermission(
                    compCode: cashpaycompanylist[index].id,
                    permission: Permissions.CASH_PAYMENT,
                    permType: PermType.SEARCH)!) {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchCashPayment(
                            compId: cashpaycompanylist[index].id,
                            compName: cashpaycompanylist[index].name,
                          )));
                } else {
                  Commons.showToast('You don\'t have permission');
                }
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
                        onTap: () async {
                          if (ifHasPermission(
                              compCode: cashpaycompanylist[index].id,
                              permission: Permissions.CASH_PAYMENT,
                              permType: PermType.SEARCH)!) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchCashPayment(
                                    type: 'emp',
                                    compId: cashpaycompanylist[index].id,
                                    compName: cashpaycompanylist[index].name,
                                    empid: cashpaycompanylist[index]
                                        .cashpayappruserlist![subIndex]
                                        .id)));
                          } else {
                            Commons.showToast('You don\'t have permission');
                          }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CashPaymentCompSelection()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.CASH_PAYMENT,
      'mode_flag': 'A,I'
    };
    WebService.fromApi(AppConfig.companydetailApiURl, this, jsonBody)
        .callPostService(context);
  }

  _getCashCompany() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.CASH_PAYMENT,
      'mode_flag': 'A,I'
    };
    WebService.fromApi(AppConfig.getCashCompany, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getCashCompany:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var cashCompanyContent = data['content'] as List;
              cashpaycompanylist.clear();
              cashpaycompanylist.addAll(cashCompanyContent
                  .map((e) => CashPayApprCompanyModel.parsejson(e))
                  .toList());

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }
}
