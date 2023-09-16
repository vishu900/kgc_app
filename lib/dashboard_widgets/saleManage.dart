import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../quotation/SearchSaleQuotation.dart';
import '../saleEnquiry/SaleEnquiry.dart';

class SaleManage{
  Widget saleManage(permList, index, context, cardRadius, imgHeight, imgWidth, sizeb) {
    switch (permList[index]) {

      case 'SALE_ENQ':

      /// Sale Enquiry
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SaleEnquiry()));
            },
            child: Expanded(
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
                            'images/enquiry.png',
                            height: imgHeight,
                            width: imgWidth,
                          ),
                          backgroundColor: Color(0xFFE5E5E5),
                        ),
                      ),
                    ],
                  ),
                  sizeb,
                  Text('Sale Enquiry',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          );
        }

      case 'SALE_QTN':
        {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchSaleQuotation()));
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
                          'images/quotation_form.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Sale\nQuotation',
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