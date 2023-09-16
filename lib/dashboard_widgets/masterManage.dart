import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../LocationMaster/LocationMaster.dart';
import '../Stock_opening/ItemMaster.dart';

class MasterManage{
  Widget masterManage(permList, index, context, cardRadius, imgHeight, imgWidth, sizeb) {
    switch (permList[index]) {
      case 'ITEM_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ItemMaster()));
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
                          'images/item_master.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Item Master',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }

      case 'LOCATION_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocationMaster()));
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
                          'images/location.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Location Master',
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
