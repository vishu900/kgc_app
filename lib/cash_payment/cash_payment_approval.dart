import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';

class CashPaymentApproval extends StatefulWidget {
  final String? compId;
  final String? empid;
  final String? type;

  const CashPaymentApproval(
      {Key? key, required this.compId, companycode, this.type, this.empid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CashPaymentApproval();
}

class _CashPaymentApproval extends State<CashPaymentApproval>
    with NetworkResponse {
  final vspacer = SizedBox(
    height: 16,
  );
  final hspacer = SizedBox(
    width: 16,
  );
  List<PaymentApprovalModel> paymentapprlist = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPaymentApproval();
      logIt('${widget.compId}');
      logIt('${widget.type}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cash Payment Approval')),
      body: PageView.builder(
        itemCount: paymentapprlist.length,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child:

                      /// Cash Receipt
                      Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Center(
                        child: Text(
                          'Cash Payment-' +
                              (index + 1).toString() +
                              "/" +
                              paymentapprlist.length.toString(),
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].docdate,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].docfinyear,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].docno,
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
                        height: 32,
                        width: 180,
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
                        //height: 32,
                        width: 180,
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
                            paymentapprlist[index].party,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].paytype,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].amount,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].onaccamount,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].agbillamount,
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].approveduser,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        //height: 32,
                        width: 180,
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
                            paymentapprlist[index].remarks.handleEmpty(),
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          paymentapprlist[index].insdate,
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
                      height: 32,
                      width: 180,
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
                          'Created By',
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
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 8),
                        child: Text(
                          paymentapprlist[index].insuser,
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
                    itemCount: paymentapprlist[index].paymenttablelist!.length,
                    itemBuilder: (BuildContext context, int subindex) =>
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child:

                                /// Items
                                Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    'Items -' +
                                        (subindex + 1).toString() +
                                        "/" +
                                        paymentapprlist[index]
                                            .paymenttablelist!
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
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
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 8),
                                    child: Text(
                                      paymentapprlist[index]
                                          .paymenttablelist![subindex]
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

                          /// Doc date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    'Doc date',
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    paymentapprlist[index]
                                        .paymenttablelist![subindex]
                                        .docdate,
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

                          /// Bill Number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    paymentapprlist[index]
                                        .paymenttablelist![subindex]
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    paymentapprlist[index]
                                        .paymenttablelist![subindex]
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    paymentapprlist[index]
                                        .paymenttablelist![subindex]
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                  child: Text(
                                    paymentapprlist[index]
                                        .paymenttablelist![subindex]
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
                          vspacer,
                        ])),

                /// Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      height: 32,
                      width: 180,
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
                                  paymentapprlist[index].paymenttablelist!)
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
                      height: 32,
                      width: 180,
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
                      height: 32,
                      width: 180,
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
                          _getDiffAmt(paymentapprlist[index].paymenttablelist!,
                                  paymentapprlist[index])
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    child: Text('Print Cash Receipt',
                        style: TextStyle(fontSize: 16))),

                /// Approve
                Visibility(
                  visible: ifHasPermission(
                      compCode: widget.compId,
                      permission: Permissions.CASH_PAYMENT,
                      permType: PermType.MODIFIED)!,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          showAlert(
                              context,
                              'Are You sure You Want to Approve this Cash Payment?',
                              'Confirmation',
                              ok: 'Ok',
                              onOk: () {
                                _approveItem(paymentapprlist[index].id);
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  double _getItemTotal(List<PaymentTableModel> itemList) {
    double amount = 0.0;
    try {
      itemList.forEach((element) {
        amount += int.parse(element.billamount);
      });
      return amount;
    } catch (err) {
      return 0;
    }
  }

  double _getDiffAmt(
      List<PaymentTableModel> itemList, PaymentApprovalModel mainModel) {
    return double.parse(mainModel.amount) - _getItemTotal(itemList);
  }

  _getPaymentApproval() {
    Map jsonBody = {
      'user_id': getUserId(),
      'comp_code': widget.compId,
    };
    if (widget.type == 'emp') {
      jsonBody.addAll({
        'search_user_id': widget.empid,
      });
    }

    WebService.fromApi(AppConfig.paymentreceiptapproval, this, jsonBody)
        .callPostService(context);
  }

  _approveItem(String id) {
    Map jsonBody = {'user_id': getUserId(), 'code_pk': id};

    logIt('ApproveItem-> $jsonBody');

    WebService.fromApi(AppConfig.approveCashPayItem, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.paymentreceiptapproval:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            paymentapprlist.clear();
            var receiptapprcontent = data['content'] as List;
            paymentapprlist.addAll(receiptapprcontent
                .map((e) => PaymentApprovalModel.parsejson(e))
                .toList());
            setState(() {});
          }
        }
        break;
      case AppConfig.approveCashPayItem:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              _getPaymentApproval();
            });
          } else {
            showAlert(context, data['message'], 'Failed');
          }
        }
    }
  }
}

class PaymentApprovalModel {
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
  String codepk = '';
  String acccode = '';
  String insdate = '';
  String insuser = '';
  String codePk = '';
  List<PaymentTableModel>? paymenttablelist = [];

  PaymentApprovalModel(
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
      this.codepk = '',
      this.acccode = '',
      this.insdate = '',
      this.insuser = '',
      this.codePk = '',
      this.paymenttablelist});

  factory PaymentApprovalModel.parsejson(Map<String, dynamic> data) {
    List<PaymentTableModel> paymenttablelist = [];
    var paymenttablecontent = data['payment_items'] as List;
    paymenttablelist.addAll(paymenttablecontent
        .map((e) => PaymentTableModel.parsejson(e))
        .toList());
    return PaymentApprovalModel(
        docdate: getString(data, 'doc_date'),
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
        codePk: getString(data, 'code_pk'),
        paymenttablelist: paymenttablelist);
  }
}

class PaymentTableModel {
  String docno = '',
      docdate = '',
      billno = '',
      billdate = '',
      billamount = '',
      amount = '',
      diffamount = '';

  PaymentTableModel(
      {this.docno = '',
      this.docdate = '',
      this.billno = '',
      this.billdate = '',
      this.billamount = '',
      this.amount = '',
      this.diffamount = ''});

  factory PaymentTableModel.parsejson(Map<String, dynamic> data) {
    return PaymentTableModel(
      docno: getString(data['pur_bill_hdr_details'], 'doc_no'),
      docdate: getString(data['pur_bill_hdr_details'], 'doc_date'),
      billno: getString(data['pur_bill_hdr_details'], 'bill_no'),
      billdate: getString(data['pur_bill_hdr_details'], 'bill_date'),
      billamount: getString(data['pur_bill_hdr_details'], 'net_amount'),
      amount: getString(data, 'pay_amount'),
      // diffamount :
      //     (int.parse(amount) - int.parse('billamount'))
      //         .toString()
    );
  }
}
