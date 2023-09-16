import 'dart:convert';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'cash_payment_approval.dart';

class PendingBillForPayment extends StatefulWidget {
  final String? compId;
  final String? partyCode;
  final List<PendingBillModel>? selectedItemList;

  const PendingBillForPayment({
    Key? key,
    required this.compId,
    this.partyCode,
    this.selectedItemList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingBillForPayment();
}

class _PendingBillForPayment extends State<PendingBillForPayment>
    with NetworkResponse {
  final vspacer = SizedBox(height: 20);
  final hspacer = SizedBox(width: 20);
  List<PendingBillModel> pendingbilllist = [];
  List<PaymentDetailModel> paymentDetailList = [];
  List<PurchaseBillModel> purchaseBillList = [];
  TextEditingController _chlannocontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _gatesrlcontroller = TextEditingController();
  TextEditingController _itemnamecontroller = TextEditingController();
  String partyCode = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPendingBills();
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
                      args: pendingbilllist
                          .where((element) => element.isSelected));
                },
              ),
              title: Text('Pending Bill For Payments'),
            ),
            body: pendingbilllist.isEmpty
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
                          /// Table
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
                          if (paymentDetailList.isEmpty)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          if (purchaseBillList.isEmpty)
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

                          /// Challan No,Date,Gate Srl
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

                              /// Gate Srl
                              Flexible(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _gatesrlcontroller,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Gate Srl',
                                    isDense: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                          vspacer,

                          /// Item Name
                          Row(
                            children: [
                              Flexible(
                                  child: TextFormField(
                                readOnly: true,
                                controller: _itemnamecontroller,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Item Name',
                                    hintText: 'Item Name',
                                    isDense: true),
                              )),
                              hspacer,
                            ],
                          ),
                        ]))));
  }

  _getTotal(String type) {
    if (pendingbilllist.isEmpty)
      return '0';
    else {
      var res = pendingbilllist.where((element) => !element.isHeader);
      switch (type) {
        case 'Bill Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.billamount.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        // break;
        case 'Sale Comm':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.salecomm.toDouble();
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
        //  break;
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
        // break;
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
        case 'Due Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.dueamount1.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
        case 'Due Amount':
          {
            double count = 0.0;
            res.forEach((element) {
              count += element.dueamount2.toDouble();
            });
            return count.toStringAsFixed(2);
          }
        //  break;
      }
    }
  }

  _getPendingBills() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
      'acc_code': widget.partyCode
    };

    WebService.fromApi(AppConfig.pendingBillForPayments, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    if (requestCode == AppConfig.pendingBillForPayments) {
      var data = jsonDecode(response!);
      if (data['error'] == 'false') {
        var pendingbillcontent = data['bill_lists'] as List;
        //  _gatesrlcontroller.text = getString(data['due_dtls']['detail']['bill_items']['gate_entry_detail']['entry_hdr'], 'sr_no');

        pendingbilllist.addAll(pendingbillcontent
            .map((e) => PendingBillModel.parsejson(e))
            .toList());

        if (widget.selectedItemList != null) {
          for (int i = 0; i < widget.selectedItemList!.length; i++) {
            for (int k = 0; k < pendingbilllist.length; k++) {
              if (pendingbilllist[k].billnumber ==
                  widget.selectedItemList![i].billnumber) {
                pendingbilllist.removeAt(k);
              }
            }
          }

          pendingbilllist.where((element) => false);
        }
        if (pendingbilllist.isNotEmpty) {
          ///Header
          pendingbilllist.insert(
              0,
              PendingBillModel(
                  billnumber: 'Bill Number',
                  billdate: 'Bill Date',
                  duedate: 'Due Date',
                  billamount: 'Bill Amount',
                  salecomm: 'Sale Comm',
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
          pendingbilllist.add(PendingBillModel(
            billnumber: 'Total',
            billamount: _getTotal('Bill Amount'),
            salecomm: _getTotal('Sale Comm'),
            bank: _getTotal('Bank'),
            cash: _getTotal('Cash'),
            ret: _getTotal('Return'),
            tds: _getTotal('Tds'),
            salepur: _getTotal('Sale Pur'),
            b2b: _getTotal('B2B'),
            other: _getTotal('Other'),
            dueamount1: _getTotal('Due Amount'),
            dueamount2: _getTotal('Due Amount'),
          ));
        }

        setState(() {});
      }
    }
  }

  /// Vertically 1
  List<Widget> _buildCells1() {
    return List.generate(
        pendingbilllist.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (!pendingbilllist[index].isHeader &&
                    pendingbilllist[index] != pendingbilllist.last) {
                  logIt('${paymentDetailList.length}');
                  paymentDetailList.clear();
                  paymentDetailList
                      .addAll(pendingbilllist[index].paymentDetailList!);
                  setState(() {});
                }
              },
              child: Container(
                width: 130,
                height: 50,
                color: pendingbilllist[index].isHeader
                    ? AppColor.appRed
                    : pendingbilllist[index].isViewing
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
                                visible: !pendingbilllist[index].isHeader &&
                                    pendingbilllist.length - 1 != index &&
                                    pendingbilllist[index].doctype !=
                                        'OARECD' &&
                                    pendingbilllist[index].doctype != 'OAPAY',
                                child: Container(
                                  child: Checkbox(
                                      value: pendingbilllist[index].isSelected,
                                      onChanged: (v) {
                                        paymentDetailList.clear();
                                        paymentDetailList.addAll(
                                            pendingbilllist[index]
                                                .paymentDetailList!);
                                        setState(() {
                                          pendingbilllist[index].isSelected =
                                              !pendingbilllist[index]
                                                  .isSelected;
                                        });
                                      }),
                                ),
                              ),
                              Text(
                                pendingbilllist[index].billnumber.handleEmpty(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: pendingbilllist[index].isHeader
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          ))
                    ]),
              ),
            )));
  }

  /// Horizontally 1
  List<Widget> _buildRows1() {
    return List.generate(pendingbilllist.length,
        (index) => _eachRow1(pendingbilllist.length, index));
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                  child: Text(
                pendingbilllist[index].billdate.handleEmpty(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].duedate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Bill Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].billamount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Comm
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].salecomm.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].bank.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].cash.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].ret.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].tds.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].salepur.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].b2b.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].other.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].dueamount1.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
              color: pendingbilllist[index].isHeader
                  ? AppColor.appRed
                  : pendingbilllist[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(pendingbilllist[index].dueamount2.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: pendingbilllist[index].isHeader
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
        paymentDetailList.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (!paymentDetailList[index].isHeader &&
                    paymentDetailList[index] != paymentDetailList.last) {
                  purchaseBillList.clear();
                  purchaseBillList
                      .addAll(paymentDetailList[index].purchaseBillList!);
                  logIt('${purchaseBillList.length}');
                  setState(() {});
                }
              },
              child: Container(
                  width: 130,
                  height: 50,
                  color: paymentDetailList[index].isHeader
                      ? AppColor.appRed
                      : paymentDetailList[index].isViewing
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
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    paymentDetailList[index]
                                        .docno
                                        .handleEmpty(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: paymentDetailList[index].isHeader
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ))
                      ])),
            )));
  }

  /// Horizontally 2
  List<Widget> _buildRows2() {
    return List.generate(paymentDetailList.length,
        (index) => _eachRow2(paymentDetailList.length, index));
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].docdate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Pur
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].pur.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Sale Comm
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].salecomm.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].bank.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].cash.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].ret.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].tds.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].salepur.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].b2b.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
              color: paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(paymentDetailList[index].other.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: paymentDetailList[index].isHeader
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
        purchaseBillList.length,
        (index) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: InkWell(
              onTap: () {
                if (purchaseBillList[index] != purchaseBillList.last)
                  logIt('${'hello'}');
                _chlannocontroller.text = purchaseBillList[index].chlanno;
                _datecontroller.text = purchaseBillList[index].date;
                _gatesrlcontroller.text = purchaseBillList[index].gatesrl;
                _itemnamecontroller.text = purchaseBillList[index].item;
              },
              child: Container(
                  width: 130,
                  height: 50,
                  color: purchaseBillList[index].isHeader
                      ? AppColor.appRed
                      : purchaseBillList[index].isViewing
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
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    purchaseBillList[index]
                                        .catalogitem
                                        .handleEmpty(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: purchaseBillList[index].isHeader
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ))
                      ])),
            )));
  }

  /// Horizontally 3
  List<Widget> _buildRows3() {
    return List.generate(purchaseBillList.length,
        (index) => _eachRow3(purchaseBillList.length, index));
  }

  /// Total Cells in a row --->>>
  Container _eachRow3(int count, int index) {
    return Container(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
            child: Row(children: [
          /// Item Name
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 200,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].itemname.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Po No
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].pono.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Stock Qty
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].stockqty.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          ///SUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].suom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// finQty
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].finqty.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// FUom
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].fuom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
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
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].rate.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
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
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].ruom.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Item Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].itemamount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Other Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].otheramount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),

          /// Item Amount
          Padding(
            padding: EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 50,
              width: 130,
              color: purchaseBillList[index].isHeader
                  ? AppColor.appRed
                  : purchaseBillList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(purchaseBillList[index].itemamount.handleEmpty(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: purchaseBillList[index].isHeader
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          ),
        ])));
  }
}

