import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/gateEntry/gateEntry.dart';
import 'package:dataproject2/imageEditor/ImageEditor.dart';
import 'package:dataproject2/indent/indentOrder.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/purchaseOrder/PoOrderListing.dart';
import 'package:dataproject2/purchasePacking/PurchasePackingBill.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'PurchaseBillApprovalModel.dart';
import 'package:sizer/sizer.dart';

import 'pur_bill_image_viewer.dart';

class PurchaseBillApproval extends StatefulWidget {
  final String? compCode;
  final String? billId;

  const PurchaseBillApproval({Key? key, this.compCode, this.billId})
      : super(key: key);

  @override
  _PurchaseBillApprovalState createState() => _PurchaseBillApprovalState();
}

class _PurchaseBillApprovalState extends State<PurchaseBillApproval>
    with NetworkResponse {
  Widget _height = SizedBox(height: 12);
  final companyController = TextEditingController();
  final finYearController = TextEditingController();
  final docDateController = TextEditingController();
  final noController = TextEditingController();
  final partyController = TextEditingController();

  final billTypeController = TextEditingController();
  final billNoController = TextEditingController();
  final billDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final purchaseTypeController = TextEditingController();
  final agentController = TextEditingController();
  final approvedByController = TextEditingController();
  final remarksController = TextEditingController();
  final sgstAmountController = TextEditingController();
  final cgstAmountController = TextEditingController();
  final igstAmountController = TextEditingController();
  final hsnController = TextEditingController();
  final itemNameController = TextEditingController();
  final rateWithTaxController = TextEditingController();
  final itemSGSTController = TextEditingController();
  final itemSGSTAmountController = TextEditingController();
  final itemCGSTController = TextEditingController();
  final itemCGSTAmountController = TextEditingController();
  final itemIGSTController = TextEditingController();
  final itemIGSTAmountController = TextEditingController();
  final orderController = TextEditingController();
  final packingDocNoController = TextEditingController();
  final packingDocDateController = TextEditingController();
  final gateEntryDocNoController = TextEditingController();
  final gateEntryDocDateController = TextEditingController();
  final poNoController = TextEditingController();
  final poDateController = TextEditingController();
  final indentNoController = TextEditingController();
  final indentDateController = TextEditingController();

  final grossAmountController = TextEditingController();
  final taxCalculateController = TextEditingController();
  final taxableGrossController = TextEditingController();
  final gstAmountController = TextEditingController();
  final taxableAdjController = TextEditingController();
  final netTaxController = TextEditingController();
  final otherChargesTotalController = TextEditingController();
  final roundOffController = TextEditingController();
  final netAmountController = TextEditingController();

  String _packingDocId = '';
  String _gateEntryDocId = '';
  String _poDocId = '';
  String _indentDocId = '';

  String _ocat1 = '';
  String _ocat2 = '';
  String _ocat3 = '';

  String _ocib1 = '';
  String _ocib2 = '';
  String _ocib3 = '';

  List<String?>? _imageList = [];
  List<String> _imageMainList = [];
  String imageBaseUrl = '';
  String imageMainBaseUrl = '';
  int _current = 0;

  List<PurchaseBillApprovalModel> _purchaseList = [];
  final _textStyleHighlight =
      TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    setState(() {});
    _getBillDetail();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Purchase Bill Approval'),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
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
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Party',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill Type
              TextFormField(
                readOnly: true,
                controller: billTypeController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill Type',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill No
              TextFormField(
                readOnly: true,
                controller: billNoController,
                style: _textStyleHighlight,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill No',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Bill Date
              TextFormField(
                readOnly: true,
                controller: billDateController,
                style: _textStyleHighlight,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Bill Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Due Date
              TextFormField(
                readOnly: true,
                controller: dueDateController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Purchase Type
              TextFormField(
                readOnly: true,
                controller: purchaseTypeController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Purchase Type',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Agent
              TextFormField(
                readOnly: true,
                controller: agentController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Agent',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Approved By
              TextFormField(
                readOnly: true,
                controller: approvedByController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Approved By',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Remarks
              TextFormField(
                readOnly: true,
                controller: remarksController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
              ),
              Visibility(visible: _imageMainList.isNotEmpty, child: _height),

              Visibility(
                visible: _imageMainList.isNotEmpty,
                child: Container(
                  height: 120,
                  child: ListView.builder(
                      itemCount: _imageMainList.length,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PurBillImageViewer(
                                        imageMainBaseUrl: imageMainBaseUrl,
                                        imageMainList: _imageMainList,
                                        position: index,
                                      )));
                            },
                            child: Container(
                                padding: EdgeInsets.fromLTRB(4, 8, 2, 4),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'images/loading_placeholder.png',
                                              image:
                                                  '$imageMainBaseUrl${_imageMainList[index]}',
                                              height: 120,
                                              width: 90,
                                              fit: BoxFit.cover)),
                                    ),
                                    Visibility(
                                      visible: ifHasPermission(
                                          permType: PermType.MODIFIED,
                                          compCode: widget.compCode,
                                          permission:
                                              Permissions.PUR_BILL_APPROVAL)!,
                                      child: Positioned(
                                        top: -2,
                                        right: -2,
                                        child: GestureDetector(
                                          onTap: () {
                                            _deleteImage(_imageMainList[index]);
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.cancel,
                                              size: 24,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          )),
                ),
              ),

              Visibility(
                visible: ifHasPermission(
                    permType: PermType.INSERT,
                    compCode: widget.compCode,
                    permission: Permissions.PUR_BILL_APPROVAL)!,
                child: TextButton(
                    onPressed: () {
                      _pickImageAndUpload();
                    },
                    child: Text('Add Image')),
              ),

              /// Flexible Table
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildCells(_purchaseList.length),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildRows(_purchaseList.length),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              Visibility(
                visible: _purchaseList.isNotEmpty,
                child: Visibility(
                  visible: ifHasPermission(
                      permType: PermType.MODIFIED,
                      compCode: widget.compCode,
                      permission: Permissions.PUR_BILL_APPROVAL)!,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_getCommaSepIds() != null) {
                          showAlert(context, 'Do you want to approve items',
                              'Approve Alert',
                              onOk: () {
                                _approveItem(_getCommaSepIds());
                              },
                              ok: 'Yes',
                              notOk: 'No',
                              onNo: () {
                                popIt(context);
                              });
                        } else {
                          showAlert(
                              context, 'Please select the catalog', 'Oops');
                        }
                      },
                      child: Text('Approve')),
                ),
              ),

              Visibility(visible: _purchaseList.isNotEmpty, child: _height),

              /// Item Detail Line (Divider)
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
                    'Item Detail',
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

              /// Item Image
              Container(
                width: 100.0.h,
                height: 36.0.h,
                child: _imageList!.isNotEmpty
                    ? PhotoViewGallery.builder(
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int imgIndex) {
                          _current = imgIndex;
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(
                                '$imageBaseUrl${_imageList![imgIndex]}.png'),
                            initialScale:
                                PhotoViewComputedScale.contained * 0.8,
                          );
                        },
                        onPageChanged: (value) {
                          setState(() {
                            _current = value;
                          });
                        },
                        itemCount: _imageList!.length,
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
                children: _imageList!.map((item) {
                  int mIndex = _imageList!.indexOf(item);
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

              /// HSN Code
              TextFormField(
                readOnly: true,
                controller: hsnController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'HSN Code',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Item Name
              TextFormField(
                readOnly: true,
                controller: itemNameController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,

              /// Rate With Tax
              Visibility(
                visible: false,
                child: TextFormField(
                  readOnly: true,
                  controller: rateWithTaxController,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Rate With Tax',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Visibility(visible: false, child: _height),

              /// SGST Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// SGST
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemSGSTController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'SGST',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// SGST Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemSGSTAmountController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'SGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// CGST Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// CGST
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemCGSTController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'CGST',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// CGST Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemCGSTAmountController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'CGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// IGST Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// IGST
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemIGSTController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'IGST',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// IGST Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: itemIGSTAmountController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'IGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// Other Charges After Tax
              Row(
                children: [
                  Text(
                    'Other Charges After Tax',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              _height,
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 1'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocat1),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 2'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocat2),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 3'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocat3),
                    )
                  ]),
                ],
              ),

              _height,

              /// Other Charges Item Based
              Row(
                children: [
                  Text(
                    'Other Charges Item Based',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

              _height,

              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 1'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocib1),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 2'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocib2),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Charge 3'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_ocib3),
                    )
                  ]),
                ],
              ),

              _height,

              /// Order
              TextFormField(
                readOnly: true,
                controller: orderController,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Order',
                  border: OutlineInputBorder(),
                ),
              ),

              _height,

              /// Packing Doc No & Date
              Row(
                children: [
                  /// Doc No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: packingDocNoController,
                      onTap: () {
                        if (packingDocNoController.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PurchasePackingBill(id: _packingDocId)));
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Packing Doc No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Doc Date
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: packingDocDateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Packing Doc Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Gate Entry Doc No & Date
              Row(
                children: [
                  /// Doc No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: gateEntryDocNoController,
                      onTap: () {
                        if (gateEntryDocNoController.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GateEntry(
                                      gateEntryType: GateEntryType.ENTRY,
                                      id: _gateEntryDocId)));
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Gate Entry Doc No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Doc Date
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: gateEntryDocDateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Gate Entry Doc Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// PO No & Date
              Row(
                children: [
                  /// PO No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: poNoController,
                      onTap: () {
                        if (poNoController.text.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PoOrderListing(id: _poDocId)));
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'PO No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  /// PO Date
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: poDateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'PO Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Indent No & Date
              Row(
                children: [
                  /// Indent No
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: indentNoController,
                      onTap: () {
                        if (indentNoController.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      IndentOrder(id: _indentDocId)));
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Indent No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Indent Date
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: indentDateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Indent Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Total Line (Divider)
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
                    'Total',
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

              /// Total GST Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// SGST Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: sgstAmountController,
                      style: TextStyle(color: AppColor.appRed),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'SGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// CGST
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: cgstAmountController,
                      style: TextStyle(color: AppColor.appRed),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'CGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// IGST
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: igstAmountController,
                      style: TextStyle(color: AppColor.appRed),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'IGST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              _height,

              /// Gross Amount & Tax Calculate
              Row(
                children: [
                  /// Gross Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: grossAmountController,
                      style: TextStyle(color: AppColor.appRed),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Gross Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Tax Calculate
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: taxCalculateController,
                      decoration: InputDecoration(
                        isDense: true,
                        suffix: Text('%'),
                        labelText: 'Tax Calculate',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Taxable Gross Amount & GST Amount
              Row(
                children: [
                  ///Taxable Gross Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: taxableGrossController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Taxable Gross Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// GST Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: gstAmountController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'GST Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Taxable Adj Amount & Net Tax Amount
              Row(
                children: [
                  /// Taxable Adj Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: taxableAdjController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Taxable Adj Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Net Tax Amount
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: netTaxController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Net Tax Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Other Charges Total & Round Off
              Row(
                children: [
                  /// Other Charges Total
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: otherChargesTotalController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Other Charges Total',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// Round Off
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: roundOffController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Round Off',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              _height,

              /// Net Amount
              TextFormField(
                readOnly: true,
                controller: netAmountController,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Net Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              _height,
            ],
          ),
        ),
      ),
    );
  }

  _pickImageAndUpload() async {
    var res = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageEditor()));

    if (res == null) return;
    var _image = res['file'];

    _uploadImage(_image);
  }

  _uploadImage(File file) {
    Map jsonBody = {
      'user_id': getUserId(),
      'hdr_pk': widget.billId,
    };

    WebService.multipartApi(
            AppConfig.uploadPurBillImage, this, jsonBody, file.absolute.path)
        .callMultipartPostService(context);
  }

  /// Vertically
  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (mainIndex) => GestureDetector(
        onTap: () {
          if (_purchaseList[mainIndex].isHeader ||
              mainIndex == _purchaseList.length - 1) return;

          _viewItem(_purchaseList[mainIndex]);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
              width: 124,
              height: 52,
              color: _purchaseList[mainIndex].isHeader
                  ? AppColor.appRed
                  : _purchaseList[mainIndex].isViewing
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
                        /// Approve
                        Visibility(
                          visible: _getActionVisibility(mainIndex),
                          child: Container(
                            child: Checkbox(
                                value: _purchaseList[mainIndex].isSelected,
                                onChanged: (v) {
                                  setState(() {
                                    _purchaseList[mainIndex].isSelected =
                                        !_purchaseList[mainIndex].isSelected;
                                  });
                                  _viewItem(_purchaseList[mainIndex]);
                                }),
                          ),
                        ),

                        Text(
                          _purchaseList[mainIndex].catalog,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: _purchaseList[mainIndex].isHeader
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
          /// Item Name
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 170,
              padding: EdgeInsets.symmetric(horizontal: 3),
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].itemName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Fin Qty
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].finQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Fin Qty Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].finQtyUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
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
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].rate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Rate Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].rateUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
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
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].stockQty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Stock Qty Uom
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].stockUom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Item Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].itemAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Other Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].otherAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
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
              height: 52,
              width: width + 24,
              color: _purchaseList[index].isHeader
                  ? AppColor.appRed
                  : _purchaseList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _purchaseList[index].amount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _purchaseList[index].isHeader
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
    if (_purchaseList[index].isHeader) {
      return false;
    } else if (index == _purchaseList.length - 1) {
      return false;
    } else
      return true;
  }

  /// type-> StockQty, FinQty, RateWithTax,
  /// -----> ItemAmount, OtherAmount,Amount
  _getTotal(String type) {
    if (_purchaseList.isEmpty)
      return '0';
    else {
      var res = _purchaseList.where((element) => !element.isHeader);
      int count = 0;

      switch (type) {
        case 'StockQty':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.stockQty.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;

        case 'FinQty':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.finQty.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'RateWithTax':
          {
            res.forEach((element) {
              count += element.rate.toInt() + element.gst.toInt();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'ItemAmount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.itemAmount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'OtherAmount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.otherAmount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.amount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
      }
    }
  }

  _getBillDetail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compCode,
      'code_pk': widget.billId
    };

    WebService.fromApi(AppConfig.getPendingBillDetail, this, jsonBody)
        .callPostService(context);
  }

  _approveItem(String? ids) {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': ids};

    logIt('ApproveItem-> $jsonBody');

    WebService.fromApi(AppConfig.approveBillItem, this, jsonBody)
        .callPostService(context);
  }

  String? _getCommaSepIds() {
    String? data;

    _purchaseList.forEach((element) {
      if (element.isSelected) {
        if (data == null) {
          data = '${element.id}';
        } else {
          data = '$data,${element.id}';
        }
      }
    });

    return data;
  }

  void _deleteImage(String image) {
    try {
      showAlert(context, 'Are sure you want to delete image', 'Confirmation',
          onOk: () {
            String id = image.split('.png')[0];
            Map jsonBody = {'user_id': getUserId(), 'code_pk': id};
            WebService.fromApi(AppConfig.deletePurBillImage, this, jsonBody)
                .callPostService(context);
          },
          ok: 'Yes',
          notOk: 'No',
          onNo: () {
            popIt(context);
          });
    } catch (err, stack) {
      logIt('_deleteImage-> $err $stack');
    }
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) async {
    try {
      switch (requestCode) {
        case AppConfig.getPendingBillDetail:
          {
            var resp = jsonDecode(response!);

            if (resp['error'] == 'false') {
              var data = resp['content'];

              finYearController.text = getString(data, 'doc_finyear');
              docDateController.text = getString(data, 'doc_date');
              noController.text = getString(data, 'doc_no');
              partyController.text = getString(data['party_name'], 'name');
              billTypeController.text = getString(data, 'bill_type') == 'G'
                  ? 'GST'
                  : getString(data, 'bill_type');
              billNoController.text = getString(data, 'bill_no');
              billDateController.text = getString(data, 'bill_date');
              dueDateController.text = getString(data, 'due_date');
              purchaseTypeController.text =
                  getString(data['pur_type_name'], 'name');
              approvedByController.text =
                  getString(data['approved_user'], 'name');
              remarksController.text = getString(data, 'remarks');

              grossAmountController.text = getString(data, 'gross_amount');
              taxCalculateController.text = getString(data, 'tax_cal_per');
              taxableGrossController.text = getString(data, 'taxable_grs_amt');
              gstAmountController.text = getString(data, 'tax_amount');
              taxableAdjController.text = getString(data, 'tax_adj_amount');
              netTaxController.text = getString(data, 'net_tax_amount');
              otherChargesTotalController.text =
                  getString(data, 'other_amount');
              roundOffController.text = getString(data, 'rf_amount');
              netAmountController.text = getString(data, 'net_amount');

              imageBaseUrl = getString(resp, 'image_item_png_path');
              imageMainBaseUrl = getString(resp, 'bill_item_png_path');

              var billImages = data['bill_images'] as List;
              _imageMainList.clear();

              logIt('BillImagesCount-> ${billImages.length}');

              billImages.forEach((e) {
                _imageMainList.add('${e['code_pk']}.png');
              });

              var billItems = data['bill_items'] as List;

              _purchaseList.clear();
              bool isType13 = getString(data, 'ge_doc_type_fk') == '13';

              _purchaseList.addAll(billItems
                  .map((e) => PurchaseBillApprovalModel.fromJson(e, isType13))
                  .toList());

              _purchaseList.removeWhere((element) =>
                  element.approvedDate.isNotEmpty &&
                  element.approvedBy.isNotEmpty);

              if (_purchaseList.isNotEmpty) {
                double sgst = 0.0;
                _purchaseList.forEach((element) {
                  sgst += element.sgstAmount.toDouble();
                });
                sgstAmountController.text = sgst.toString();

                double cgst = 0.0;
                _purchaseList.forEach((element) {
                  cgst += element.cgstAmount.toDouble();
                });
                cgstAmountController.text = cgst.toString();

                double igst = 0.0;
                _purchaseList.forEach((element) {
                  igst += element.igstAmount.toDouble();
                });
                igstAmountController.text = igst.toString();

                ///Header
                _purchaseList.insert(
                    0,
                    PurchaseBillApprovalModel(
                        catalog: 'Catalog',
                        itemName: 'Item Name',
                        stockQty: 'Stock Qty',
                        stockUom: 'Uom',
                        finQty: 'Fin Qty',
                        finQtyUom: 'Uom',
                        rate: 'Rate',
                        rateUom: 'Uom',
                        gst: 'Gst',
                        itemAmount: 'Item Amount',
                        otherAmount: 'Other Amount',
                        amount: 'Amount',
                        isHeader: true));

                /// Footer
                _purchaseList.add(PurchaseBillApprovalModel(
                  catalog: 'Total',
                  stockQty: _getTotal('StockQty'),
                  finQty: _getTotal('FinQty'),
                  itemAmount: _getTotal('ItemAmount'),
                  otherAmount: _getTotal('OtherAmount'),
                  amount: _getTotal('Amount'),
                ));
              }

              if (_purchaseList.length == 3) {
                _viewItem(_purchaseList[1]);
              }

              setState(() {});
            }
          }
          break;

        case AppConfig.approveBillItem:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                if (_purchaseList.length <= 2) {
                  popIt(context);
                }
              });

              _purchaseList.removeWhere((element) => element.isSelected);

              if (_purchaseList.length == 2) {
                _purchaseList.clear();
              }

              setState(() {});
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.deletePurBillImage:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                _getBillDetail();
              });
            } else {
              showAlert(context, data['message'], 'Error');
            }
          }
          break;

        case AppConfig.uploadPurBillImage:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success');
              var content = data['content'] as List;
              _imageMainList.clear();

              content.forEach((e) {
                _imageMainList.add('$e.png');
              });

              setState(() {});
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack ');
    }
  }

  _viewItem(PurchaseBillApprovalModel model) {
    _purchaseList.forEach((element) {
      element.isViewing = false;
    });

    model.isViewing = true;

    _poDocId = model.poDocId;
    _indentDocId = model.indentDocId;
    _packingDocId = model.packingDocId;
    _gateEntryDocId = model.gateEntryDocId;

    logIt('_imageList-> ${_imageList!.length}');

    _imageList = model.imageList;

    hsnController.text = model.hsnCode;
    itemNameController.text = model.itemName;

    itemSGSTController.text = model.sgst;
    itemSGSTAmountController.text = model.sgstAmount;

    itemCGSTController.text = model.cgst;
    itemCGSTAmountController.text = model.cgstAmount;

    itemIGSTController.text = model.igst;
    itemIGSTAmountController.text = model.igstAmount;

    _ocat1 = model.ocat1;
    _ocat2 = model.ocat2;
    _ocat3 = model.ocat3;

    poNoController.text = model.poNo;
    orderController.text = model.order;
    poDateController.text = model.poDate;
    indentNoController.text = model.indentNo;
    indentDateController.text = model.indentDate;
    packingDocNoController.text = model.packingDocNo;
    packingDocDateController.text = model.packingDocDate;
    gateEntryDocNoController.text = model.gateEntryDocNo;
    gateEntryDocDateController.text = model.gateEntryDocDate;

    setState(() {});
  }

  @override
  void dispose() {
    companyController.dispose();
    finYearController.dispose();
    docDateController.dispose();
    noController.dispose();
    partyController.dispose();
    billTypeController.dispose();
    billNoController.dispose();
    billDateController.dispose();
    dueDateController.dispose();
    purchaseTypeController.dispose();
    agentController.dispose();
    approvedByController.dispose();
    sgstAmountController.dispose();
    cgstAmountController.dispose();
    igstAmountController.dispose();
    hsnController.dispose();
    itemNameController.dispose();
    rateWithTaxController.dispose();
    itemSGSTController.dispose();
    itemSGSTAmountController.dispose();
    itemCGSTController.dispose();
    itemCGSTAmountController.dispose();
    itemIGSTController.dispose();
    itemIGSTAmountController.dispose();
    orderController.dispose();
    packingDocNoController.dispose();
    packingDocDateController.dispose();
    gateEntryDocNoController.dispose();
    gateEntryDocDateController.dispose();
    poNoController.dispose();
    poDateController.dispose();
    indentNoController.dispose();
    indentDateController.dispose();
    grossAmountController.dispose();
    taxCalculateController.dispose();
    taxableGrossController.dispose();
    gstAmountController.dispose();
    taxableAdjController.dispose();
    netTaxController.dispose();
    otherChargesTotalController.dispose();
    roundOffController.dispose();
    netAmountController.dispose();
    remarksController.dispose();
    super.dispose();
  }
}
