import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

class PendingBillForReceipt extends StatefulWidget {
  final String? compId;
  final String? partyCode;
  final List<ReceiptBillModel>? selectedItemList;

  const PendingBillForReceipt({
    Key? key,
    required this.compId,
    this.partyCode,
    this.selectedItemList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingBillForReceipt();
}

class _PendingBillForReceipt extends State<PendingBillForReceipt>
    with NetworkResponse {
  final vspacer = SizedBox(height: 20);
  final hspacer = SizedBox(width: 20);
  List<ReceiptBillModel> receiptBillList = [];
  List<RecPaymentDetailModel> recpaymentDetailList = [];
  List<RecPurchaseBillModel> recpurchaseBillList = [];
  TextEditingController _chlannocontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _catalogitemcontroller = TextEditingController();
  String partyCode = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getReceiptBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                popIt(context,
                    args:
                        receiptBillList.where((element) => element.isSelected));
              },
            ),
            title: Text('Pending Bill For Receipt'),
          ),
          body: receiptBillList.isEmpty
              ? Center(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('No Data Found',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ))))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Table1
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _buildCells1(),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _buildRows1(),
                                  ),
                                ),
                              )
                            ]),
                        vspacer,

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('Payment Detail Documents',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 18)),
                        ),
                        if (receiptBillList.isEmpty)
                          Center(
                              child: Text('No Data Found',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )))
                        else

                          /// Table2
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _buildCells2(),
                              ),
                              Flexible(
                                  child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildRows2(),
                                ),
                              )),
                            ],
                          ),
                        vspacer,
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('Purchase Bill Items',
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 18)),
                        ),
                        if (receiptBillList.isEmpty)
                          Center(
                              child: Text('No Data Found',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )))
                        else

                          /// Table3
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: _buildCells3(),
                              ),
                              Flexible(
                                  child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        children: _buildRows3(),
                                      ))),
                            ],
                          ),
                        vspacer,

                        /// Challan No,Date
                        Row(
                          children: [
                            /// Challan no
                            Flexible(
                              child: TextFormField(
                                readOnly: true,
                                controller: _chlannocontroller,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Challan No',
                                  isDense: true,
                                ),
                              ),
                            ),
                            hspacer,

                            /// date
                            Flexible(
                              child: TextFormField(
                                readOnly: true,
                                controller: _datecontroller,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Date',
                                  isDense: true,
                                ),
                              ),
                            ),
                            hspacer,
                          ],
                        ),
                        vspacer,

                        /// Catalog Name
                        Row(
                          children: [
                            Flexible(
                                child: TextFormField(
                              readOnly: true,
                              controller: _catalogitemcontroller,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Catalog Name',
                                  hintText: 'Catalog Name',
                                  isDense: true),
                            )),
                            hspacer,
                          ],
                        ),
                      ]))),
    );
  }

  _getTotal(String type) {
    if (receiptBillList.isEmpty)
      return '0';
    else {
      var res = receiptBillList.where((element) => !element.isHeader);
      //  int count = 0;
      switch (type) {
        case 'Sale Comm':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.saleamount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //   break;
        case 'Bank':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.bank.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //    break;
        case 'Cash':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.cash.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'Return':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.ret.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //   break;
        case 'Tds':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.tds.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'Sale Pur':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.salepur.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'B2B':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.b2b.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Other':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.other.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Due Amount1':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.dueamount1.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Due Amount2':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.dueamount2.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
      }
    }
  }

  _getReceiptBills() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'acc_code': widget.partyCode
    };

    WebService.fromApi(AppConfig.pendingBillForReceipt, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    if (requestCode == AppConfig.pendingBillForReceipt) {
      var data = jsonDecode(response!);
      if (data['error'] == 'false') {
        var receiptbillcontent = data['bill_lists'] as List;
        receiptBillList.addAll(receiptbillcontent
            .map((e) => ReceiptBillModel.parsejson(e))
            .toList());
        if (widget.selectedItemList != null) {
          for (int i = 0; i < widget.selectedItemList!.length; i++) {
            for (int k = 0; k < receiptBillList.length; k++) {
              if (receiptBillList[k].billnumber ==
                  widget.selectedItemList![i].billnumber) {
                receiptBillList.removeAt(k);
              }
            }
          }
          receiptBillList.where((element) => false);
        }
        if (receiptBillList.isNotEmpty) {
          ///Header
          receiptBillList.insert(
              0,
              ReceiptBillModel(
                  billnumber: 'Bill Number',
                  billdate: 'Bill Date',
                  duedate: 'Due Date',
                  saleamount: 'Sale Comm',
                  bank: 'Bank',
                  cash: 'Cash',
                  ret: 'Return',
                  tds: 'Tds',
                  salepur: 'Sale Pur',
                  b2b: 'B2B',
                  other: 'Other',
                  dueamount1: 'Due Amount',
                  dueamount2: 'Due Amount',
                  isHeader: true));
          receiptBillList.add(ReceiptBillModel(
            billnumber: 'Total',
            saleamount: _getTotal('Sale Comm'),
            bank: _getTotal('Bank'),
            cash: _getTotal('Cash'),
            ret: _getTotal('Return'),
            tds: _getTotal('Tds'),
            salepur: _getTotal('Sale Pur'),
            b2b: _getTotal('B2B'),
            other: _getTotal('Other'),
            dueamount1: _getTotal('Due Amount1'),
            dueamount2: _getTotal('Due Amount2'),
          ));
        }

        setState(() {});
      }
    }
  }

  /// Vertically 1
  List<Widget> _buildCells1() {
    return List.generate(
        receiptBillList.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (!receiptBillList[index].isHeader &&
                    receiptBillList[index] != receiptBillList.last) {
                  recpaymentDetailList.clear();
                  logIt(
                      'onTap=> ${receiptBillList[index].recpaymentDetailList}');
                  recpaymentDetailList
                      .addAll(receiptBillList[index].recpaymentDetailList!);
                  setState(() {});
                }
              },
              child: Container(
                  width: 130,
                  height: 50,
                  color: receiptBillList[index].isHeader
                      ? AppColor.appRed
                      : receiptBillList[index].isViewing
                          ? AppColor.appRed[500]
                          : Colors.red[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: !receiptBillList[index].isHeader &&
                                      receiptBillList.length - 1 != index &&
                                      receiptBillList[index].doctype !=
                                          'OARECD' &&
                                      receiptBillList[index].doctype != 'OAPAY',
                                  child: Container(
                                    child: Checkbox(
                                        value:
                                            receiptBillList[index].isSelected,
                                        onChanged: (v) {
                                          recpaymentDetailList.clear();
                                          recpaymentDetailList.addAll(
                                              receiptBillList[index]
                                                  .recpaymentDetailList!);
                                          setState(() {
                                            receiptBillList[index].isSelected =
                                                !receiptBillList[index]
                                                    .isSelected;
                                          });
                                        }),
                                  ),
                                ),
                                Text(
                                  receiptBillList[index].billnumber,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: receiptBillList[index].isHeader
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            ))
                      ])),
            )));
  }

  /// Horizontally 1
  List<Widget> _buildRows1() {
    return List.generate(receiptBillList.length,
        (index) => _eachRow1(receiptBillList.length, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow1(int count, int index) {
    return Container(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
            child: Row(children: [
          /// Bill Date
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                  child: Text(
                receiptBillList[index].billdate.handleEmpty(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: receiptBillList[index].isHeader
                        ? Colors.white
                        : Colors.black),
              )),
            ),
          ),

          /// Due Date
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].duedate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text('${receiptBillList[index].saleamount}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          ///Bank
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].bank,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Cash
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].cash,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Return
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].ret,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Tds
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].tds,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Pur
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].salepur,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// B2b
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].b2b,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Other
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].other,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Due Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].dueamount1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Due Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: receiptBillList[index].isHeader
                  ? AppColor.appRed
                  : receiptBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(receiptBillList[index].dueamount2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: receiptBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),
        ])));
  }

  /// Vertically 2
  List<Widget> _buildCells2() {
    return List.generate(
        recpaymentDetailList.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (!recpaymentDetailList[index].isHeader &&
                    recpaymentDetailList[index] != recpaymentDetailList.last) {
                  recpurchaseBillList.clear();
                  recpurchaseBillList
                      .addAll(recpaymentDetailList[index].recpurchaseBillList!);
                  logIt('${recpurchaseBillList.length}');
                  setState(() {});
                }
              },
              child: Container(
                  width: 130,
                  height: 50,
                  color: recpaymentDetailList[index].isHeader
                      ? AppColor.appRed
                      : recpaymentDetailList[index].isViewing
                          ? AppColor.appRed[500]
                          : Colors.red[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recpaymentDetailList[index]
                                      .docno
                                      .handleEmpty(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          recpaymentDetailList[index].isHeader
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ],
                            ))
                      ])),
            )));
  }

  /// Horizontally 2
  List<Widget> _buildRows2() {
    return List.generate(recpaymentDetailList.length,
        (index) => _eachRow2(recpaymentDetailList.length, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow2(int count, int index) {
    return Container(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
            child: Row(children: [
          /// Doc Date
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].docdate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].saleamount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          ///Bank
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].bank,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Cash
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].cash,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Return
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].ret,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Tds
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].tds,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Pur
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].salepur,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// B2b
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].b2b,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Other
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpaymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : recpaymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpaymentDetailList[index].other,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpaymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),
        ])));
  }

  /// Vertically 3
  List<Widget> _buildCells3() {
    return List.generate(
        recpurchaseBillList.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (recpurchaseBillList[index] != recpurchaseBillList.last)
                  logIt('${'hello'}');
                _chlannocontroller.text = recpurchaseBillList[index].chlanno;
                _datecontroller.text = recpurchaseBillList[index].date;
                _catalogitemcontroller.text =
                    recpurchaseBillList[index].itemname;
              },
              child: Container(
                  width: 130,
                  height: 50,
                  color: recpurchaseBillList[index].isHeader
                      ? AppColor.appRed
                      : recpurchaseBillList[index].isViewing
                          ? AppColor.appRed[500]
                          : Colors.red[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recpurchaseBillList[index]
                                      .catalogitem
                                      .handleEmpty(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: recpurchaseBillList[index].isHeader
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            ))
                      ])),
            )));
  }

  /// Horizontally 3
  List<Widget> _buildRows3() {
    return List.generate(recpurchaseBillList.length,
        (index) => _eachRow3(recpurchaseBillList.length, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow3(int count, int index) {
    return Container(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
            child: Row(children: [
          ///  Party Item Name
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 250,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                    recpurchaseBillList[index].partyitemname.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Party Po
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].partypo.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Bags
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].bags.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          ///Qty
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].qty.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// QUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].quom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Rate
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].rate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// RUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].ruom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          ///Item Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].itemamount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Clb Qty
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].clbqty.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// ClbQtyUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].clbqtyuom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Clb Rate
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].clbrate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// ClbRateUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].clbrateuom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Clb Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: recpurchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : recpurchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(recpurchaseBillList[index].clbamount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: recpurchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),
        ])));
  }
}

