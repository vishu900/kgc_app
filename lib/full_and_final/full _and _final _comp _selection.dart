import 'dart:convert';

import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'full_and_final.dart';
import '../network/NetworkResponse.dart';
import '../network/WebService.dart';
import '../newmodel/QCompanyModel.dart';

class FullAndFinalCompSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FullAndFinalCompSelection();
}

class _FullAndFinalCompSelection extends State<FullAndFinalCompSelection>
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
        title: Text("Full And Final Company Selection"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: companyList.length,
        itemBuilder: (ctx, index) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              /* if (companyList[index].ledgerBalance < 1) {
                Commons.showToast('Insufficient ledger balance.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      FullAndFinal(compId: companyList[index].id)));
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
      'tid': Permissions.FANDF,
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
