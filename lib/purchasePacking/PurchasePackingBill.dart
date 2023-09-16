import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
//import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/UomModel.dart';
import 'package:dataproject2/datamodel/UserModel.dart';
import 'package:dataproject2/gateEntry/doc_type_model.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/purchasePacking/GodownModel.dart';
import 'package:dataproject2/purchasePacking/PurPackItemModel.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

import 'PurchasePackagingBillModel.dart';
import 'StockDetailModel.dart';
import 'purchase_packing_select_item.dart';

class PurchasePackingBill extends StatefulWidget {
  final String? id;
  final PurPackType? purPackType;
  final String? compCode;
  final String? compName;
  final String? logo;
  final String? imageBaseUrl;
  const PurchasePackingBill(
      {Key? key,
      this.id,
      this.purPackType = PurPackType.Bill,
      this.compCode,
      this.compName,
      this.logo,
      this.imageBaseUrl})
      : super(key: key);

  @override
  _PurchasePackingBillState createState() => _PurchasePackingBillState();
}

class _PurchasePackingBillState extends State<PurchasePackingBill>
    with NetworkResponse {
  Widget _height = SizedBox(height: 12);

  final companyController = TextEditingController();
  final finYearController = TextEditingController();
  final docDateController = TextEditingController();
  final noController = TextEditingController();
  final partyController = TextEditingController();
  final partyItemController = TextEditingController();
  final gateSrNoController = TextEditingController();
  final dateController = TextEditingController();
  final billNoController = TextEditingController();
  final billDateController = TextEditingController();
  final godownController = TextEditingController();
  final itemCodeController = TextEditingController();
  final catalogCodeController = TextEditingController();
  final stockQtyController = TextEditingController();
  final billQtyController = TextEditingController();
  final remarksController = TextEditingController();
  final qualityController = TextEditingController();
  final quantityController = TextEditingController();

  final lotNoController = TextEditingController();
  final rollNoController = TextEditingController();
  final itemStockQtyController = TextEditingController();
  final itemStockQtyUomController = TextEditingController();
  final itemBillQtyController = TextEditingController();
  final itemBillQtyUomController = TextEditingController();

  List<PurchasePackagingBillModel> _stockList = [];
  GlobalKey<FormState> _formKey = GlobalKey();
  List<QCompanyModel> companyList = [];
  List<UserModel> _userList = [];
  List<GodownModel> _godownList = [];
  List<DocTypeModel> _partyList = [];
  List<UomModel> uomList = [];
  List<String?> _imageList = [];
  List<StockDetailModel> _stockDetailList = [];

  String? compCode = '';
  String? selectedGodownId = '';
  String? selectedQntyApprovalId = '';
  String? selectedQualApprovalId = '';
  String? selectedPartyId = '';
  String? docType = '';
  String? imageBaseUrl = '';
  String? selectedStockUomCode = '';
  String? selectedBillUomCode = '';
  String? itemId = '';
  int _current = 0;

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    logIt('PurPackBill-> ${widget.compName}');

    if (widget.id == null) {
      // _getCompanyList();
      _getPackingOptions();
      _getUom();

      final now = DateTime.now();

      finYearController.text = '${now.month}/${now.day}/${now.year}';

      if (now.month < 4) {
        finYearController.text = '${now.year - 1}${now.year}';
      } else {
        finYearController.text = '${now.year}${now.year + 1}';
      }

      docDateController.text = now.format('dd/MM/yyyy');
      compCode = widget.compCode;
      companyController.text = widget.compName!;
    } else {
      _getBillDetail();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text(widget.purPackType == PurPackType.Bill
                ? 'Purchase Packing Bill'
                : 'Purchase Packing Challan')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              /// Company
              TextFormField(
                readOnly: true,
                controller: companyController,
                // onTap: () => widget.id == null ? _companyBottomSheet(context) : null,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Company',
                  // suffixIcon: widget.id == null ? Icon(Icons.arrow_drop_down) : null,
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Fin Year
              TextFormField(
                readOnly: true,
                controller: finYearController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Fin Year',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Doc Date
              TextFormField(
                readOnly: true,
                controller: docDateController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Doc Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// No.
              TextFormField(
                readOnly: true,
                controller: noController,
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
                controller: partyController,
                onTap: () => widget.id == null ? _getPartySheet(context) : null,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Party',
                  suffixIcon:
                      widget.id == null ? Icon(Icons.arrow_drop_down) : null,
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Party Item Name
              TextFormField(
                readOnly: true,
                controller: partyItemController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Party Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Gate Sr No.
              TextFormField(
                readOnly: true,
                controller: gateSrNoController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Gate Sr No.',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Date
              TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill no.
              TextFormField(
                readOnly: true,
                controller: billNoController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill no',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill Date
              TextFormField(
                readOnly: true,
                controller: billDateController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Godown
              TextFormField(
                readOnly: true,
                controller: godownController,
                onTap: () =>
                    widget.id == null ? _getGodownsSheet(context) : null,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Godown',
                  suffixIcon:
                      widget.id == null ? Icon(Icons.arrow_drop_down) : null,
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Item Code
              TextFormField(
                readOnly: true,
                controller: itemCodeController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Item Code',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Catalog Code
              TextFormField(
                readOnly: true,
                controller: catalogCodeController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Catalog Code',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Stock Qty
              TextFormField(
                readOnly: true,
                controller: stockQtyController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Stock Qty',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill Qty
              TextFormField(
                readOnly: true,
                controller: billQtyController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill Qty',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Remarks
              TextFormField(
                controller: remarksController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Quality Approval By
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: qualityController,
                      onTap: () => widget.id == null
                          ? _getQualApproveSheet(context)
                          : null,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Quality Approval By',
                        suffixIcon: widget.id == null
                            ? Icon(Icons.arrow_drop_down)
                            : null,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: qualityController.text.isNotEmpty,
                      child: SizedBox(width: 8)),
                  Visibility(
                      visible: qualityController.text.isNotEmpty,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              qualityController.clear();
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: AppColor.appRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.clear,
                                  size: 14, color: Colors.white)))),
                ],
              ),
              _height,

              /// Quantity Approval By
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: quantityController,
                      onTap: () => widget.id == null
                          ? _getQntyApproveSheet(context)
                          : null,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Quantity Approval By',
                        suffixIcon: widget.id == null
                            ? Icon(Icons.arrow_drop_down)
                            : null,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: quantityController.text.isNotEmpty,
                      child: SizedBox(width: 8)),
                  Visibility(
                      visible: quantityController.text.isNotEmpty,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              quantityController.clear();
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: AppColor.appRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.clear,
                                  size: 14, color: Colors.white)))),
                ],
              ),
              _height,

              Visibility(
                visible: widget.id == null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (compCode!.isEmpty) {
                            showAlert(
                                context, 'Please select Company', 'Error');
                          } else if (selectedPartyId!.isEmpty) {
                            showAlert(context, 'Please select Party', 'Error');
                          } else {
                            var res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PurchasePackingSelectItem(
                                          compCode: compCode,
                                          partyId: selectedPartyId,
                                          type: widget.purPackType,
                                        )));

                            logIt('Result is-> $res');

                            if (res != null) {
                              imageBaseUrl = res['baseUrl'];
                              _setData(res['list']);
                            }
                          }
                        },
                        child: Text('Select Items'))
                  ],
                ),
              ),
              _height,

              /// Item Image
              Container(
                width: 100.0.h,
                height: 36.0.h,
                child: _imageList.isNotEmpty
                    ? PhotoViewGallery.builder(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int imgIndex) {
                          _current = imgIndex;
                          logIt(
                              'ImageIs-> $imageBaseUrl${_imageList[imgIndex]}.png');
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(
                                '$imageBaseUrl${_imageList[imgIndex]}.png'),
                            initialScale:
                                PhotoViewComputedScale.contained * 0.8,
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
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == mIndex
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),

              /// Flexible Table
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildCells(_stockList.length),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(_stockList.length),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(visible: widget.id != null, child: _height),

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _stockDetailList.length,
                  itemBuilder: (context, index) => Card(
                        child: Table(
                          children: [
                            /// Lot No
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Lot no'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_stockDetailList[index].lotNo!),
                              )
                            ]),

                            /// Roll No
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Roll no'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_stockDetailList[index].rollNo!),
                              )
                            ]),

                            /// Stock Qty
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Stock Qty'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${_stockDetailList[index].stockQty} ${_stockDetailList[index].stockQtyUom}'),
                              )
                            ]),

                            /// Bill Qty
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Bill Qty'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${_stockDetailList[index].billQty} ${_stockDetailList[index].billQtyUom}'),
                              )
                            ])
                          ],
                        ),
                      )),

              Visibility(visible: widget.id == null, child: _height),

              Visibility(
                visible: widget.id == null,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Lot No
                      TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Lot No',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        controller: lotNoController,
                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) =>
                            val!.isEmpty ? 'This field is required' : null,
                      ),
                      _height,

                      /// Roll No
                      TextFormField(
                        controller: rollNoController,
                        textInputAction: TextInputAction.next,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) =>
                            val!.isEmpty ? 'This field is required' : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Roll No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      _height,

                      /// Stock Qty
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58.0.w,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              //  autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: itemStockQtyController,
                              validator: (val) => val!.isEmpty
                                  ? 'This field is required'
                                  : null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Stock Qty',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),

                          /// Stock Qty Uom
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: itemStockQtyUomController,
                              onTap: () => _uomBottomSheet(context, 'Stock'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (val) => val!.isEmpty
                                  ? 'This field is required'
                                  : null,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                isDense: true,
                                labelText: 'Uom',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _height,

                      /// Bill Qty
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58.0.w,
                            child: TextFormField(
                              controller: itemBillQtyController,
                              textInputAction: TextInputAction.next,
                              // autovalidateMode:  AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.isEmpty
                                  ? 'This field is required'
                                  : null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Bill Qty',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          SizedBox(width: 8),

                          /// Bill Qty Uom
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: itemBillQtyUomController,
                              //   autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.isEmpty
                                  ? 'This field is required'
                                  : null,
                              onTap: () => _uomBottomSheet(context, 'Bill'),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                isDense: true,
                                labelText: 'Uom',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _height,
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: widget.id == null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            clearFocus(context);

                            setState(() {
                              if (_stockList.isEmpty) {
                                _stockList.add(PurchasePackagingBillModel(
                                    billQty: 'Bill Qty',
                                    billUom: 'Uom',
                                    lotNo: 'Lot No',
                                    rollNo: 'Roll No',
                                    stockUom: 'Uom',
                                    stockQty: 'Stock Qty',
                                    isHeader: true));
                                _stockList.add(PurchasePackagingBillModel(
                                    id: '',
                                    lotNo: lotNoController.text,
                                    rollNo: rollNoController.text,
                                    stockQty: itemStockQtyController.text,
                                    stockUom: itemStockQtyUomController.text,
                                    stockUomCode: selectedStockUomCode,
                                    billUomCode: selectedBillUomCode,
                                    billQty: itemBillQtyController.text,
                                    billUom: itemBillQtyUomController.text));
                              } else {
                                _stockList.add(PurchasePackagingBillModel(
                                  id: '',
                                  lotNo: lotNoController.text,
                                  rollNo: rollNoController.text,
                                  stockQty: itemStockQtyController.text,
                                  stockUom: itemStockQtyUomController.text,
                                  billQty: itemBillQtyController.text,
                                  billUom: itemBillQtyUomController.text,
                                  stockUomCode: selectedStockUomCode,
                                  billUomCode: selectedBillUomCode,
                                ));
                              }

                              lotNoController.clear();
                              rollNoController.clear();
                              itemStockQtyController.clear();
                              itemStockQtyUomController.clear();
                              itemBillQtyController.clear();
                              itemBillQtyUomController.clear();
                              selectedStockUomCode = '';
                              selectedBillUomCode = '';
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text('Add', style: TextStyle(fontSize: 17)),
                          ],
                        )),
                  ],
                ),
              ),

              Visibility(visible: widget.id == null, child: _height),

              Visibility(
                visible: widget.id == null,
                child: ElevatedButton(
                    onPressed: () {
                      _validate();
                    },
                    child: Text('Submit')),
              ),

              Visibility(visible: widget.id == null, child: _height),
            ],
          ),
        ),
      ),
    );
  }

  /// type-> BillQty, StockQty
  getTotal(String type) {
    if (_stockList.isEmpty)
      return '0';
    else {
      var res = _stockList.where((element) => !element.isHeader);
      int count = 0;
      if (type == 'StockQty') {
        res.forEach((element) {
          count += element.stockQty.toInt();
        });
        return count.toString();
      } else if (type == 'BillQty') {
        res.forEach((element) {
          count += element.billQty.toInt();
        });
        return count.toString();
      }
    }
  }

  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 150,
            height: 48,
            color: _stockList[mainIndex].isHeader
                ? AppColor.appRed
                : _stockList[mainIndex].isViewing
                    ? AppColor.appRed[500]
                    : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: _getActionVisibility(mainIndex)
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      /// Delete
                      Visibility(
                        visible: _getActionVisibility(mainIndex),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                _stockList.removeAt(mainIndex);
                                if (_stockList.length == 1) _stockList.clear();
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.all(6),
                                child: Icon(Icons.delete))),
                      ),

                      Text(
                        _stockList[mainIndex].lotNo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: _stockList[mainIndex].isHeader
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            )),
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
          /// Roll No
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _stockList[index].isHeader
                  ? AppColor.appRed
                  : _stockList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _stockList[index].rollNo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _stockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Stock Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _stockList[index].isHeader
                  ? AppColor.appRed
                  : _stockList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _stockList[index].stockQty,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 18,
                      color: _stockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Stock Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _stockList[index].isHeader
                  ? AppColor.appRed
                  : _stockList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _stockList[index].stockUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _stockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Bill Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _stockList[index].isHeader
                  ? AppColor.appRed
                  : _stockList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _stockList[index].billQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _stockList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Bill Qty Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _stockList[index].isHeader
                  ? AppColor.appRed
                  : _stockList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _stockList[index].billUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _stockList[index].isHeader
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

  _getActionVisibility(int index) {
    if (_stockList[index].isHeader) {
      return false;
    } else if (index == _stockList.length - 1) {
      return true;
    } else
      return true;
  }

  getCompanyList() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  _getPackingOptions() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.packingOptions, this, jsonBody)
        .callPostService(context);
  }

  _getParties() {
    Map jsonBody = {'user_id': getUserId(), 'comp_code': compCode};
    WebService.fromApi(AppConfig.packingParties, this, jsonBody)
        .callPostService(context);
  }

  _getUom() {
    Map jsonBody = {'user_id': getUserId(), 'table_name': 'UOM_MASTER'};

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _setData(PurPackItemModel? res) {
    if (res == null) return;

    var obj = res;

    gateSrNoController.text = obj.gateSrNo!;
    dateController.text = obj.gateSrdate!;
    billNoController.text = obj.billNo!;
    billDateController.text = obj.billDate!;
    stockQtyController.text = obj.stockQty!;
    billQtyController.text = obj.billQty!;
    itemCodeController.text = obj.itemCode!;
    catalogCodeController.text = obj.catalogCode!;
    partyItemController.text = obj.itemName!;

    itemStockQtyUomController.text = obj.uom!;
    selectedStockUomCode = obj.uomCode;
    itemBillQtyUomController.text = obj.uom!;
    selectedBillUomCode = obj.uomCode;
    docType = obj.docType;
    itemId = obj.id;

    _imageList.clear();
    _imageList.addAll(obj.imageList!);

    setState(() {});
  }

  _validate() {
    if (compCode!.isEmpty) {
      showAlert(context, 'Please Select Company', 'Error');
    } else if (selectedPartyId!.isEmpty) {
      showAlert(context, 'Please Select Party', 'Error');
    } else if (gateSrNoController.text.isEmpty) {
      showAlert(context, 'Please enter Gate Serial No', 'Error');
    } else if (dateController.text.isEmpty) {
      showAlert(context, 'Please enter Gate Date', 'Error');
    } else if (selectedGodownId!.isEmpty) {
      showAlert(context, 'Please Select Godown', 'Error');
    } else if (itemId!.isEmpty) {
      showAlert(context, 'Please enter ItemId', 'Error');
    } else if (catalogCodeController.text.isEmpty) {
      showAlert(context, 'Please enter Catalog', 'Error');
    } else if (stockQtyController.text.isEmpty) {
      showAlert(context, 'Please enter Stock Qty', 'Error');
    } else if (billQtyController.text.isEmpty) {
      showAlert(context, 'Please enter Bill Qty', 'Error');
    } else if (selectedQualApprovalId!.isEmpty) {
      showAlert(context, 'Please Select Quality Approval By', 'Error');
    } else if (selectedQntyApprovalId!.isEmpty) {
      showAlert(context, 'Please Select Quantity Approval By', 'Error');
    } else if (_stockList.isEmpty) {
      showAlert(context, 'Please enter stock details', 'Error');
    } else {
      _submitPurPackBill();
    }
  }

  _submitPurPackBill() {
    Map jsonBody = {
      'user_id': getUserId(),
      'acc_code': selectedPartyId,
      'comp_code': compCode,
      'doc_type': docType,
      'doc_date': docDateController.text
          .toDateTime(format: 'dd/MM/yyyy')
          .format('yyyy-MM-dd'),
      'doc_no': noController.text,
      'doc_finyear': finYearController.text,
      'godown_code': selectedGodownId,
      'gate_entry_dtl_pk': itemId,
      'qty_approval_uid': selectedQntyApprovalId,
      'qlty_approval_uid': selectedQualApprovalId,
      'remarks': remarksController.text,
      'lot_no': _getCommaSepValue('LotNo'),
      'roll_no': _getCommaSepValue('RollNo'),
      'stk_qty': _getCommaSepValue('StockQty'),
      'stk_qty_uom': _getCommaSepValue('StockQtyUom'),
      'fin_qty': _getCommaSepValue('BillQty'),
      'fin_qty_uom': _getCommaSepValue('BillQtyUom'),
    };

    WebService.fromApi(AppConfig.packingSave, this, jsonBody)
        .callPostService(context);
  }

  _getCommaSepValue(String type) {
    var header = _stockList.removeAt(0);

    switch (type) {
      case 'LotNo':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.lotNo}';
            } else {
              data = "$data,${e.lotNo}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      //  break;

      case 'RollNo':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.rollNo}';
            } else {
              data = "$data,${e.rollNo}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      // break;

      case 'StockQty':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.stockQty}';
            } else {
              data = "$data,${e.stockQty}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      // break;

      case 'StockQtyUom':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.stockUomCode}';
            } else {
              data = "$data,${e.stockUomCode}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      // break;

      case 'BillQty':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.billQty}';
            } else {
              data = "$data,${e.billQty}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      // break;

      case 'BillQtyUom':
        {
          var data;
          _stockList.forEach((e) {
            if (data == null) {
              data = '${e.billUomCode}';
            } else {
              data = "$data,${e.billUomCode}";
            }
          });
          _stockList.insert(0, header);
          return data;
        }
      // break;
    }
  }

  _getBillDetail() {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': widget.id};

    WebService.fromApi(AppConfig.getPackingDetail, this, jsonBody)
        .callPostService(context);
  }

  @override
  onResponse({Key? key, String? requestCode, String? response}) {
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

        case AppConfig.packingOptions:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var godowns = data['godowns'] as List;
              var users = data['users'] as List;

              _userList.clear();
              _godownList.clear();

              _godownList
                  .addAll(godowns.map((e) => GodownModel.fromJson(e)).toList());
              _userList
                  .addAll(users.map((e) => UserModel.parseUser(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.packingParties:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              noController.text = getString(data, 'doc_no');

              var content = data['content'] as List;

              _partyList.clear();

              _partyList.addAll(
                  content.map((e) => DocTypeModel.fromJson(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.searchItemParameters:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              uomList.clear();
              uomList.addAll(
                  contentList.map((e) => UomModel.fromJSON(e)).toList());

              debugPrint('uomList ${uomList.length}');

              setState(() {});
            }
          }
          break;

        case AppConfig.packingSave:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              logIt('AppConfig.packingSave-> $data');
              showAlert(context, data['message'], 'Success', onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.getPackingDetail:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              companyController.text = getString(data['company_name'], 'name');
              finYearController.text = getString(data, 'doc_finyear');
              docDateController.text = getString(data, 'doc_date');
              noController.text = getString(data, 'doc_no');
              partyController.text = getString(data['party_name'], 'name');

              var geList = data['gate_entry_detail']['entry_hdr'] as List;

              var obj = {};

              if (geList.isNotEmpty) obj = geList[0];

              gateSrNoController.text = getString(obj, 'doc_no');
              dateController.text = getString(obj, 'doc_date');
              billNoController.text =
                  getString(data['gate_entry_detail'], 'bill_no');
              billDateController.text =
                  getString(data['gate_entry_detail'], 'bill_date');
              godownController.text = getString(data['godown_name'], 'name');
              itemCodeController.text = getString(
                  data['gate_entry_detail']['po_item_detail']
                      ['indent_item_single'],
                  'item_code');
              catalogCodeController.text = getString(data, 'catalog_code');
              stockQtyController.text =
                  getString(data['gate_entry_detail'], 'stk_qty');
              billQtyController.text =
                  getString(data['gate_entry_detail'], 'fin_qty');
              remarksController.text = getString(data, 'remarks');
              qualityController.text =
                  getString(data['qlty_approval_username'], 'name');
              quantityController.text =
                  getString(data['qty_approved_username'], 'name');

              var imgList = data['item_images'] as List;

              imageBaseUrl = getString(resp, 'image_item_png_path');

              _imageList.clear();
              imgList.forEach((element) {
                _imageList.add(element['code_pk']);
              });

              var stockItems = data['packing_items'] as List;

              _stockDetailList.clear();

              _stockDetailList.addAll(
                  stockItems.map((e) => StockDetailModel.fromJson(e)).toList());

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
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
                  companyController.text = companyList[index].name!;
                  compCode = companyList[index].id;
                  _getParties();
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  _getGodownsSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<GodownModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select Godown' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                        trailing: Text(itemData.id!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      godownController.text = sg.name!;
                      selectedGodownId = sg.id;
                      setState(() {});
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: godownController,
                        onChanged: (string) {
                          selectedGodownId = '';
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Godown',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getFilteredList(String str) {
    return _godownList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getQntyApproveSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<UserModel>(
                    validator: (value) => value!.isEmpty
                        ? 'Please select Quantity Approved By'
                        : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                        trailing: Text(itemData.id!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      quantityController.text = sg.name!;
                      selectedQntyApprovalId = sg.id;
                      setState(() {});
                    },
                    suggestionsCallback: (String pattern) {
                      return _getQntyAppList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: quantityController,
                        onChanged: (string) {
                          selectedQntyApprovalId = '';
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Quantity Approval user',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getQualApproveSheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<UserModel>(
                    validator: (value) => value!.isEmpty
                        ? 'Please select Quality Approved By'
                        : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.name!),
                        trailing: Text(itemData.id!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      qualityController.text = sg.name!;
                      selectedQualApprovalId = sg.id;
                      setState(() {});
                    },
                    suggestionsCallback: (String pattern) {
                      return _getQntyAppList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: qualityController,
                        onChanged: (string) {
                          selectedQualApprovalId = '';
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Quality Approval user',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getQntyAppList(String str) {
    return _userList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getPartySheet(context) {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<DocTypeModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select party name' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(itemData.docType!),
                        trailing: Text(itemData.id!),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      Navigator.of(context).pop();
                      partyController.text = sg.docType!;
                      selectedPartyId = sg.id;
                      setState(() {});
                    },
                    suggestionsCallback: (String pattern) {
                      return _getPartyList(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        controller: partyController,
                        onChanged: (string) {
                          selectedPartyId = '';
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            //border: OutlineInputBorder(),
                            hintText: 'Party',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getPartyList(String str) {
    return _partyList
        .where((i) => i.docType!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  void _uomBottomSheet(BuildContext context, String type) {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: uomList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  selectedTileColor: AppColor.appRed[500],
                  title: Text(uomList[index].abbreviation!,
                      style: TextStyle(fontSize: 16)),
                  subtitle: Text(uomList[index].name!),
                  onTap: () {
                    Navigator.pop(context);

                    if (type == 'Stock') {
                      itemStockQtyUomController.text =
                          uomList[index].abbreviation!;
                      selectedStockUomCode = uomList[index].id;
                    } else if (type == 'Bill') {
                      itemBillQtyUomController.text =
                          uomList[index].abbreviation!;
                      selectedBillUomCode = uomList[index].id;
                    }

                    logIt(
                        'UomSelection-> $type id-> $selectedStockUomCode,$selectedBillUomCode');

                    setState(() {});
                  },
                );
              },
            ),
          ));
        });
  }

  @override
  void dispose() {
    companyController.dispose();
    finYearController.dispose();
    docDateController.dispose();
    partyController.dispose();
    noController.dispose();
    gateSrNoController.dispose();
    dateController.dispose();
    billNoController.dispose();
    billDateController.dispose();
    godownController.dispose();
    itemCodeController.dispose();
    catalogCodeController.dispose();
    stockQtyController.dispose();
    billQtyController.dispose();
    remarksController.dispose();
    qualityController.dispose();
    quantityController.dispose();
    lotNoController.dispose();
    rollNoController.dispose();
    itemStockQtyController.dispose();
    itemStockQtyUomController.dispose();
    itemBillQtyController.dispose();
    itemBillQtyUomController.dispose();
    super.dispose();
  }
}

enum PurPackType { Bill, Challan }
