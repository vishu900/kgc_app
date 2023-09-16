import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Commons/Commons.dart';
import '../account_master_approval/account_approvalparty.dart';
import '../bankPayment/BankPaymentCompanySelection.dart';
import '../bomscreen/companyselection2.dart';
import '../cash_payment/cash_payments_approval_comp_selection.dart';
import '../cash_payment/cash_receipt_approval_comp_selection.dart';
import '../cash_payment/search_payment_company_selection.dart';
import '../company_selection.dart';
import '../indent/IndentCompanySelection.dart';
import '../purchaseBillApproval/pur_bill_comp_selection.dart';
import '../purchaseOrder/PurchaseCompanySelection.dart';

class Accountings{
  Widget accountings(var permList, var index, var context, var cardRadius, imgHeight, imgWidth,
      sizeb, userid, accMasterApprovalCount, bankCount, name, cashPaymentApprovalCount, cashReceiptApprovalCount,
      indentCount, poCount, counter, bomcounter, pendingApprovalCount){
    switch (permList[index]) {

      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$cashReceiptApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }

      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$cashReceiptApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }
      case 'ACC_MST_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountApprovalParty()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/account_approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    accMasterApprovalCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$accMasterApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Account Master\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }

      case 'BANK_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              bankCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BankPaymentCompanySelection(
                    userId: userid,
                    name: name,
                  )))
                  : Commons.showToast('No Bank Payment is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/bankpayment.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    bankCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$bankCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Bank\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }



      case 'CASH_PAYMENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashPaymentApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/payment.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashPaymentApprovalCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$cashPaymentApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Payment\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case 'INDENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              indentCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IndentCompanySelection(
                    userId: userid,
                    name: name,
                  )))
                  : Commons.showToast('No Indent Report is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/indent_report.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    indentCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$indentCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Indent\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      case 'PO_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              poCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurchaseCompanySelection(
                    userId: userid,
                    name: name,
                  )))
                  : Commons.showToast('No Purchase Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/purchaseorder.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    poCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$poCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      case 'SALE_ORDER_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              counter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection(
                        userid: userid,
                        name: name,
                      )))
                  : Commons.showToast('No Sale Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/saleorder.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    counter != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      case 'SO_BOM_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              print('bom Clciked');

              bomcounter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection2(
                        userid: userid,
                        name: name,
                      )))
                  : Commons.showToast('No BOM Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/bom.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    bomcounter != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$bomcounter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale Order\nBom Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      case 'PUR_BILL_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurBillCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/tracker.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    pendingApprovalCount != 0
                        ? new Positioned(
                      right: 2,
                      top: 5,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                          '$pendingApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase Bill Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      default:
        return Text('INVALID PERM');
    }

  }

}