class ReceiptBillModel {
  String billnumber = '';
  String billdate = '';
  String duedate = '';
  String saleamount = '';
  String bank = '';
  String cash = '';
  String ret = '';
  String tds = '';
  String salepur = '';
  String b2b = '';
  String other = '';
  String dueamount1 = '';
  String dueamount2 = '';
  String docno = '';
  String amount = '';
  String billamount = '';
  String doctype = '';
  String sendbillhdrpk = '';
  String itemreceiptamount = '';
  String itemPayamount = '';
  String item_code_pk = '';
  String codePk = '';
  bool isHeader;
  bool isViewing;
  bool isSelected;
  bool isLocal;
  List<RecPaymentDetailModel>? recpaymentDetailList;

  ReceiptBillModel({
    this.billnumber = '',
    this.billdate = '',
    this.duedate = '',
    this.saleamount = '',
    this.bank = '',
    this.cash = '',
    this.ret = '',
    this.tds = '',
    this.salepur = '',
    this.b2b = '',
    this.other = '',
    this.dueamount1 = '',
    this.dueamount2 = '',
    this.isHeader = false,
    this.isViewing = false,
    this.isSelected = false,
    this.isLocal = true,
    this.docno = '',
    this.amount = '',
    this.billamount = '',
    this.doctype = '',
    this.sendbillhdrpk = '',
    this.itemreceiptamount = '',
    this.itemPayamount = '',
    this.item_code_pk = '',
    this.codePk = '',
    this.recpaymentDetailList,
  });

