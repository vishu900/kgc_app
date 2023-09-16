import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/select_item/select_item.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/RegExInputFormatter.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'GateEntryItemModel.dart';
import 'doc_type_model.dart';

class GateEntry extends StatefulWidget {
  final GateEntryType gateEntryType;
  final String? compCode;
  final String? compName;
  final String? id;

  const GateEntry(
      {Key? key,
      this.id,
      this.compCode,
      this.compName,
      this.gateEntryType = GateEntryType.CHALLAN})
      : super(key: key);

  @override
  _GateEntryState createState() => _GateEntryState();
}

class _GateEntryState extends State<GateEntry> with NetworkResponse {
  Widget _height = SizedBox(height: 12);
  List<GateEntryItemModel> _itemList = [];

  final companyController = TextEditingController();
  final finYearController = TextEditingController();
  final docDateController = TextEditingController();
  final noController = TextEditingController();
  final partyController = TextEditingController();
  final docTypeController = TextEditingController();
  final remarksController = TextEditingController();

  String poNo = '';
  String indentNo = '';
  String jwOrderNo = '';
  String saleOrderNo = '';
  String partyOrderNo = '';
  String partyItemName = '';
  String saleOrderDate = '';
  String purchaseOrderNo = '';
  String partyName = '';

  String _screenTitle = '';
  String? compCode = '';
  String? docType = '';
  String? selectedPartyId = '';
  String _imageBaseUrl = '';
  int _current = 0;

  List<QCompanyModel> companyList = [];
  List<DocTypeModel> _docTypeList = [];
  List<DocTypeModel> _partyList = [];

  List<String?> _imageList = [];
  final numberReg = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  DateTime now = DateTime.now();

