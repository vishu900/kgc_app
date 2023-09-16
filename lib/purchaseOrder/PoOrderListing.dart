import 'dart:convert';

import 'package:dataproject2/datamodel/TermsModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/purchaseOrder/PoOrderListingModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

class PoOrderListing extends StatefulWidget {
  final String? id;

  const PoOrderListing({Key? key, this.id}) : super(key: key);

  @override
  _PoOrderListingState createState() => _PoOrderListingState();
}

class _PoOrderListingState extends State<PoOrderListing> with NetworkResponse {
  final _companyController = TextEditingController();
  final _dateController = TextEditingController();
  final _seriesController = TextEditingController();
  final _noController = TextEditingController();
  final _partyController = TextEditingController();
  final _approvalByController = TextEditingController();
  final _remarksController = TextEditingController();

  final _itemSoPartyController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemAppByUidController = TextEditingController();
  final _itemAppByController = TextEditingController();
  final _itemAppDateController = TextEditingController();

  final _height = SizedBox(height: 8);

  List<PoOrderListingModel> _poOrderList = [];
  List<TermsModel> _termsList = [];
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
    _fetchPoDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Purchase Order'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            /// Company
            TextFormField(
              readOnly: true,
              controller: _companyController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Date
            TextFormField(
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Series
            TextFormField(
              readOnly: true,
              controller: _seriesController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Series',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// No
            TextFormField(
              readOnly: true,
              controller: _noController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'No',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Party
            TextFormField(
              readOnly: true,
              controller: _partyController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Party',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Approval By
            TextFormField(
              readOnly: true,
              controller: _approvalByController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Approval By',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Remarks
            TextFormField(
              readOnly: true,
              controller: _remarksController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Flexible Items
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _buildCells(_poOrderList.length),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRows(_poOrderList.length),
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

            /// SO Party
            TextFormField(
              readOnly: true,
              controller: _itemSoPartyController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'SO Party',
                border: OutlineInputBorder(),
              ),
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

            /// Divider (Sale Order Type)
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
                  'PO Approved Details',
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

            /// Approved By UID
            TextFormField(
              readOnly: true,
              controller: _itemAppByUidController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Approved By UID',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Approved By
            TextFormField(
              readOnly: true,
              controller: _itemAppByController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Approved By',
                border: OutlineInputBorder(),
              ),
            ),

            _height,

            /// Approved Date
            TextFormField(
              readOnly: true,
              controller: _itemAppDateController,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Approved Date',
                border: OutlineInputBorder(),
              ),
            ),

            _height,
            _height,

            /// Divider (Sale Order Type)
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
                  'Terms & Conditions',
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

            ListView.builder(
                itemCount: _termsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                      title: Text(_termsList[index].name!),
                      subtitle: Text(_termsList[index].remarks.handleEmpty()),
                      isThreeLine: false,
                    ))
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
            if (_poOrderList[mainIndex].isHeader) return;
            if (_poOrderList.length - 1 == mainIndex) return;
            _poOrderList.forEach((e) => e.isViewing = false);
            _poOrderList[mainIndex].isViewing = true;
            _viewItem(_poOrderList[mainIndex]);
          },
          child: Container(
              width: 120,
              height: 48,
              color: _poOrderList[mainIndex].isHeader
                  ? AppColor.appRed
                  : _poOrderList[mainIndex].isViewing
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
                          _poOrderList[mainIndex].indentNo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _poOrderList[mainIndex].isHeader
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
          /// Catalog Item
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].catalogItem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// PartyItemName
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 110,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].partyItemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Quantity
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].quantity,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
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
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].rate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Discount Per
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].discountPer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Discount Rate
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].discountRate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Net Rate
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].netRate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].amount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Delv Date
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].delvDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
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
              color: _poOrderList[index].isHeader
                  ? AppColor.appRed
                  : _poOrderList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _poOrderList[index].status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _poOrderList[index].isHeader
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
  _getTotal(String type) {
    if (_poOrderList.isEmpty)
      return '0';
    else {
      var res = _poOrderList.where((element) => !element.isHeader);
      //  int count = 0;

      if (type == 'Qty') {
        double count = 0.0;
        res.forEach((element) {
          count += element.quantity.toDouble();
        });
        return count.toStringAsFixed(2);
      } else if (type == 'Amount') {
        double count = 0.0;
        res.forEach((element) {
          count += element.amount.toDouble();
        });
        return count.toStringAsFixed(2);
      }
    }
  }

  _viewItem(PoOrderListingModel model) {
    setState(() {
      _imageList.clear();
      _imageList.addAll(model.imageList!);

      _itemSoPartyController.text = model.soParty;
      _itemNameController.text = model.itemName;
      _itemAppByUidController.text = model.approvedByUid;
      _itemAppByController.text = model.approvedBy;
      _itemAppDateController.text = model.approvedDate;
    });
  }

  _fetchPoDetail() {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': widget.id};

    WebService.fromApi(AppConfig.getPurOrderDetail, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getPurOrderDetail:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              _companyController.text =
                  getString(data['company_detail'], 'name');
              _dateController.text = getString(data, 'order_date');
              _seriesController.text = getString(data, 'order_finyear');
              _noController.text = getString(data, 'order_no');
              _approvalByController.text =
                  getString(data['user_detail'], 'name');
              _remarksController.text = getString(data, 'remarks');
              _partyController.text = getString(data['party_name'], 'name');

              _imageBaseUrl = getString(resp, 'image_item_png_path');

              var terms = data['order_terms'] as List;

              _termsList
                  .addAll(terms.map((e) => TermsModel.parseEdit(e)).toList());

              var items = data['order_items'] as List;

              _poOrderList.clear();

              _poOrderList.addAll(
                  items.map((e) => PoOrderListingModel.fromJson(e)).toList());

              if (_poOrderList.isNotEmpty) {
                _poOrderList.insert(
                    0,
                    PoOrderListingModel(
                        isHeader: true,
                        indentNo: 'Indent No',
                        catalogItem: 'Catalog Item',
                        partyItemName: 'Party Item Name',
                        quantity: 'Quantity',
                        rate: 'Rate',
                        discountPer: 'Discount Per',
                        discountRate: 'Discount Rate',
                        netRate: 'Net Rate',
                        amount: 'Amount',
                        delvDate: 'Delv Date',
                        status: 'Status'));
                _poOrderList.add(PoOrderListingModel(
                  indentNo: 'Total',
                  quantity: _getTotal('Qty'),
                  amount: _getTotal('Amount'),
                ));
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

  @override
  void dispose() {
    _companyController.dispose();
    _dateController.dispose();
    _seriesController.dispose();
    _noController.dispose();
    _partyController.dispose();
    _approvalByController.dispose();
    _remarksController.dispose();
    _itemSoPartyController.dispose();
    _itemNameController.dispose();
    _itemAppByUidController.dispose();
    _itemAppByController.dispose();
    _itemAppDateController.dispose();
    super.dispose();
  }
}