  factory ReceiptBillModel.parsejson(Map<String, dynamic> data) {
    List<RecPaymentDetailModel> recpaymentDetailList = [];
    _getDetailTotal(String type) {
      if (recpaymentDetailList.isEmpty)
        return '0';
      else {
        var res = recpaymentDetailList.where((element) => !element.isHeader);
        switch (type) {
          case 'Sale Amount':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.saleamount.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'Bank':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.bank.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'Cash':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.cash.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //break;
          case 'Return':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.ret.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'Tds':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.tds.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //break;
          case 'Sale Pur':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.salepur.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'B2B':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.b2b.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //break;
          case 'Other':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.other.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //break;
        }
      }
    }

    var recpaymentdetailcontent = data['due_dtls'] as List?;
    if (recpaymentdetailcontent != null) {
      recpaymentDetailList.addAll(recpaymentdetailcontent
          .map((e) => RecPaymentDetailModel.parsejson(e))
          .toList());
    }

    if (recpaymentDetailList.isNotEmpty) {
      ///Header
      recpaymentDetailList.insert(
          0,
          RecPaymentDetailModel(
              docno: 'Doc No',
              docdate: 'Doc Date',
              saleamount: 'Sale Amount',
              bank: 'Bank',
              cash: 'Cash',
              ret: 'Return',
              tds: 'Tds',
              salepur: 'Sale Pur',
              b2b: 'B2B',
              other: 'Other',
              isHeader: true));
      recpaymentDetailList.add(RecPaymentDetailModel(
        docno: 'Total',
        saleamount: _getDetailTotal('Sale Amount')!,
        bank: _getDetailTotal('Bank')!,
        cash: _getDetailTotal('Cash')!,
        ret: _getDetailTotal('Return')!,
        tds: _getDetailTotal('Tds')!,
        salepur: _getDetailTotal('Sale Pur')!,
        b2b: _getDetailTotal('B2B')!,
        other: _getDetailTotal('Other')!,
      ));
    }

    return ReceiptBillModel(
      billnumber: getString(data, 'bill_no'),
      billdate: getString(data, 'bill_date'),
      duedate: getFormattedDate(getString(data, 'due_date'),
          outFormat: 'dd MMM yyyy '),
      saleamount: getString(data, 'sale_amount'),
      bank: getString(data, 'bank_amount'),
      cash: getString(data, 'cash_amount'),
      ret: getString(data, 'rtn_amount'),
      tds: getString(data, 'tds_amount'),
      salepur: getString(data, 'pur_sale_amount'),
      b2b: getString(data, 'bank2bank_amount'),
      other: getString(data, 'other_amount'),
      dueamount1: getString(data, 'due_cr_amount'),
      dueamount2: getString(data, 'due_dr_amount'),
      docno: getString(data, 'bill_ser'),
      billamount: getString(data, 'sale_amount'),
      amount: getString(data, 'due_dr_amount'),
      doctype: getString(data, 'doc_type'),
      sendbillhdrpk: getString(data, 'send_bill_hdr_pk'),
      itemreceiptamount: getString(data, 'due_dr_amount'),
      codePk: getString(data['bill_dtls'], 'code_pk'),
      recpaymentDetailList: recpaymentDetailList,
    );
  }
  factory ReceiptBillModel.parseItems(Map<String, dynamic> data) {
    // List <RecPaymentDetailModel>recpaymentDetailList=[];
    // _getDetailTotal(String type) {
    //   if (recpaymentDetailList.isEmpty)
    //     return '0';
    //   else {
    //     var res = recpaymentDetailList.where((element) => !element.isHeader);
    //     int count = 0;
    //     switch (type) {
    //       case 'Sale Amount':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.saleamount.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Bank':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.bank.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Cash':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.cash.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Return':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.ret.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Tds':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.tds.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Sale Pur':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.salepur.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'B2B':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.b2b.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //       case 'Other':
    //         {
    //           double count = 0.0;
    //           res.forEach((element) {
    //             count += element.other.toDouble();
    //           });
    //           return count.toStringAsFixed(2);
    //         }
    //         break;
    //
    //     }
    //   }
    // }
    // var recpaymentdetailcontent = data['due_dtls'] as List;
    // if(recpaymentdetailcontent!=null) {
    //   recpaymentDetailList.addAll(recpaymentdetailcontent
    //       .map((e) => RecPaymentDetailModel.parsejson(e))
    //       .toList());
    // }
    //
    // if (recpaymentDetailList.isNotEmpty) {
    //   ///Header
    //   recpaymentDetailList.insert(
    //       0,
    //       RecPaymentDetailModel(
    //           docno: 'Doc No',
    //           docdate: 'Doc Date',
    //           saleamount: 'Sale Amount',
    //           bank: 'Bank',
    //           cash: 'Cash',
    //           ret: 'Return',
    //           tds: 'Tds',
    //           salepur: 'Sale Pur',
    //           b2b: 'B2B',
    //           other: 'Other',
    //           isHeader: true));
    //   recpaymentDetailList.add(RecPaymentDetailModel(
    //     docno: 'Total',
    //     saleamount: _getDetailTotal('Sale Amount'),
    //     bank: _getDetailTotal('Bank'),
    //     cash: _getDetailTotal('Cash'),
    //     ret: _getDetailTotal('Return'),
    //     tds: _getDetailTotal('Tds'),
    //     salepur: _getDetailTotal('Sale Pur'),
    //     b2b: _getDetailTotal('B2B'),
    //     other: _getDetailTotal('Other'),
    //
    //   ));
    // }

    return ReceiptBillModel(
        billnumber: getString(data['sale_bill_hdr_details'], 'bill_no'),
        billdate: getString(data['sale_bill_hdr_details'], 'bill_date'),
        duedate: getFormattedDate(getString(data, 'due_date'),
            outFormat: 'dd MMM yyyy'),
        saleamount: getString(data, 'sale_amount'),
        bank: getString(data, 'bank_amount'),
        cash: getString(data, 'cash_amount'),
        ret: getString(data, 'rtn_amount'),
        tds: getString(data, 'tds_amount'),
        salepur: getString(data, 'pur_sale_amount'),
        b2b: getString(data, 'bank2bank_amount'),
        other: getString(data, 'other_amount'),
        dueamount1: getString(data, 'due_cr_amount'),
        dueamount2: getString(data, 'due_dr_amount'),
        docno: getString(data['sale_bill_hdr_details'], 'bill_ser'),
        billamount: getString(data['sale_bill_hdr_details'], 'net_amount'),
        amount: getString(data, 'receipt_amount'),
        doctype: getString(data, 'doc_type'),
        sendbillhdrpk: getString(data, 'sale_bill_hdr_pk'),
        itemreceiptamount: getString(data, 'due_dr_amount'),
        itemPayamount: getString(data, 'due_dr_amount'),
        item_code_pk: getString(data, 'code_pk'),
        codePk: getString(data['bill_dtls'], 'code_pk'),
        isLocal: false);
  }
}

