import 'dart:convert';
import 'dart:core';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

class CashReceiptApproval extends StatefulWidget {
  final String? compId;
  final String? empid;
  final String? type;
  const CashReceiptApproval(
      {Key? key, required this.compId, this.empid, this.type})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CashReceiptApproval();
}

class _CashReceiptApproval extends State<CashReceiptApproval>
    with NetworkResponse {
  final vspacer = SizedBox(
    height: 16,
  );
  final hspacer = SizedBox(
    width: 16,
  );
  List<ReceiptApprovalModel> receiptapprlist = [];
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getReceiptApproval();
      logIt('${widget.compId}');
      logIt('${widget.type}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cash Receipt Approval')),
        body: PageView.builder(
            itemCount: receiptapprlist.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    /// Cash Receipt
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Center(
                            child: Text(
                              'Cash Receipt -' +
                                  (index + 1).toString() +
                                  "/" +
                                  receiptapprlist.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    vspacer,

                    /// Doc Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Doc Date',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].docdate,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Doc FinYear
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Doc FinYear',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].docfinyear,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Doc No
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Doc No',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].docno,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Party
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 34,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Party',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 34,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                receiptapprlist[index].party,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///Payment Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Payment Type',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].paytype,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].amount,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// On Acc Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              ' On Acc Amount',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].onaccamount,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Against Bill Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              ' Against Bill Amount',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].agbillamount,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Approval User
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Approval User',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].approveduser,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Remarks
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 34,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                'Remarks',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 34,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.5,
                                color: Color(0xFF766F6F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, top: 8),
                              child: Text(
                                receiptapprlist[index].remarks.handleEmpty(),
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Inserted Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Inserted Date',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].insdate,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Created By
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Created  By',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              receiptapprlist[index].insuser,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    vspacer,

                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            receiptapprlist[index].receipttablelist!.length,
                        itemBuilder: (BuildContext context, int subindex) =>
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child:

                                        ///Item
                                        Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            'Items -' +
                                                (subindex + 1).toString() +
                                                "/" +
                                                receiptapprlist[index]
                                                    .receipttablelist!
                                                    .length
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  vspacer,

                                  /// Doc Number
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            'Doc No',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 32,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 0.5,
                                              color: Color(0xFF766F6F),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 8),
                                            child: Text(
                                              receiptapprlist[index]
                                                  .receipttablelist![subindex]
                                                  .docno,
                                              style: TextStyle(
                                                backgroundColor: Colors.white,
                                                color: Color(0xFF2e2a2a),
                                                fontFamily: 'Roboto',
                                                fontSize: 12,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),

                                  /// Bill Number
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            'Bill Number',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            receiptapprlist[index]
                                                .receipttablelist![subindex]
                                                .billno,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Bill Date
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            'Bill Date',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            receiptapprlist[index]
                                                .receipttablelist![subindex]
                                                .billdate,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Bill Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            'Bill Amount',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            receiptapprlist[index]
                                                .receipttablelist![subindex]
                                                .billamount,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            'Amount',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 32,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 0.5,
                                            color: Color(0xFF766F6F),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 8),
                                          child: Text(
                                            receiptapprlist[index]
                                                .receipttablelist![subindex]
                                                .amount,
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                              color: Color(0xFF2e2a2a),
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                    vspacer,

                    /// Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Total Amount',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              _getItemTotal(
                                      receiptapprlist[index].receipttablelist!)
                                  .toString(),
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Diff  Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Diff Amount',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              _getDiffAmt(
                                      receiptapprlist[index].receipttablelist!,
                                      receiptapprlist[index])
                                  .toString(),
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    vspacer,

                    /// Print Cash Receipt
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red), // background),
                        onPressed: () {},
                        child: Text('Print Cash Receipt',
                            style: TextStyle(fontSize: 16))),

                    /// Approve
                    Visibility(
                      visible: ifHasPermission(
                          compCode: widget.compId,
                          permission: Permissions.CASH_PAYMENT,
                          permType: PermType.MODIFIED)!,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            showAlert(
                                context,
                                'Are You sure You Want to Approve this Cash Receipt?',
                                'Confirmation',
                                ok: 'Ok',
                                onOk: () {
                                  _approve(receiptapprlist[index].id);
                                },
                                notOk: 'Cancel',
                                onNo: () {
                                  popIt(context);
                                });
                          },
                          child: Text(
                            'Approve',
                            style: TextStyle(fontSize: 16),
                          )),
                    )
                  ],
                ),
              ));
            }));
  }

  double _getItemTotal(List<ReceiptTableModel> itemList) {
    double amount = 0;
    try {
      itemList.forEach((element) {
        amount += double.parse(element.billamount);
      });
      return amount;
    } catch (err) {
      return 0.0;
    }
  }

  double _getDiffAmt(
      List<ReceiptTableModel> itemList, ReceiptApprovalModel mainModel) {
    return double.parse(mainModel.amount) - _getItemTotal(itemList);
  }

  _getReceiptApproval() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }
    WebService.fromApi(AppConfig.cashreceiptapproval, this, jsonBody)
        .callPostService(context);
  }

  _approve(String id) {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': id};

    logIt('ApproveItem-> $jsonBody');

    WebService.fromApi(AppConfig.approveCashReceipt, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.cashreceiptapproval:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            receiptapprlist.clear();
            var receiptapprcontent = data['content'] as List;
            receiptapprlist.addAll(receiptapprcontent
                .map((e) => ReceiptApprovalModel.parsejson(e))
                .toList());
            setState(() {});
          }
        }
        break;
      case AppConfig.approveCashReceipt:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              _getReceiptApproval();
            });
          } else {
            showAlert(context, data['message'], 'Failed');
          }
        }
    }
  }
}