class PendingBillModel {
  String billnumber = '';
  String billdate = '';
  String duedate = '';
  String billamount = '';
  String salecomm = '';
  String bank = '';
  String cash = '';
  String ret = '';
  String tds = '';
  String salepur = '';
  String b2b = '';
  String other = '';
  String dueamount1 = '';
  String dueamount2 = '';
  String docdate = '';
  String docno = '';
  String amount = '';
  String comp_code = '';
  String doc_table_name = '';
  String doc_type = '';
  String doc_table_pk = '';
  String acc_code = '';
  String doctype = '';
  String send_pur_hdr_pk = '';
  String send_bill_hdr_pk = '';
  String item_pay_amount = '';
  String item_code_pk = '';
  String codePk = '';
  bool isHeader;
  bool isViewing;
  bool isSelected;
  bool isLocal;
  List<PaymentDetailModel>? paymentDetailList;

  PendingBillModel({
    this.billnumber = '',
    this.billdate = '',
    this.duedate = '',
    this.billamount = '',
    this.salecomm = '',
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
    this.docdate = '',
    this.amount = '',
    this.comp_code = '',
    this.doc_table_name = '',
    this.doc_type = '',
    this.doc_table_pk = '',
    this.acc_code = '',
    this.doctype = '',
    this.send_pur_hdr_pk = '',
    this.send_bill_hdr_pk = '',
    this.item_pay_amount = '',
    this.item_code_pk = '',
    this.codePk = '',
    this.paymentDetailList,
  });

