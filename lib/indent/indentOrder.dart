import 'dart:convert';

import 'package:dataproject2/indent/indentOrderModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';
import 'package:dataproject2/utils/Utils.dart';

class IndentOrder extends StatefulWidget {
  final String? id;

  const IndentOrder({Key? key, this.id}) : super(key: key);

  @override
  _IndentOrderState createState() => _IndentOrderState();
}

class _IndentOrderState extends State<IndentOrder> with NetworkResponse {
  Widget _height = SizedBox(height: 12);

  List<IndentOrderModel> _indentOrderList = [];

  String itemParam1 = '';
  String itemParam2 = '';
  String itemParam3 = '';
  String itemValue1 = '';
  String itemValue2 = '';
  String itemValue3 = '';
  String itemUom1 = '';
  String itemUom2 = '';
  String itemUom3 = '';

  final _companyController = TextEditingController();
  final _indentDateController = TextEditingController();
  final _indentSeriesController = TextEditingController();
  final _indentNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _approvalAuthController = TextEditingController();
  final _remarksController = TextEditingController();

  final _catalogCodeController = TextEditingController();
  final _saleOrderNoController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _shadeController = TextEditingController();
  final _purchaserController = TextEditingController();
  final _itemsRemarksController = TextEditingController();

  final _approvedByUidController = TextEditingController();
  final _approvedByNameController = TextEditingController();
  final _approvedDateController = TextEditingController();

  List<String?> _imageList = [];
  String _imageBaseUrl = '';
  int _current = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _getIndentDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indent Order'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            /// Company Name
            TextFormField(
              readOnly: true,
              controller: _companyController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Indent Date & Series
            Row(
              children: [
                /// Indent Date
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _indentDateController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Indent Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                /// Indent Series
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _indentSeriesController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Indent Series',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            _height,

            /// Indent No & Department
            Row(
              children: [
                /// Indent No
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _indentNoController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Indent No',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                /// Department
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _departmentController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            _height,

            /// Approval Auth & Remarks
            Row(
              children: [
                /// Approval Auth
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _approvalAuthController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Approval Auth',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                /// Remarks
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _remarksController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            _height,

            /// Flexible Table
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _buildCells(_indentOrderList.length),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRows(_indentOrderList.length),
                    ),
                  ),
                )
              ],
            ),

            _height,

            /// Item Image
            Container(
              width: 100.0.h,
              height: 36.0.h,
              child: _imageList.isNotEmpty
                  ? PhotoViewGallery.builder(
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int imgIndex) {
                        _current = imgIndex;
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(
                              '$_imageBaseUrl${_imageList[imgIndex]}.png'),
                          initialScale: PhotoViewComputedScale.contained * 0.8,
                        );
                      },
                      onPageChanged: (value) {
                        setState(() {
                          _current = value;
                        });
                      },
                      itemCount: _imageList.length,
                      loadingBuilder: (context, event) => Center(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            value: event == null
                                ? 0
                                : event.cumulativeBytesLoaded /
                                    event.expectedTotalBytes!,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: Image.asset('images/noImage.png'),
                      ),
                    ),
              //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
            ),
            _height,

