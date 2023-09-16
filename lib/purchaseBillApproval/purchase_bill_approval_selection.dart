import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'pur_bill_approval_selection_model.dart';
import 'purchaseBillApproval.dart';

class PurBillApprovalSelection extends StatefulWidget {
  final String? compCode;
  final String? imageBaseUrl;
  final String? logo;

  const PurBillApprovalSelection(
      {Key? key, required this.compCode, this.imageBaseUrl, this.logo})
      : super(key: key);

  @override
  _PurBillApprovalSelectionState createState() =>
      _PurBillApprovalSelectionState();
}

class _PurBillApprovalSelectionState extends State<PurBillApprovalSelection>
    with NetworkResponse {
  Widget _height = SizedBox(height: 12);
  final _companyController = TextEditingController();
  final _textStyle = TextStyle(fontSize: 16);
  // final _textStyleHighlight=TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.bold);
  String? _compCode = '';

  List<QCompanyModel> companyList = [];
  List<PurBillAppSelectionModel> _pendingBillMainList = [];
  List<PurBillAppSelectionModel> _pendingBillList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _compCode = widget.compCode;
    _getAllBill();
    //   _getCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              child: Image.network('${widget.imageBaseUrl}${widget.logo}'),
            ),
            SizedBox(width: 8),
            Flexible(child: Text('Purchase Bill Approval Selection')),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /// Search
              TextFormField(
                controller: _companyController,
                onChanged: (v) {
                  _search(v);
                },
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _companyController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _companyController.clear();
                              _search('');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(Icons.clear),
                          ))
                      : null,
                  hintText: 'Search',
                ),
              ),

              _height,

              Row(
                children: [
                  Text('Total Result: ${_pendingBillList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic)),
                ],
              ),

              _height,

              _pendingBillList.isNotEmpty
                  ? Column(
                      children: List.generate(
                          _pendingBillList.length,
                          (index) => Card(
                                margin: EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () async {
                                    clearFocus(context);
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PurchaseBillApproval(
                                                  compCode: _compCode,
                                                  billId:
                                                      _pendingBillList[index]
                                                          .id,
                                                )));
                                    _getAllBill();
                                  },
                                  child: Table(
                                    children: [
                                      /// Party Name
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Party Name',
                                              style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index]
                                                  .partyName!,
                                              style: _textStyle),
                                        ),
                                      ]),

                                      /// Doc No
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Text('Doc No', style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index].docNo!,
                                              style: _textStyle),
                                        ),
                                      ]),

                                      /// Doc Date
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Doc Date',
                                              style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index].docDate!,
                                              style: _textStyle),
                                        ),
                                      ]),

                                      /// Bill No
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Bill No',
                                              style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index].billNo!,
                                              style: _textStyle),
                                        ),
                                      ]),

                                      /// Bill Date
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Bill Date',
                                              style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index].billDate!,
                                              style: _textStyle),
                                        ),
                                      ]),

                                      /// Bill Amount
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Bill Amount',
                                              style: _textStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              _pendingBillList[index]
                                                  .billAmount!,
                                              style: _textStyle),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              )),
                    )
                  : Center(child: Text('No data found!')),
            ],
          ),
        ),
      ),
    );
  }

  /*_getCompanyList() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }*/

  _getAllBill() {
    Map jsonBody = {'user_id': getUserId(), 'comp_code': _compCode};
    WebService.fromApi(AppConfig.getPendingBill, this, jsonBody)
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

              companyList.add(QCompanyModel(
                  id: '',
                  address1: '',
                  address2: '',
                  logoName: '',
                  name: 'Select Company'));
              companyList.addAll(
                  content.map((e) => QCompanyModel.fromJson(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.getPendingBill:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _pendingBillMainList.clear();
              _pendingBillList.clear();

              _pendingBillMainList.addAll(content
                  .map((e) => PurBillAppSelectionModel.fromJson(e))
                  .toList());
              _pendingBillList.addAll(content
                  .map((e) => PurBillAppSelectionModel.fromJson(e))
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

  _search(String str) {
    if (str.isNotEmpty) {
      var result = _pendingBillMainList.where((e) =>
          e.billNo!.toLowerCase() == str.toLowerCase() ||
          e.docNo!.toLowerCase().contains(str.toLowerCase()) ||
          e.partyName!.toLowerCase().contains(str.toLowerCase()) ||
          e.docDate!.toLowerCase().contains(str.toLowerCase()) ||
          e.billDate!.toLowerCase().contains(str.toLowerCase()) ||
          e.billAmount!.toLowerCase().contains(str.toLowerCase()));

      setState(() {
        _pendingBillList.clear();
        _pendingBillList.addAll(result);
      });
    } else {
      setState(() {
        _pendingBillList.clear();
        _pendingBillList.addAll(_pendingBillMainList);
      });
    }
  }

  companyBottomSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: companyList[index].logoName!.isNotEmpty
                      ? Image.network(
                          AppConfig.small_image + companyList[index].logoName!,
                          width: 32.0,
                          height: 32.0,
                        )
                      : Icon(Icons.done_sharp, color: Colors.black),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(companyList[index].name!),
                ),
                onTap: () {
                  popIt(context);
                  _companyController.text = companyList[index].name!;
                  _compCode = companyList[index].id;
                  if (_compCode!.isNotEmpty) _getAllBill();
                  setState(() {
                    _pendingBillList.clear();
                  });
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }
}