  factory PendingBillModel.parsejson(Map<String, dynamic> data) {
    ///  Payment Details Items
    List<PaymentDetailModel> paymentDetailList = [];
    _getDetailTotal(String type) {
      if (paymentDetailList.isEmpty)
        return '0';
      else {
        var res = paymentDetailList.where((element) => !element.isHeader);
        // int count = 0;
        switch (type) {
          case 'Pur':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.pur.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'Sale Comm':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.salecomm.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //  break;
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
          //  break;
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
          // break;
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
          // break;
          case 'Other':
            {
              res.forEach((element) {});
              // return count.toStringAsFixed(2);
            }
            break;
        }
      }
    }

    var paymentdetailcontent = data['due_dtls'] as List;

    paymentDetailList.addAll(paymentdetailcontent
        .map((e) => PaymentDetailModel.parsejson(e))
        .toList());

    if (paymentDetailList.isNotEmpty) {
      ///Header
      paymentDetailList.insert(
          0,
          PaymentDetailModel(
              docno: 'Doc No',
              docdate: 'Doc Date',
              pur: 'Pur',
              salecomm: 'Sale Comm',
              bank: 'Bank',
              cash: 'Cash',
              ret: 'Return',
              tds: 'Tds',
              salepur: 'Sale Pur',
              b2b: 'B2B',
              other: 'Other',
              isHeader: true));

      paymentDetailList.add(PaymentDetailModel(
        docno: 'Total',
        pur: _getDetailTotal('Pur')!,
        salecomm: _getDetailTotal('Sale Comm')!,
        bank: _getDetailTotal('Bank')!,
        cash: _getDetailTotal('Cash')!,
        ret: _getDetailTotal('Return')!,
        tds: _getDetailTotal('Tds')!,
        salepur: _getDetailTotal('Sale Pur')!,
        b2b: _getDetailTotal('B2B')!,
        other: _getDetailTotal('Other')!,
      ));
    }

    // String docno='';
    // String docdate='';
    // String comp_code='';
    // String doc_table_name='';
    // String doc_type='';
    // String doc_table_pk='';
    // String acc_code='';

    // pendingbilllist[index].doctype!=''&&pendingbilllist[index].doctype!='',
    var dtlObj = (getString(data, 'doc_type') == 'OARECD' ||
            getString(data, 'doc_type') == 'OAPAY')
        ? {}
        : data['bill_dtls'];

    return PendingBillModel(
      billnumber: getString(data, 'bill_no'),
      billdate: getString(data, 'bill_date'),
      duedate: getFormattedDate(getString(data, 'due_date'),
          outFormat: 'dd MMM yyyy '),
      billamount: getString(data, 'pur_amount'),
      salecomm: getString(data, 'sale_comm'),
      bank: getString(data, 'bank_amount'),
      cash: getString(data, 'cash_amount'),
      ret: getString(data, 'rtn_amount'),
      tds: getString(data, 'tds_amount'),
      salepur: getString(data, 'pur_sale_amount'),
      b2b: getString(data, 'bank2bank_amount'),
      other: getString(data, 'other_amount'),
      dueamount1: getString(data, 'due_cr_amount'),
      dueamount2: getString(data, 'due_dr_amount'),
      doctype: getString(data, 'doc_type'),
      send_pur_hdr_pk: getString(data, 'send_pur_hdr_pk'),
      send_bill_hdr_pk: getString(data, 'send_bill_hdr_pk'),
      item_pay_amount: getString(data, 'due_cr_amount'),
      docno: getString(dtlObj, 'doc_no'),
      docdate: getString(dtlObj, 'doc_date'),
      comp_code: getString(dtlObj, 'comp_code'),
      // doc_table_name:getString(dtlObj, 'doc_date'),
      // doc_type:getString(dtlObj, 'doc_date'),
      // doc_table_pk:getString(dtlObj, 'doc_date'),
      acc_code: getString(dtlObj, 'acc_code'),
      amount: getString(data, 'due_cr_amount'),
      codePk: getString(data['bill_dtls'], 'code_pk'),
      paymentDetailList: paymentDetailList,
    );
  }

