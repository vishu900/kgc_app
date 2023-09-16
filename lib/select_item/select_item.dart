import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/gateEntry/GateEntryItemModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectItem extends StatefulWidget {
  final String? userId;
  final String? partyId;
  final String? compCode;
  final String? docType;

  const SelectItem(
      {Key? key, this.userId, this.partyId, this.compCode, this.docType})
      : super(key: key);

  @override
  _SelectItemState createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> with NetworkResponse {
  List<GateEntryItemModel> _itemList = [];
  List<String?> _imageList = [];
  String imageBaseUrl = '';
  int _current = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              var res =
                  _itemList.where((element) => element.isSelected).toList();
              Navigator.pop(context, {'res': res, 'baseUrl': imageBaseUrl});
            }),
        automaticallyImplyLeading: false,
        title: Text('Select Item'),
      ),
      body: _itemList.isNotEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _getBodyWidget(),

                  Visibility(
                    visible: _imageList.isNotEmpty,
                    child: Container(
                      height: 35.0.h,
                      child: PageView.builder(
                          itemCount: _imageList.length,
                          itemBuilder: (context, index) => Container(
                                height: 33.0.h,
                                margin: EdgeInsets.all(8),
                                child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'images/loading_placeholder.png',
                                    image:
                                        '$imageBaseUrl${_imageList[index]}.png'),
                              )),
                    ),
                  ),

                  /// Carousel Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _imageList.map((item) {
                      int mIndex = _imageList.indexOf(item);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == mIndex
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ))
          : Center(
              child: Text('No data found!'),
            ),
    );
  }

  Widget _getBodyWidget() {
    if (widget.docType == '13') {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _buildCells2(_itemList.length),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildRows2(_itemList.length),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildCells(_itemList.length),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRows(_itemList.length),
              ),
            ),
          )
        ],
      );
    }
  }

  _getItems() {
    Map jsonBody = {
      'user_id': getUserId(),
      'party_id': widget.partyId, //23
      'comp_code': widget.compCode,
      'doc_type': widget.docType
    };

    WebService.fromApi(AppConfig.gateEntryPartiesItem, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.gateEntryPartiesItem:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              _itemList.clear();

              var content = data['content'] as List?;
              imageBaseUrl = getString(data, 'image_item_png_path');

              if (widget.docType == '13') {
                _itemList.addAll(content!
                    .map((e) => GateEntryItemModel.fromJSON2(e))
                    .toList());

                if (_itemList.isNotEmpty) {
                  /// Header
                  _itemList.insert(
                      0,
                      GateEntryItemModel(
                          catalogCode: 'Catalog Code',
                          orderNo: 'Order No',
                          partyItemName: 'Party Item Name',
                          process: 'Process',
                          orderQty: 'Order Qty',
                          gateEntryQty: 'Gate Entry Qty',
                          balQty: 'Balance Qty',
                          stockUom: 'Uom',
                          isHeader: true));

                  /// Footer
                  _itemList.add(GateEntryItemModel(
                      catalogCode: 'Total',
                      orderQty: _getTotal('OrderQty'),
                      gateEntryQty: _getTotal('GateEntryQty'),
                      balQty: _getTotal('BalQty'),
                      orderNo: ''));
                }
              } else {
                _itemList.addAll(content!
                    .map((e) => GateEntryItemModel.fromJSON(e))
                    .toList());
                if (_itemList.isNotEmpty) {
                  /// Header
                  _itemList.insert(
                      0,
                      GateEntryItemModel(
                          catalogCode: 'Catalog Code',
                          indentNo: 'Indent No',
                          purchaseOrderNo: 'Pur Order',
                          purchaseOrderDate: 'PO Date',
                          partyItemName: 'Party Item Name',
                          rate: 'Rate',
                          poQty: 'PO Qty',
                          recdQty: 'Recd Qty',
                          balQty: 'Bal Qty',
                          stockUom: 'UOM',
                          isHeader: true));

                  /// Footer
                  _itemList.add(GateEntryItemModel(
                    id: 'Total',
                    poQty: _getTotal('PoQty'),
                    recdQty: _getTotal('RecdQty'),
                    balQty: _getTotal('BalQty'),
                  ));
                }
              }

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

  /// For DocType: 1
  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: GestureDetector(
          onTap: () {
            if (_itemList[mainIndex].isHeader) return;
            if (_itemList.length - 1 == mainIndex) return;
            _imageList.clear();
            setState(() {
              _imageList.addAll(_itemList[mainIndex].imageList!);
              if (_itemList[mainIndex].imageList!.isEmpty)
                Commons.showToast('No image found!');
            });
          },
          child: Container(
              width: 124,
              height: 50,
              color: _itemList[mainIndex].isHeader
                  ? AppColor.appRed
                  : _itemList[mainIndex].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: _getCheckBoxVisibility(mainIndex)
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: _getCheckBoxVisibility(mainIndex),
                          child: Checkbox(
                            onChanged: (bool? value) {
                              setState(() {
                                _itemList[mainIndex].isSelected =
                                    !_itemList[mainIndex].isSelected;
                              });
                            },
                            value: _itemList[mainIndex].isSelected,
                          ),
                        ),
                        Text(
                          _itemList[mainIndex].catalogCode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _itemList[mainIndex].isHeader
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRows(int count) {
    return List.generate(count, (index) => _eachRow(count, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Indent No
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _itemList[index].indentNo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: _itemList[index].isHeader
                              ? Colors.white
                              : Colors.black),
                    ),
                    Visibility(
                        visible: _itemList[index].isHeader,
                        child: SizedBox(width: 6)),
                  ],
                ),
              ),
            ),
          ),

          /// Pur Order
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].purchaseOrderNo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// PO Date
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 36,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].purchaseOrderDate,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Party Item Name
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 96,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].partyItemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Rate
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].rate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Po Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].poQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Recd Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].recdQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Bal Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].balQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// UOM
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].stockUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// For DocType: 13
  /// Vertically
  List<Widget> _buildCells2(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: GestureDetector(
          onTap: () {
            if (_itemList[mainIndex].isHeader) return;
            if (_itemList.length - 1 == mainIndex) return;
            _imageList.clear();
            setState(() {
              _imageList.addAll(_itemList[mainIndex].imageList!);
              if (_itemList[mainIndex].imageList!.isEmpty)
                Commons.showToast('No image found!');
            });
          },
          child: Container(
              width: 124,
              height: 50,
              color: _itemList[mainIndex].isHeader
                  ? AppColor.appRed
                  : _itemList[mainIndex].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: _getCheckBoxVisibility(mainIndex)
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: _getCheckBoxVisibility(mainIndex),
                          child: Checkbox(
                            onChanged: (bool? value) {
                              setState(() {
                                _itemList[mainIndex].isSelected =
                                    !_itemList[mainIndex].isSelected;
                              });
                            },
                            value: _itemList[mainIndex].isSelected,
                          ),
                        ),
                        Text(
                          _itemList[mainIndex].catalogCode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _itemList[mainIndex].isHeader
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRows2(int count) {
    return List.generate(count, (index) => _eachRow2(count, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow2(int count, int index) {
    double width = 120;
    return Container(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Row(children: [
          /// Order No
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _itemList[index].orderNo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: _itemList[index].isHeader
                              ? Colors.white
                              : Colors.black),
                    ),
                    Visibility(
                        visible: _itemList[index].isHeader,
                        child: SizedBox(width: 6)),
                  ],
                ),
              ),
            ),
          ),

          /// Party Item Name
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 96,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].partyItemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Process Name
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].process,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Order Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].orderQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Gate Entry Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].gateEntryQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Bal Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].balQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// UOM
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: width + 24,
              color: _itemList[index].isHeader
                  ? AppColor.appRed
                  : _itemList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _itemList[index].stockUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /// type-> Bag, StockQty, BillQty
  _getTotal(String type) {
    if (_itemList.isEmpty)
      return '0';
    else {
      var res = _itemList.where((element) => !element.isHeader);

      double count = 0.0;

      if (type == 'PoQty') {
        res.forEach((element) {
          count += element.poQty.toDouble();
        });
        return count.toString();
      } else if (type == 'RecdQty') {
        res.forEach((element) {
          count += element.recdQty.toDouble();
        });
        return count.toString();
      } else if (type == 'BalQty') {
        res.forEach((element) {
          count += element.balQty.toDouble();
        });
        return count.toString();
      } else if (type == 'OrderQty') {
        res.forEach((element) {
          count += element.orderQty.toDouble();
        });
        return count.toString();
      } else if (type == 'GateEntryQty') {
        res.forEach((element) {
          count += element.gateEntryQty.toDouble();
        });
        return count.toString();
      }
    }
  }

  _getCheckBoxVisibility(int index) {
    if (_itemList[index].isHeader) {
      return false;
    } else if (index == _itemList.length - 1) {
      return false;
    } else
      return true;
  }
}
