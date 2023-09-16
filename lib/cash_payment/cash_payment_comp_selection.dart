import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'cash_payment.dart';

class CashPaymentCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CashPaymentCompSelection();
}

class _CashPaymentCompSelection extends State<CashPaymentCompSelection>
    with NetworkResponse {
  List<QCompanyModel> companyList = [];
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
        itemCount: companyList.length,
        itemBuilder: (ctx, index) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              if (ifHasPermission(
                  compCode: companyList[index].id,
                  permission: Permissions.CASH_PAYMENT,
                  permType: PermType.INSERT)!) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CashPayment(
                          compId: companyList[index].id,
                          compName: companyList[index].name,
                        )));
              } else {
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
                            companyList[index].name!,
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
      ),
    );
  }

  _getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.CASH_PAYMENT,
      'mode_flag': 'A,I'
    };
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getCompany:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              var content = data['content'] as List;
              companyList.clear();
              companyList.addAll(
                  content.map((e) => QCompanyModel.fromJson(e)).toList());
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