  factory PendingBillModel.parseItems(Map<String, dynamic> data) {
    // var paymentdetailcontent = data['due_dtls'] as List;
    // paymentDetailList.addAll(paymentdetailcontent
    //     .map((e) => PaymentDetailModel.parsejson(e))
    //     .toList());
    // if (paymentDetailList.isNotEmpty){
    //   ///Header
    //   paymentDetailList.insert(
    //       0,
    //       PaymentDetailModel(
    //           docno: 'Doc No',
    //           docdate: 'Doc Date',
    //           pur: 'Pur',
    //           salecomm: 'Sale Comm',
    //           bank: 'Bank',
    //           cash: 'Cash',
    //           ret: 'Return',
    //           tds: 'Tds',
    //           salepur: 'Sale Pur',
    //           b2b: 'B2B',
    //           other: 'Other',
    //           isHeader: true));
    //
    //   paymentDetailList.add(
    //       PaymentDetailModel(
    //         docno: 'Total',
    //         pur :_getDetailTotal('Pur'),
    //         salecomm:_getDetailTotal('Sale Comm'),
    //         bank:_getDetailTotal('Bank'),
    //         cash: _getDetailTotal('Cash'),
    //         ret:_getDetailTotal ('Return'),
    //         tds: _getDetailTotal('Tds'),
    //         salepur:_getDetailTotal('Sale Pur'),
    //         b2b: _getDetailTotal('B2B'),
    //         other: _getDetailTotal('Other'),
    //
    //       ));
    // }
    return PendingBillModel(
        billnumber: getString(data['pur_bill_hdr_details'], 'bill_no'),
        billdate: getString(data['pur_bill_hdr_details'], 'bill_date'),
        duedate: getFormattedDate(getString(data, 'due_date'),
            outFormat: 'dd MMM yyyy '),
        billamount: getString(data['pur_bill_hdr_details'], 'net_amount'),
        salecomm: getString(data, 'sale_comm'),
        bank: getString(data, 'bank_amount'),
        cash: getString(data, 'cash_amount'),
        ret: getString(data, 'rtn_amount'),
        tds: getString(data, 'tds_amount'),
        salepur: getString(data, 'pur_sale_amount'),
        b2b: getString(data, 'bank2bank_amount'),
        other: getString(data, 'other_amount'),
        dueamount1: getString(data, 'due_cr_amount'),
        dueamount2: getString(data, 'due_dr_amount'),
        doctype: getString(data, 'doc_type'),
        send_pur_hdr_pk: getString(data, 'pur_bill_hdr_pk'),
        send_bill_hdr_pk: getString(data, 'sale_bill_hdr_pk'),
        item_pay_amount: getString(data, 'due_cr_amount'),
        item_code_pk: getString(data, 'code_pk'),
        docno: getString(data['pur_bill_hdr_details'], 'doc_no'),
        docdate: getString(data['pur_bill_hdr_details'], 'doc_date'),
        comp_code: getString(data, 'comp_code'),
        acc_code: getString(data, 'acc_code'),
        amount: getString(data, 'pay_amount'),
        codePk: getString(data, 'code_pk'),
        isLocal: false);
  }
}

