import 'dart:convert';

import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'loan_entry.dart';

class LoanEntryCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoanEntryCompSelection();
}

class _LoanEntryCompSelection extends State<LoanEntryCompSelection>
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
        title: Text('Loan Entry Company Selection'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: companyList.length,
        itemBuilder: (ctx, index) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      LoanEntry(compId: companyList[index].id)));
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

            logIt('Company-> $data');

            if (data['error'] == 'false') {
              logIt('GetCompany-> $data');

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
