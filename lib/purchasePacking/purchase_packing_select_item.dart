import 'dart:convert';

import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/purchasePacking/PurPackItemModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'PurchasePackingBill.dart';

class PurchasePackingSelectItem extends StatefulWidget {
  final String? compCode;
  final String? partyId;
  final PurPackType? type;

  const PurchasePackingSelectItem(
      {Key? key, this.compCode, this.partyId, this.type})
      : super(key: key);

  @override
  _PurchasePackingSelectItemState createState() =>
      _PurchasePackingSelectItemState();
}

class _PurchasePackingSelectItemState extends State<PurchasePackingSelectItem>
    with NetworkResponse {
  String imageBaseUrl = '';

  List<PurPackItemModel> _itemList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _getPartiesItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Select Item'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              var selectedData;

              _itemList.forEach((element) {
                if (element.isSelected) selectedData = element;
              });

              Navigator.pop(
                  context, {'baseUrl': imageBaseUrl, 'list': selectedData});
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _itemList.isEmpty
            ? Center(child: Text('No data found'))
            : Column(
                children: [
                  Table(
                    children: [
                      TableRow(children: [
                        Text('Gate Entry Sr',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Gate Entry Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        Text(
                            widget.type == PurPackType.Bill
                                ? 'Bill No'
                                : 'Challan No',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                        Text(
                            widget.type == PurPackType.Bill
                                ? 'Bill Date'
                                : 'Challan Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700)),
                      ])
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: List.generate(
                        _itemList.length,
                        (index) => Table(
                              children: [
                                TableRow(children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio(
                                          value: true,
                                          groupValue:
                                              _itemList[index].isSelected,
                                          onChanged: (dynamic v) {
                                            var selection =
                                                _itemList[index].isSelected;

                                            _itemList.forEach((element) {
                                              element.isSelected = false;
                                            });

                                            setState(() {
                                              _itemList[index].isSelected =
                                                  !selection;
                                            });
                                          }),
                                      Text(_itemList[index].gateSrNo!,
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(_itemList[index].gateSrdate!,
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(_itemList[index].billNo!,
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(_itemList[index].billDate!,
                                        textAlign: TextAlign.center),
                                  ),
                                ])
                              ],
                            )),
                  )
                ],
              ),
      ),
    );
  }

  _getPartiesItem() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compCode,
      'party_id': widget.partyId,
      'type': widget.type == PurPackType.Challan ? 'challan' : 'bill'
    };

    WebService.fromApi(AppConfig.packingPartiesItem, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.packingPartiesItem:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              imageBaseUrl = getString(data, 'image_item_png_path');

              var content = data['content'] as List;

              _itemList.clear();

              _itemList.addAll(
                  content.map((e) => PurPackItemModel.fromJson(e)).toList());

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