class PaymentDetailModel {
  String docno = '';
  String docdate = '';
  String pur = '';
  String salecomm = '';
  String bank = '';
  String cash = '';
  String ret = '';
  String tds = '';
  String salepur = '';
  String b2b = '';
  String comp_code = '';
  String doc_table_name = '';
  String doc_type = '';
  String doc_table_pk = '';
  String acc_code = '';
  String other = '';
  bool isHeader;
  bool isViewing;
  List<PurchaseBillModel>? purchaseBillList;

  PaymentDetailModel(
      {this.docno = '',
      this.docdate = '',
      this.pur = '',
      this.salecomm = '',
      this.bank = '',
      this.cash = '',
      this.ret = '',
      this.tds = '',
      this.salepur = '',
      this.b2b = '',
      this.other = '',
      this.comp_code = '',
      this.doc_table_name = '',
      this.doc_type = '',
      this.doc_table_pk = '',
      this.acc_code = '',
      this.isHeader = false,
      this.isViewing = false,
      this.purchaseBillList});

  factory PaymentDetailModel.parsejson(Map<String, dynamic> data) {
    /// Purchase bill Items
    List<PurchaseBillModel> purchaseBillList = [];
    _getBillTotal(String type) {
      if (purchaseBillList.isEmpty)
        return '0';
      else {
        var res = purchaseBillList.where((element) => !element.isHeader);
        switch (type) {
          case 'Stock Qty':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.stockqty.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          // break;
          case 'Fin Qty':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.finqty.toDouble();
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
          //  break;
          case 'Other Amount':
            {
              double count = 0.0;
              res.forEach((element) {
                count += element.otheramount.toDouble();
              });
              return count.toStringAsFixed(2);
            }
          //  break;
        }
      }
    }

    var detailObj = data['detail'];
    if (detailObj == null) {
      detailObj = {};
    }
    var purchasebillcontent = detailObj['bill_items'] as List?;
    if (purchasebillcontent != null) {
      purchaseBillList.addAll(purchasebillcontent
          .map((e) => PurchaseBillModel.parsejson(e))
          .toList());
    }
    if (purchaseBillList.isNotEmpty) {
      ///Header
      purchaseBillList.insert(
          0,
          PurchaseBillModel(
              catalogitem: 'Catalog Item',
              itemname: 'Item Name',
              pono: 'Po No',
              stockqty: 'Stock Qty',
              suom: 'Uom',
              finqty: 'Fin Qty',
              fuom: 'Uom',
              rate: 'Rate',
              ruom: 'Uom',
              itemamount: 'Item Amount',
              otheramount: 'Other Amount',
              isHeader: true));
      purchaseBillList.add(PurchaseBillModel(
        catalogitem: 'Total',
        stockqty: _getBillTotal('Stock Qty')!,
        finqty: _getBillTotal('Fin Qty')!,
        itemamount: _getBillTotal('Item Amount')!,
        otheramount: _getBillTotal('Other Amount')!,
      ));
    }

    return PaymentDetailModel(
      docno: getString(data['detail'], 'doc_no'),
      docdate: getString(data['detail'], 'doc_date'),
      pur: getString(data, 'pur_amount'),
      salecomm: getString(data, 'sale_comm'),
      bank: getString(data, 'bank_amount'),
      cash: getString(data, 'cash_amount'),
      ret: getString(data, 'rtn_amount'),
      tds: getString(data, 'tds_amount'),
      salepur: getString(data, 'pur_sale_amount'),
      b2b: getString(data, 'bank2bank_amount'),
      other: getString(data, 'other_amount'),
      comp_code: getString(data, 'comp_code'),
      doc_table_name: getString(data, 'doc_table_name'),
      doc_type: getString(data, 'doc_type'),
      doc_table_pk: getString(data, 'doc_table_pk'),
      acc_code: getString(data, 'acc_code'),
      purchaseBillList: purchaseBillList,
    );
  }
}

