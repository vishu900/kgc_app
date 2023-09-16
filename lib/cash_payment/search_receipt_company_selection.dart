import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/cash_payment/search_cash_receipt.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../cash_receipt_company_selection.dart';
import 'cash_receipt_approval_comp_selection.dart';

class CashRecCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashRecCompSelection();
}

class _CashRecCompSelection extends State<CashRecCompSelection>
    with NetworkResponse {
  // List<QCompanyModel> companyList = [];

  List<CashRecApprCompanyModel> cashreccompanylist = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCashRecCompany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cash Receipt Company Selection')),
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
                        SearchCashReceipt(compId: companyList[index].id,compName:companyList[index].name)));
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
        itemCount: cashreccompanylist.length,
        itemBuilder: (ctx, index) => ExpansionTile(
            title: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () async {
                if (ifHasPermission(
                    compCode: cashreccompanylist[index].id,
                    permission: Permissions.CASH_PAYMENT,
                    permType: PermType.SEARCH)!) {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchCashReceipt(
                          compId: cashreccompanylist[index].id,
                          compName: cashreccompanylist[index].name)));
                } else {
                  Commons.showToast('You don\'t have permission');
                }

                /*Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CashReceiptApproval(compId: cashreccompanylist[index].id)));*/
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
                        onTap: () async {
                          if (ifHasPermission(
                              compCode: cashreccompanylist[index].id,
                              permission: Permissions.CASH_PAYMENT,
                              permType: PermType.SEARCH)!) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchCashReceipt(
                                      empid: cashreccompanylist[index]
                                          .cashrecappruserlist![subIndex]
                                          .id,
                                      type: 'emp',
                                      compId: cashreccompanylist[index].id,
                                      compName: cashreccompanylist[index].name,
                                    )));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CashReceiptCompSelection()));
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
      'tid': Permissions.CASH_RECEIPT,
      'mode_flag': 'A,I'
    };
    WebService.fromApi(AppConfig.companydetailRecApiURl, this, jsonBody)
        .callPostService(context);
  }

  _getCashRecCompany() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.CASH_RECEIPT,
      'mode_flag': 'A,I'
    };
    WebService.fromApi(AppConfig.getCashRecCompany, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getCashRecCompany:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              var cashreccompanycontent = data['content'] as List;
              cashreccompanylist.addAll(cashreccompanycontent
                  .map((e) => CashRecApprCompanyModel.parsejson(e))
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