            /// Carousel Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageList.map((item) {
                int mIndex = _imageList.indexOf(item);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == mIndex
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),

            _height,

            /// Catalog Item Code & Sale Order No
            Row(
              children: [
                /// Catalog Item Code
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _catalogCodeController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Catalog Item Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                /// Sale Order No
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _saleOrderNoController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Sale Order No',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            _height,

            /// Item Name
            TextFormField(
              readOnly: true,
              controller: _itemNameController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Brand
            TextFormField(
              readOnly: true,
              controller: _brandController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Shade
            TextFormField(
              readOnly: true,
              controller: _shadeController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Shade',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Purchaser
            TextFormField(
              readOnly: true,
              controller: _purchaserController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Purchaser',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Remarks
            TextFormField(
              readOnly: true,
              controller: _itemsRemarksController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// IOP Values
            Table(
              children: [
                /// Table Header
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('Item Parameter',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('Value',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('Uom',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),

                /// IOP1
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemParam1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemValue1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemUom1),
                  ),
                ]),

                /// IOP2
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemParam2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemValue2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemUom2),
                  ),
                ]),

                /// IOP3
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemParam3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemValue3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(itemUom3),
                  ),
                ]),
              ],
            ),
            _height,

            /// Divider (Indent Approved By)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Flexible(
                    child: Text(
                  'Indent Approved By',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            _height,

            /// UID
            TextFormField(
              readOnly: true,
              controller: _approvedByUidController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'UID',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Name
            TextFormField(
              readOnly: true,
              controller: _approvedByNameController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            _height,

            /// Date
            TextFormField(
              readOnly: true,
              controller: _approvedDateController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            _height,
          ],
        ),
      ),
    );
  }

  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: GestureDetector(
          onTap: () {
            _viewItem(_indentOrderList[mainIndex]);
          },
          child: Container(
              width: 120,
              height: 48,
              color: _indentOrderList[mainIndex].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[mainIndex].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _indentOrderList[mainIndex].item,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _indentOrderList[mainIndex].isHeader
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
          /// PartyItemName
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 110,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].partyItemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Count
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].count,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Material
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].material,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].qty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].qtyUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Status
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _indentOrderList[index].isHeader
                  ? AppColor.appRed
                  : _indentOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _indentOrderList[index].status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _indentOrderList[index].isHeader
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

  /// type-> Qty, Amount
  _getTotal() {
    if (_indentOrderList.isEmpty)
      return '0';
    else {
      var res = _indentOrderList.where((element) => !element.isHeader);
      double count = 0.0;
      res.forEach((element) {
        count += element.qty.toDouble();
      });
      return count.toString();
    }
  }

  _getIndentDetail() {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': widget.id};

    WebService.fromApi(AppConfig.getIndentOrderDetail, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getIndentOrderDetail:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              _companyController.text =
                  getString(data['company_detail'], 'name');
              _indentDateController.text = getString(data, 'indent_date');
              _indentSeriesController.text = getString(data, 'indent_finyear');
              _indentNoController.text = getString(data, 'indent_no');
              _departmentController.text =
                  getString(data['section_name'], 'name');
              _remarksController.text = getString(data, 'remarks');
              _approvalAuthController.text =
                  getString(data['user_detail'], 'name');
              /*  _approvedByUidController.text =
                  getString(data['user_detail'], 'user_id');
              _approvedByNameController.text =
                  getString(data['user_detail'], 'name');*/

              _imageBaseUrl = getString(resp, 'image_item_png_path');

              var contents = data['indent_items'] as List;

              _indentOrderList.addAll(
                  contents.map((e) => IndentOrderModel.fromJson(e)).toList());

              if (_indentOrderList.isNotEmpty) {
                _indentOrderList.insert(
                    0,
                    IndentOrderModel(
                        id: '',
                        partyItemName: 'Party Item Name',
                        status: 'Status',
                        qtyUom: 'Uom',
                        qty: 'Qty',
                        isHeader: true,
                        count: 'Count',
                        item: 'Item',
                        material: 'Material'));

                _indentOrderList
                    .add(IndentOrderModel(item: 'Total', qty: _getTotal()));
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

  _viewItem(IndentOrderModel model) {
    _indentOrderList.forEach((element) {
      element.isViewing = false;
    });

    model.isViewing = true;

    _imageList.clear();
    _imageList.addAll(model.imageList!);

    _catalogCodeController.text = model.catalogItemCode;
    _saleOrderNoController.text = model.saleOrderNo;
    _itemNameController.text = model.catalogItemCode;
    _brandController.text = model.brandName;
    _shadeController.text = model.shade;
    _purchaserController.text = model.purchaser;
    _itemsRemarksController.text = model.remarks;

    _approvedByUidController.text = model.appUid;
    _approvedByNameController.text = model.appName;
    _approvedDateController.text = model.appDate;

    itemParam1 = model.itemParam1;
    itemParam2 = model.itemParam2;
    itemParam3 = model.itemParam3;

    itemValue1 = model.itemValue1;
    itemValue2 = model.itemValue2;
    itemValue3 = model.itemValue3;

    itemUom1 = model.itemUom1;
    itemUom2 = model.itemUom2;
    itemUom3 = model.itemUom3;

    setState(() {});
  }

  @override
  void dispose() {
    _companyController.dispose();
    _indentDateController.dispose();
    _indentSeriesController.dispose();
    _indentNoController.dispose();
    _departmentController.dispose();
    _approvalAuthController.dispose();
    _remarksController.dispose();

    _catalogCodeController.dispose();
    _saleOrderNoController.dispose();
    _itemNameController.dispose();
    _brandController.dispose();
    _shadeController.dispose();
    _purchaserController.dispose();
    _itemsRemarksController.dispose();

    _approvedByUidController.dispose();
    _approvedByNameController.dispose();
    _approvedDateController.dispose();

    super.dispose();
  }
}
