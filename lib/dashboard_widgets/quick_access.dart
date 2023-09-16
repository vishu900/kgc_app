import 'package:dataproject2/attendance/Attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Stock_opening/company_list_page.dart';
import '../cash_payment/search_payment_company_selection.dart';
import '../cash_payment/search_receipt_company_selection.dart';
import '../production_planning/company_list_pp.dart';
import '../production_report/company_list_page.dart';
import '../productionview/CompaniesScreen.dart';
import '../saleEnquiry/SaleEnquiry.dart';

class QuickAccess{
  Widget quickAccess(var permList, var index, var context, var cardRadius, imgHeight, imgWidth, sizeb, userid) {

    switch (permList[index]) {
      case 'ATTENDANCE':

      /// ATTENDANCE
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Attendance()));
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
                          'images/attendance.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Attendance',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }



      case 'CASH_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CashCompSelection()));
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
                          'images/payment-method.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Payment',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }

      case 'CASH_RECEIPT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashRecCompSelection()));
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
                          'images/receipt.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Receipt',
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