class RecPaymentDetailModel {
  String docno = '';
  String docdate = '';
  String saleamount = '';
  String bank = '';
  String cash = '';
  String ret = '';
  String tds = '';
  String salepur = '';
  String b2b = '';
  String other = '';
  bool isHeader;
  bool isViewing;
  List<RecPurchaseBillModel>? recpurchaseBillList;

  RecPaymentDetailModel(
      {this.docno = '',
      this.docdate = '',
      this.saleamount = '',
      this.bank = '',
      this.cash = '',
      this.ret = '',
      this.tds = '',
      this.salepur = '',
      this.b2b = '',
      this.other = '',
      this.isHeader = false,
      this.isViewing = false,
      this.recpurchaseBillList});
  factory RecPaymentDetailModel.parsejson(Map<String, dynamic> data) {
    List<RecPurchaseBillModel> recpurchaseBillList = [];
    var detailObj = data['detail'];
    if (detailObj == null) {
      detailObj = {};
    }
    var recpurchasebillcontent = detailObj['order_items'] as List?;
    if (recpurchasebillcontent != null) {
      recpurchaseBillList.addAll(recpurchasebillcontent
          .map((e) => RecPurchaseBillModel.parsejson(e))
          .toList());
    }
    if (recpurchaseBillList.isNotEmpty) {
      ///Header
      recpurchaseBillList.insert(
          0,
          RecPurchaseBillModel(
              catalogitem: 'Catalog Item',
              partyitemname: ' Party Item Name',
              partypo: 'Party Po',
              bags: 'Bags',
              qty: ' Qty',
              quom: 'Uom',
              rate: 'Rate',
              ruom: 'Uom',
              itemamount: 'Item Amount',
              clbqty: 'Clb Qty',
              clbqtyuom: 'Uom',
              clbrate: 'Clb Rate',
              clbrateuom: 'Uom',
              clbamount: 'Clb Amount',
              isHeader: true));

      recpurchaseBillList.add(RecPurchaseBillModel(
        catalogitem: 'Total',
        bags: _getBillTotal('Bags', recpurchaseBillList),
        qty: _getBillTotal('Qty', recpurchaseBillList),
        itemamount: _getBillTotal('Item Amount', recpurchaseBillList),
        clbqty: _getBillTotal('Clb Qty', recpurchaseBillList),
        clbamount: _getBillTotal('Clb Amount', recpurchaseBillList),
      ));
    }

    return RecPaymentDetailModel(
      docno: getString(data['detail'], 'doc_no'),
      docdate: getString(data['detail'], 'doc_date'),
      saleamount: getString(data, 'sale_amount'),
      bank: getString(data, 'sale_amount'),
      cash: getString(data, 'cash_amount'),
      ret: getString(data, 'rtn_amount'),
      tds: getString(data, 'tds_amount'),
      salepur: getString(data, 'pur_sale_amount'),
      b2b: getString(data, 'bank2bank_amount'),
      other: getString(data, 'other_amount'),
      recpurchaseBillList: recpurchaseBillList,
    );
  }

