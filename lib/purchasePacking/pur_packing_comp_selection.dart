import 'dart:convert';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/purchasePacking/PurchasePackingBill.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'PurPackingSelection.dart';

class PurPackingCompSelection extends StatefulWidget {
  final PurPackType? gateEntryType;

  const PurPackingCompSelection({Key? key, this.gateEntryType})
      : super(key: key);

  @override
  _PurPackingCompSelectionState createState() =>
      _PurPackingCompSelectionState();
}

class _PurPackingCompSelectionState extends State<PurPackingCompSelection>
    with NetworkResponse {
  List<QCompanyModel> companyList = [];
  String _imageBaseUrl = '';

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
        title: Row(
          children: [
            Flexible(child: Text('Purchase Packing')),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: companyList.length,
        itemBuilder: (ctx, index) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurPackingSelection(
                        compCode: companyList[index].id,
                        compName: companyList[index].name,
                        imageBaseUrl: _imageBaseUrl,
                        logo: companyList[index].logoName,
                      )));
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
      'tid': Permissions.PUR_PACKING_BILL,
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