class PurchaseBillModel {
  String catalogitem = '';
  String itemname = '';
  String pono = '';
  String stockqty = '';
  String suom = '';
  String finqty = '';
  String fuom = '';
  String rate = '';
  String ruom = '';
  String itemamount = '';
  String otheramount = '';
  String chlanno = '';
  String date = '';
  String gatesrl = '';
  String item = '';
  bool isHeader;
  bool isViewing;

  PurchaseBillModel({
    this.catalogitem = '',
    this.itemname = '',
    this.pono = '',
    this.stockqty = '',
    this.suom = '',
    this.finqty = '',
    this.fuom = '',
    this.rate = '',
    this.ruom = '',
    this.itemamount = '',
    this.otheramount = '',
    this.chlanno = '',
    this.date = '',
    this.gatesrl = '',
    this.item = '',
    this.isHeader = false,
    this.isViewing = false,
  });

  factory PurchaseBillModel.parsejson(Map<String, dynamic> data) {
    return PurchaseBillModel(
      catalogitem: getString(data['catalog_item'], 'catalog_code'),
      itemname: getString(data['catalog_item'], 'catalog_name'),
      pono: getString(data['po_item_detail']['item_hedaer'], 'order_no'),
      stockqty: getString(data, 'stock_qty'),
      suom: getString(data['stock_unit_name'], 'abv'),
      finqty: getString(data, 'fin_qty'),
      fuom: getString(data['finqty_unit_name'], 'abv'),
      rate: getString(data, 'rate'),
      ruom: getString(data['rate_unit_name'], 'abv'),
      itemamount: getString(data, 'item_amount'),
      otheramount: (int.parse(getString(data, 'other_amount_1')) +
              int.parse(getString(data, 'other_amount_2')) +
              int.parse(getString(data, 'other_amount_3')))
          .toString(),
      chlanno: getString(data['gate_entry_detail'], 'chl_no'),
      date: getString(data['gate_entry_detail'], 'chl_date'),
      gatesrl:
          getString(data['gate_entry_detail']['entry_hdr_single'], 'doc_no'),
      item: getString(data['item_name'], 'name'),
    );
  }
}