  static _getBillTotal(
      String type, List<RecPurchaseBillModel> recpurchaseBillList) {
    if (recpurchaseBillList.isEmpty)
      return '0';
    else {
      var res = recpurchaseBillList.where((element) => !element.isHeader);
      switch (type) {
        case 'Bags':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.bags.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'Qty':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.qty.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'Clb Qty':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.clbqty.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Item Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.itemamount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Clb Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.clbamount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;

        default:
          return '';
      }
    }
  }
}

class RecPurchaseBillModel {
  String catalogitem = '';
  String partyitemname = '';
  String partypo = '';
  String bags = '';
  String qty = '';
  String quom = '';
  String rate = '';
  String ruom = '';
  String itemamount = '';
  String clbqty = '';
  String clbqtyuom = '';
  String clbrate = '';
  String clbrateuom = '';
  String clbamount = '';
  String chlanno = '';
  String date = '';
  String itemname = '';
  bool isHeader;
  bool isViewing;

  RecPurchaseBillModel({
    this.catalogitem = '',
    this.partyitemname = '',
    this.partypo = '',
    this.bags = '',
    this.qty = '',
    this.quom = '',
    this.rate = '',
    this.ruom = '',
    this.itemamount = '',
    this.clbqty = '',
    this.clbqtyuom = '',
    this.clbrate = '',
    this.clbrateuom = '',
    this.clbamount = '',
    this.chlanno = '',
    this.date = '',
    this.itemname = '',
    this.isHeader = false,
    this.isViewing = false,
  });

