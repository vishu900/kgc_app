import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'PaymentDetailModel.dart';

class PaymentDetail extends StatefulWidget {
  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  List<PaymentDetailModel> _paymentDetailList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _paymentDetailList.add(PaymentDetailModel(
        docNo: 'Doc No',
        docDate: 'Doc Date',
        isHeader: true,
        otherAmount: 'Other Amount',
        bankAmount: 'Bank Amount',
        cashAmount: 'Cash Amount',
        purAmount: 'Pur Amount',
        purSaleAmount: 'Pur Sale Amount',
        rtnAmount: 'Rtn Amount',
        tdsAmount: 'TDS Amount'));

    for (int i = 0; i < 8; i++) {
      _paymentDetailList.add(PaymentDetailModel(
          docNo: '$i',
          docDate: '25 May 2021',
          otherAmount: '0',
          bankAmount: '250010',
          cashAmount: '0',
          purAmount: '0',
          purSaleAmount: '0',
          rtnAmount: '0',
          tdsAmount: '0'));
    }

    /// Types are -> PurAmount, BankAmount, CashAmount,
    /// RtnAmount, TDSAmount, PurSaleAmount, OtherAmount
    _paymentDetailList.add(PaymentDetailModel(
        docNo: 'Total',
        otherAmount: _getTotal('OtherAmount'),
        bankAmount: _getTotal('BankAmount'),
        cashAmount: _getTotal('CashAmount'),
        purAmount: _getTotal('PurAmount'),
        purSaleAmount: _getTotal('PurSaleAmount'),
        rtnAmount: _getTotal('RtnAmount'),
        tdsAmount: _getTotal('TDSAmount')));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Detail'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildCells(_paymentDetailList.length),
            ),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildRows(_paymentDetailList.length),
                ),
              ),
            ),
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
        child: Container(
            width: 124,
            height: 48,
            color: _paymentDetailList[mainIndex].isHeader
                ? AppColor.appRed
                : _paymentDetailList[mainIndex].isViewing
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
                        _paymentDetailList[mainIndex].docNo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: _paymentDetailList[mainIndex].isHeader
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
          /// Doc Date
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].docDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Pur Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].purAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Bank Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].bankAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Cash Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].cashAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Rtn Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].rtnAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Tds Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].tdsAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),

          /// Pur Sale Amount
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Container(
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].purSaleAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
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
              height: 48,
              width: width + 24,
              color: _paymentDetailList[index].isHeader
                  ? AppColor.appRed
                  : _paymentDetailList[index].isViewing
                      ? AppColor.appRed[500]
                      : Colors.red[100],
              child: Center(
                child: Text(
                  _paymentDetailList[index].otherAmount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: _paymentDetailList[index].isHeader
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

  /// Types are -> PurAmount, BankAmount, CashAmount,
  /// RtnAmount, TDSAmount, PurSaleAmount, OtherAmount
  _getTotal(String type) {
    if (_paymentDetailList.isEmpty)
      return '0';
    else {
      var res = _paymentDetailList.where((element) => !element.isHeader);
      int count = 0;

      switch (type) {
        case 'PurAmount':
          {
            res.forEach((element) {
              count += element.purAmount.toInt();
            });
            return count.toString();
          }
        //  break;

        case 'BankAmount':
          {
            res.forEach((element) {
              count += element.bankAmount.toInt();
            });
            return count.toString();
          }
        // break;

        case 'CashAmount':
          {
            res.forEach((element) {
              count += element.cashAmount.toInt();
            });
            return count.toString();
          }
        //  break;

        case 'RtnAmount':
          {
            res.forEach((element) {
              count += element.rtnAmount.toInt();
            });
            return count.toString();
          }
        // break;

        case 'TDSAmount':
          {
            res.forEach((element) {
              count += element.tdsAmount.toInt();
            });
            return count.toString();
          }
        //  break;

        case 'PurSaleAmount':
          {
            res.forEach((element) {
              count += element.purSaleAmount.toInt();
            });
            return count.toString();
          }
        // break;

        case 'OtherAmount':
          {
            res.forEach((element) {
              count += element.otherAmount.toInt();
            });
            return count.toString();
          }
        //  break;
      }
    }
  }
}
