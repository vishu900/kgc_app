import 'dart:convert';

import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/purchaseBillApproval/pur_comp_model.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'purchase_bill_approval_selection.dart';

class PurBillCompSelection extends StatefulWidget {
  const PurBillCompSelection({Key? key}) : super(key: key);

  @override
  _PurBillCompSelectionState createState() => _PurBillCompSelectionState();
}

class _PurBillCompSelectionState extends State<PurBillCompSelection>
    with NetworkResponse {
  List<PurCompModel> _compList = [];

  String _imageBaseUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _fetchPendingBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Bill Approval Selection'),
        centerTitle: false,
      ),
      body: _compList.isNotEmpty
          ? ListView.builder(
              itemCount: _compList.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PurBillApprovalSelection(
                                compCode: _compList[index].id,
                                imageBaseUrl: _imageBaseUrl,
                                logo: _compList[index].logo,
                              )));

                      _fetchPendingBills();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            child: Image.network(
                                '$_imageBaseUrl${_compList[index].logo}'),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    _compList[index].name!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(_compList[index].orderCount!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('No data found!')),
    );
  }

  _fetchPendingBills() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid': Permissions.PUR_BILL_APPROVAL,
      'mode_flag': 'M,A'
    };

    WebService.fromApi(AppConfig.approveBillCompanies, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.approveBillCompanies:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              _imageBaseUrl = getString(data, 'small_image');

              _compList.clear();

              _compList.addAll(
                  content.map((e) => PurCompModel.fromJson(e)).toList());

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