  factory RecPurchaseBillModel.parsejson(Map<String, dynamic> data) {
    return RecPurchaseBillModel(
      catalogitem: getString(data['catalog_item'], 'catalog_code'),
      partyitemname: getString(data, 'party_item_name'),
      partypo: getString(data, 'p_order_no'),
      bags: getString(data, 'bags'),
      qty: getString(data, 'qty'),
      quom: getString(data['qty_unit_name'], 'abv'),
      rate: getString(data, 'rate'),
      ruom: getString(data['rate_unit_name'], 'abv'),
      itemamount: getString(data, 'item_amount'),
      clbqty: getString(data, 'clb_qty'),
      clbqtyuom: getString(data['clb_qty_unit_name'], 'name'),
      clbrate: getString(data, 'clb_rate'),
      clbrateuom: getString(data['clb_rate_unit_name'], 'name'),
      clbamount: getString(data, 'clb_amount'),
      chlanno: data['sale_challan_detail'] != null
          ? getString(data['sale_challan_detail']['challan_hdr'], 'doc_no')
          : '',
      date: data['sale_challan_detail'] != null
          ? getString(data['sale_challan_detail']['challan_hdr'], 'doc_date')
          : '',
      itemname: getString(data['catalog_item'], 'catalog_name'),
    );
  }
}
