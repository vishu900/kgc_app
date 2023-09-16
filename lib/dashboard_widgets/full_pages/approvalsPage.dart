import 'package:flutter/material.dart';

import '../accountings.dart';

class ApprovalsPage extends StatefulWidget {

  var containerHeading, accountingList,
  sizeb,
  userid,
  accMasterApprovalCount,
  bankCount,
  name,
  cashPaymentApprovalCount,
  cashReceiptApprovalCount,
  indentCount,
  poCount,
  counter,
  bomcounter,
  pendingApprovalCount, length;

  ApprovalsPage({Key? key, required this.containerHeading, required this.accountingList,
  required this.sizeb,
  required this.userid,
  required this.accMasterApprovalCount,
  required this.bankCount,
  required this.name,
  required this.cashPaymentApprovalCount,
  required this.cashReceiptApprovalCount,
  required this.indentCount,
  required this.poCount,
  required this.counter,
  required this.bomcounter,
  required this.pendingApprovalCount, required this.length}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approvals"),
      ),
      body:   Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 25,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: List.generate(
                widget.length, (index) => Accountings().accountings(widget.accountingList, index, context, 22.0, 22.0, 22.0, widget.sizeb, widget.userid, widget.accMasterApprovalCount, widget.bankCount, widget.name, widget.cashPaymentApprovalCount, widget.cashReceiptApprovalCount,
                widget.indentCount, widget.poCount, widget.counter, widget.bomcounter, widget.pendingApprovalCount))),
      ),
    );
  }
}