  @override
  void initState() {
    compCode = widget.compCode;
    _screenTitle = widget.gateEntryType == GateEntryType.CHALLAN
        ? 'Gate Challan'
        : 'Gate Entry';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    if (widget.id == null) {
      // _getCompanyList();
      _getDocType();

      finYearController.text = '${now.month}/${now.day}/${now.year}';

      if (now.month <= 4) {
        finYearController.text = '${now.year - 1}${now.year}';
      } else {
        finYearController.text = '${now.year}${now.year + 1}';
      }

      docDateController.text = now.format('dd/MM/yyyy');
      companyController.text = widget.compName!;
    } else {
      _getItemDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_screenTitle),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(12),
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
                onTap: _setDocDate,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Doc Date',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Doc No.
              TextFormField(
                controller: noController,
                readOnly: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Doc No',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Doc Type
              TextFormField(
                readOnly: true,
                controller: docTypeController,
                onTap: () =>
                    widget.id == null ? _docTypeBottomSheet(context) : null,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Doc Type',
                  suffixIcon:
                      widget.id == null ? Icon(Icons.arrow_drop_down) : null,
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

              /// Remarks
              TextFormField(
                readOnly: widget.id != null,
                controller: remarksController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
              ),

              Visibility(visible: widget.id == null, child: _height),

              Visibility(
                visible: widget.id == null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          clearFocus(context);
                          if (_guardParams()) {
                            var selectedData = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => SelectItem(
                                          compCode: compCode,
                                          docType: docType,
                                          partyId: selectedPartyId,
                                          userId: getUserId(),
                                        )));

                            if (selectedData == null) return;
                            if (selectedData.isEmpty) return;

                            var mList = selectedData['res'];

                            if (mList.isEmpty) return;

                            _itemList.clear();
                            _clearViewItem();
                            _imageBaseUrl = selectedData['baseUrl'].toString();

                            if (_itemList.isEmpty) {
                              String no = '';
                              String date = '';

                              if (widget.gateEntryType == GateEntryType.ENTRY) {
                                date = 'Bill Date';
                                no = 'Bill No';
                              } else {
                                date = 'Challan Date';
                                no = 'Challan No';
                              }

                              /// Header
                              _itemList.add(GateEntryItemModel(
                                  adj: 'Adj',
                                  bag: 'Bag',
                                  controller:
                                      TextEditingController(text: 'Bag'),
                                  billDate: date,
                                  billNo: no,
                                  billQty: 'Bill Qty',
                                  billQtyController:
                                      TextEditingController(text: 'Bill Qty'),
                                  billQtyUom: 'Uom',
                                  catalogCode: 'Catalog Code',
                                  partyItemName: 'Party Item Name',
                                  perPc: 'Per Pc',
                                  stockQuantity: 'Stock Quantity',
                                  stockQtyController: TextEditingController(
                                      text: 'Stock Quantity'),
                                  stockUom: 'UOM',
                                  isHeader: true));

                              _itemList.addAll(selectedData['res']);

                              /// Footer
                              _itemList.add(GateEntryItemModel(
                                  catalogCode: 'Total',
                                  bag: _getTotal('Bag'),
                                  controller: TextEditingController(
                                      text: _getTotal('Bag')),
                                  stockQuantity: _getTotal('StockQty'),
                                  stockQtyController: TextEditingController(
                                      text: _getTotal('StockQty')),
                                  billQty: _getTotal('BillQty'),
                                  billQtyController: TextEditingController(
                                      text: _getTotal('BillQty')),
                                  billNo: '',
                                  adj: '',
                                  perPc: ''));
                            } else {
                              var header = _itemList.first;
                              var footer = _itemList.last;

                              _itemList.removeAt(0);
                              _itemList.removeLast();

                              _itemList.insert(0, header);
                              _itemList.addAll(selectedData);
                              _itemList.add(footer);
                            }
                            setState(() {});
                          }
                        },
                        child: Text('Select Items')),
                  ],
                ),
              ),

              _height,

              /// Flexible Table
              Row(
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
              ),

              _height,
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
                              'ImageFull-> $_imageBaseUrl${_imageList[imgIndex]}.png ');
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(
                                '$_imageBaseUrl${_imageList[imgIndex]}.png'),
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

              _height,
              _height,

              /// Party Item Name
              TextFormField(
                controller: TextEditingController(text: partyItemName),
                readOnly: true,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Party Item Name',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Indent No
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: indentNo),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Indent No',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// PO No
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: purchaseOrderNo),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'PO No',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// JW Order No
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: jwOrderNo),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'JW Order No',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Party Name
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: partyName),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'PartyName',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Sale Order No
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: saleOrderNo),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Sale Order No',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Sale Order Date
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: saleOrderDate),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Sale Order Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Party Order no
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: partyOrderNo),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Party Order no',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,
              _height,

              Visibility(
                  visible: widget.id == null,
                  child: ElevatedButton(
                      onPressed: _isValidated, child: Text('Submit'))),
              Visibility(visible: widget.id == null, child: _height),
            ],
          ),
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
            if (_itemList[mainIndex].isHeader) return;
            if (_itemList.length - 1 == mainIndex) return;
            _itemList.forEach((e) => e.isViewing = false);
            _itemList[mainIndex].isViewing = true;
            _viewItem(_itemList[mainIndex]);
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
                      mainAxisAlignment: widget.id != null
                          ? MainAxisAlignment.center
                          : _getCheckBoxVisibility(mainIndex)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: widget.id != null
                              ? false
                              : _getCheckBoxVisibility(mainIndex),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _itemList.removeAt(mainIndex);
                                if (_itemList.length <= 2) {
                                  _itemList.clear();
                                  _clearViewItem();
                                } else {
                                  _updateCount();
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete),
                            ),
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
          /// Bill No
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
                    Expanded(
                      child: TextFormField(
                        readOnly: widget.id != null
                            ? true
                            : _itemList[index].isHeader ||
                                _itemList.length - 1 == index,
                        controller: TextEditingController(
                            text: _itemList[index].billNo),
                        textAlign: TextAlign.center,
                        validator: (v) =>
                            v!.isEmpty ? 'This field is required' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: 18,
                            color: _itemList[index].isHeader
                                ? Colors.white
                                : Colors.black),
                        onChanged: (v) {
                          _itemList[index].billNo = v;
                        },
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Visibility(
                        visible: _itemList[index].isHeader,
                        child: SizedBox(width: 6)),
                  ],
                ),
              ),
            ),
          ),

          /// Bill Date
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: GestureDetector(
              onTap: () {
                if (!_itemList[index].isHeader) {
                  _setItemDate(index);
                }
              },
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
                    _itemList[index].billDate,
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

          /// Bag
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
                child: TextFormField(
                  readOnly: widget.id != null
                      ? true
                      : _itemList[index].isHeader ||
                          _itemList.length - 1 == index,
                  controller: _itemList[index].controller,
                  textAlign: TextAlign.center,
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [numberReg],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                  onChanged: (v) {
                    _itemList[index].bag = v;
                    _itemList[index].controller!.text = v;
                    _itemList[index].controller!.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: _itemList[index].controller!.text.length));
                    _updateCount();
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),

          /// Stock Qty
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
                child: TextFormField(
                  readOnly: widget.id != null
                      ? true
                      : _itemList[index].isHeader ||
                          _itemList.length - 1 == index,
                  controller: _itemList[index].stockQtyController,
                  textAlign: TextAlign.center,
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [numberReg],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                  onChanged: (v) {
                    _itemList[index].stockQuantity = v;
                    _itemList[index].stockQtyController!.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: _itemList[index]
                                .stockQtyController!
                                .text
                                .length));
                    _updateCount();
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),

          /// Stock Uom
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

          /// Adj
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
                child: TextFormField(
                  readOnly: widget.id != null
                      ? true
                      : _itemList[index].isHeader ||
                          _itemList.length - 1 == index,
                  controller: TextEditingController(text: _itemList[index].adj),
                  textAlign: TextAlign.center,
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [numberReg],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                  onChanged: (v) {
                    _itemList[index].adj = v;
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),

          /// Per Pc
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
                child: TextFormField(
                  readOnly: widget.id != null
                      ? true
                      : _itemList[index].isHeader ||
                          _itemList.length - 1 == index,
                  controller:
                      TextEditingController(text: _itemList[index].perPc),
                  textAlign: TextAlign.center,
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                  onChanged: (v) {
                    _itemList[index].perPc = v;
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),

          /// Bill Qty
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
                child: TextFormField(
                  readOnly: widget.id != null
                      ? true
                      : _itemList[index].isHeader ||
                          _itemList.length - 1 == index,
                  controller: _itemList[index].billQtyController,
                  textAlign: TextAlign.center,
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [numberReg],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 18,
                      color: _itemList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                  onChanged: (v) {
                    _itemList[index].billQty = v;
                    _itemList[index].billQtyController!.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: _itemList[index]
                                .billQtyController!
                                .text
                                .length));
                    _updateCount();
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),

          /// Bill Qty Uom
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
                  _itemList[index].billQtyUom,
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
    if (_itemList.isEmpty) {
      return '0';
    } else {
      var res = _itemList.where((element) => !element.isHeader);
      double count = 0;
      if (type == 'Bag') {
        res.forEach((element) {
          count += element.bag.toDouble();
        });
        logIt('_getTotal-> ${_itemList.length} $type $count');
        return count.toStringAsFixed(2);
      } else if (type == 'StockQty') {
        res.forEach((element) {
          count += element.stockQuantity.toDouble();
        });
        logIt('_getTotal-> ${_itemList.length} $type $count');
        return count.toStringAsFixed(2);
      } else if (type == 'BillQty') {
        res.forEach((element) {
          count += element.billQty.toDouble();
        });
        logIt('_getTotal-> ${_itemList.length} $type $count');
        return count.toStringAsFixed(2);
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

  _updateCount() {
    _itemList.last.bag = '0';
    _itemList.last.stockQuantity = '0';
    _itemList.last.billQty = '0';

    _itemList.last.bag = _getTotal('Bag');
    _itemList.last.controller!.text = _itemList.last.bag;

    _itemList.last.stockQuantity = _getTotal('StockQty');
    _itemList.last.stockQtyController!.text = _itemList.last.stockQuantity;

    _itemList.last.billQty = _getTotal('BillQty');
    _itemList.last.billQtyController!.text = _itemList.last.billQty;

    setState(() {});
  }

  _viewItem(GateEntryItemModel model) {
    setState(() {
      poNo = model.poNo;
      indentNo = model.indentNo;
      jwOrderNo = model.jwOrderNo;
      saleOrderNo = model.saleOrderNo;
      partyItemName = model.partyItemName;
      saleOrderDate = model.saleOrderDate;
      purchaseOrderNo = model.purchaseOrderNo;
      partyOrderNo = model.partyOrderNo;
      partyName = model.partyName;
      _imageList.clear();
      _imageList.addAll(model.imageList!);
      // _imageBaseUrl=model.
      logIt('ImageList ${model.indentNo}');
    });
  }

  _clearViewItem() {
    setState(() {
      poNo = '';
      indentNo = '';
      jwOrderNo = '';
      saleOrderNo = '';
      partyItemName = '';
      saleOrderDate = '';
      purchaseOrderNo = '';
      partyOrderNo = '';
      partyName = '';
      _imageList.clear();
    });
  }

  getCompanyList() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  _getDocType() {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.gateEntryDocType, this, jsonBody)
        .callPostService(context);
  }

  _getEntryParties() {
    if (docType!.isEmpty || compCode!.isEmpty) return;

    setState(() {
      _itemList.clear();
      selectedPartyId = '';
      _partyList.clear();
      partyController.clear();
    });

    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': compCode,
      'doc_type': docType
    };
    WebService.fromApi(AppConfig.gateEntryParties, this, jsonBody)
        .callPostService(context);
  }

  void _setItemDate(int index) async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);
      if (selectedDate == null) return;
      setState(() {
        _itemList[index].billDate =
            DateFormat('dd MMM yyyy').format(selectedDate);
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  void _setDocDate() async {
    try {
      final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2001, 01, 01),
          lastDate: now);
      if (selectedDate == null) return;
      setState(() {
        docDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    } on Exception catch (e) {
      print("an Error occurred $e");
    }
  }

  _isValidated() {
    clearFocus(context);

    if (compCode!.isEmpty) {
      showAlert(context, 'Please Select Company', 'Error');
    } else if (noController.text.trim().isEmpty) {
      showAlert(context, 'Please Enter Doc No', 'Error');
    } else if (docType!.isEmpty) {
      showAlert(context, 'Please Select Doc Type', 'Error');
    } else if (selectedPartyId!.isEmpty) {
      showAlert(context, 'Please Select Party', 'Error');
    } else {
      String str = widget.gateEntryType == GateEntryType.ENTRY
          ? 'Bill No'
          : 'Challan No';

      /// Challan No / Bill No
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].billNo.isEmpty ||
              _itemList[i].billNo.trim() == '0') {
            showAlert(context, 'Please Enter $str at row $i', 'Error');
            return;
          }
        }
      }

      /*/// Bag
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].bag.isEmpty || _itemList[i].bag.trim()=='0') {
            showAlert(context, 'Please Enter Bag at row $i', 'Error');
            return;
          }
        }
      }*/

      /// Stock Quantity
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].stockQuantity.isEmpty ||
              _itemList[i].stockQuantity.trim() == '0') {
            showAlert(
                context, 'Please Enter Stock Quantity at row $i', 'Error');
            return;
          }
        }
      }

      /* /// Adj
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].adj.isEmpty || _itemList[i].adj.trim()=='0') {
            showAlert(context, 'Please Enter Adj at row $i', 'Error');
            return;
          }
        }
      }*/

      /*/// Per PC
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].perPc.isEmpty || _itemList[i].perPc.trim()=='0') {
            showAlert(context, 'Please Enter Per Pc at row $i', 'Error');
            return;
          }
        }
      }*/

      /// Bill Qty
      for (int i = 0; i < _itemList.length; i++) {
        if (i != 0 && i != _itemList.length - 1) {
          if (_itemList[i].billQty.isEmpty ||
              _itemList[i].billQty.trim() == '0') {
            showAlert(context, 'Please Enter Bill Qty at row $i', 'Error');
            return;
          }
        }
      }

      _submit();
    }
  }

  _submit() {
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
      'doc_type_fk': _getCommaSepValues('DocFk'),
      'stk_qty': _getCommaSepValues('StockQty'),
      'stk_qty_uom': _getCommaSepValues('StockQtyUom'),
      'fin_qty': _getCommaSepValues('FinQty'),
      'fin_qty_uom': _getCommaSepValues('FinQtyUom'),
      'fin_qty_adj': _getCommaSepValues('FinQtyAdj'),
      'bags': _getCommaSepValues('Bags'),
      'weight_pp': '',
      'lot_no': '',
      'cone_tag': '',
    };

    if (widget.gateEntryType == GateEntryType.ENTRY) {
      Map entryBody = {
        'bill_no': _getCommaSepValues('BillNo'),
        'bill_date': _getCommaSepValues('BillDate'),
        'chl_no': _getCommaSepValues(''),
        'chl_date': _getCommaSepValues(''),
      };

      jsonBody.addAll(entryBody);
    } else {
      Map challanBody = {
        'chl_no': _getCommaSepValues('ChallanNo'),
        'chl_date': _getCommaSepValues('ChallanDate'),
        'bill_no': _getCommaSepValues(''),
        'bill_date': _getCommaSepValues('')
      };

      jsonBody.addAll(challanBody);
    }

    logIt('OnSubmit-> $jsonBody');

    WebService.fromApi(AppConfig.gateEntrySave, this, jsonBody)
        .callPostService(context);
  }

  // ignore: missing_return
  String? _getCommaSepValues(String type) {
    var header = _itemList.removeAt(0);
    var footer = _itemList.removeLast();

    switch (type) {
      case 'StockQty':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.stockQuantity}';
            } else {
              data = "$data,${e.stockQuantity}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      //  break;

      case 'StockQtyUom':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.stockUomCode}';
            } else {
              data = "$data,${e.stockUomCode}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'FinQty':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.billQty}';
            } else {
              data = "$data,${e.billQty}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'FinQtyUom':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.billQtyUomCode}';
            } else {
              data = "$data,${e.billQtyUomCode}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'FinQtyAdj':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.adj}';
            } else {
              data = "$data,${e.adj}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'Bags':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.bag}';
            } else {
              data = "$data,${e.bag}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'ChallanNo':
      case 'BillNo':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.billNo}';
            } else {
              data = "$data,${e.billNo}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'ChallanDate':
      case 'BillDate':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data =
                  '${e.billDate.toDateTime(format: 'dd MMM yyyy').format('yyyy-MM-dd')}';
            } else {
              data =
                  "$data,${e.billDate.toDateTime(format: 'dd MMM yyyy').format('yyyy-MM-dd')}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      case 'DocFk':
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '${e.id}';
            } else {
              data = "$data,${e.id}";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
      // break;

      default:
        {
          var data;

          _itemList.forEach((e) {
            if (data == null) {
              data = '';
            } else {
              data = "$data,";
            }
          });
          _itemList.insert(0, header);
          _itemList.add(footer);
          return data;
        }
    }
  }

  _getItemDetail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': widget.id //52183
    };

    WebService.fromApi(AppConfig.getGateEntryDetail, this, jsonBody)
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

        case AppConfig.gateEntryDocType:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              _docTypeList.clear();

              _docTypeList.addAll(
                  content.map((e) => DocTypeModel.fromJson(e)).toList());

              logIt('GateEntryDocType-> ${_docTypeList.length}');
              setState(() {});
            }
          }
          break;

        case AppConfig.gateEntryParties:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              noController.text = getString(data, 'doc_no');

              _partyList.clear();

              _partyList.addAll(
                  content.map((e) => DocTypeModel.parseParty(e)).toList());

              setState(() {});
            }
          }
          break;

        case AppConfig.gateEntrySave:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                popIt(context);
              });
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.getGateEntryDetail:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              companyController.text = getString(data['company_name'], 'name');
              finYearController.text = getString(data, 'doc_finyear');
              docDateController.text = getString(data, 'doc_date');
              noController.text = getString(data, 'doc_no');
              docTypeController.text = getString(data['doc_name'], 'name');
              partyController.text = getString(data['party_name'], 'name');
              remarksController.text = getString(data, 'remarks');

              _imageBaseUrl = getString(resp, 'image_item_png_path');

              bool isProd = getString(data, 'ge_doc_type_fk') == '1';

              var orderItems = data['order_items'] as List;

              _itemList.clear();

              _itemList.addAll(orderItems
                  .map((e) => GateEntryItemModel.parseDetail(e, isProd))
                  .toList());

              if (_itemList.isNotEmpty) {
                String no = '';
                String date = '';

                if (widget.gateEntryType == GateEntryType.ENTRY) {
                  date = 'Bill Date';
                  no = 'Bill No';
                } else {
                  date = 'Challan Date';
                  no = 'Challan No';
                }

                /// Header
                _itemList.insert(
                    0,
                    GateEntryItemModel(
                        adj: 'Adj',
                        bag: 'Bag',
                        controller: TextEditingController(text: 'Bag'),
                        billDate: date,
                        billNo: no,
                        billQty: 'Bill Qty',
                        billQtyController:
                            TextEditingController(text: 'Bill Qty'),
                        billQtyUom: 'Uom',
                        catalogCode: 'Catalog Code',
                        partyItemName: 'Party Item Name',
                        perPc: 'Per Pc',
                        stockQuantity: 'Stock Quantity',
                        stockQtyController:
                            TextEditingController(text: 'Stock Quantity'),
                        stockUom: 'UOM',
                        isHeader: true));

                /// Footer
                _itemList.add(GateEntryItemModel(
                    catalogCode: 'Total',
                    bag: _getTotal('Bag'),
                    controller: TextEditingController(text: _getTotal('Bag')),
                    stockQuantity: _getTotal('StockQty'),
                    stockQtyController:
                        TextEditingController(text: _getTotal('StockQty')),
                    billQty: _getTotal('BillQty'),
                    billQtyController:
                        TextEditingController(text: _getTotal('BillQty')),
                    billNo: '',
                    adj: '',
                    perPc: ''));
              }

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err, $stack');
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
                  _getEntryParties();
                },
              ),
              itemCount: companyList.length,
            ),
          );
        });
  }

  _docTypeBottomSheet(context) {
    logIt('docTYpeListCount -> ${_docTypeList[0].docType}');

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
                enabled: _docTypeList[index].id != '18',
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_docTypeList[index].docType!),
                ),
                trailing: Text(_docTypeList[index].id!),
                onTap: () {
                  popIt(context);
                  docTypeController.text = _docTypeList[index].docType!;
                  docType = _docTypeList[index].id;
                  _getEntryParties();
                },
              ),
              itemCount: _docTypeList.length,
            ),
          );
        });
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
                      return _getFilteredList(pattern);
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

  _getFilteredList(String str) {
    return _partyList
        .where((i) => i.docType!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  bool _guardParams() {
    if (compCode!.isEmpty) {
      showAlert(context, 'Please select company', 'Error');
      return false;
    } else if (docType!.isEmpty) {
      showAlert(context, 'Please select doc type', 'Error');
      return false;
    } else if (selectedPartyId!.isEmpty) {
      showAlert(context, 'Please select party', 'Error');
      return false;
    } else
      return true;
  }

  @override
  void dispose() {
    super.dispose();
    companyController.dispose();
    finYearController.dispose();
    docDateController.dispose();
    noController.dispose();
    partyController.dispose();
    docTypeController.dispose();
    remarksController.dispose();

    _itemList.forEach((element) {
      if (element.controller != null) element.controller!.dispose();
    });
  }
}

enum GateEntryType { ENTRY, CHALLAN }