class ReceiptApprovalModel {
  String docdate = '';
  String docfinyear = '';
  String docno = '';
  String party = '';
  String paytype = '';
  String amount = '';
  String onaccamount = '';
  String agbillamount = '';
  String approveduser = '';
  String remarks = '';
  String id = '';
  String acccode = '';
  String insdate = '';
  String insuser = '';
  String codePk = '';
  List<ReceiptTableModel>? receipttablelist = [];

  ReceiptApprovalModel(
      {this.docdate = '',
      this.docfinyear = '',
      this.docno = '',
      this.party = '',
      this.paytype = '',
      this.amount = '',
      this.onaccamount = '',
      this.agbillamount = '',
      this.approveduser = '',
      this.remarks = '',
      this.id = '',
      this.acccode = '',
      this.insdate = '',
      this.insuser = '',
      this.codePk = '',
      this.receipttablelist});

  factory ReceiptApprovalModel.parsejson(Map<String, dynamic> data) {
    List<ReceiptTableModel> receipttablelist = [];
    var receipttablecontent = data['payment_items'] as List;
    receipttablelist.addAll(receipttablecontent
        .map((e) => ReceiptTableModel.parsejson(e))
        .toList());
    return ReceiptApprovalModel(
        docdate: getString(data, 'doc_date'),
        codePk: getString(data, 'code_pk'),
        docfinyear: getString(data, 'doc_finyear'),
        docno: getString(data, 'doc_no'),
        party: getString(data['party_detail'], 'name'),
        paytype: getString(data['payment_type_detail'], 'name'),
        amount: getString(data, 'pay_amount'),
        onaccamount: getString(data, 'on_acc_amount'),
        agbillamount: getString(data, 'ag_bill_amount'),
        approveduser: getString(data, 'approval_uid'),
        remarks: getString(data, 'remarks'),
        id: getString(data, 'code_pk'),
        acccode: getString(data, 'acc_code'),
        insdate: getString(data, 'ins_date'),
        insuser: getString(data['insert_user'], 'name'),
        receipttablelist: receipttablelist);
  }
}

class ReceiptTableModel {
  String docno = '';
  String docdate = '';
  String billno = '';
  String billdate = '';
  String billamount = '';
  String amount = '';
  String diffamount = '';

  ReceiptTableModel(
      {this.docno = '',
      this.docdate = '',
      this.billno = '',
      this.billdate = '',
      this.billamount = '',
      this.amount = '',
      this.diffamount = ''});

  factory ReceiptTableModel.parsejson(Map<String, dynamic> data) {
    return ReceiptTableModel(
      docno: getString(
          data['sale_bill_hdr_details']['single_order_items']
              ['sale_challan_detail']['challan_hdr'],
          'doc_no'),

      ///ToDo Confirm with Backend
      billno: getString(data['sale_bill_hdr_details'], 'bill_no'),
      billdate: getString(data['sale_bill_hdr_details'], 'bill_date'),
      billamount: getString(data['sale_bill_hdr_details'], 'net_amount'),
      amount: getString(data, 'receipt_amount'),
    );
  }
}
