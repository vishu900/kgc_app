import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Commons/Commons.dart';
import '../full_and_final/full _and _final _comp _selection.dart';
import '../tracker/Tracker.dart';
import 'masterManage.dart';

class ExtraManage{
  Widget extraManage(permList, index, trackCount, context, cardRadius, imgHeight, imgWidth, sizeb){
    switch (permList[index]) {
      case 'TRACKER':
        {
          return GestureDetector(
            onTap: () {
              trackCount != 0
                  ? Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Tracker()))
                  : Commons.showToast('No Tracker Report is there!!!');
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
                    trackCount != 0
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
                          '$trackCount',
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
                Text('Tracker',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }
      case 'FANDF':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullAndFinalCompSelection()));
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
                          'images/salary.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Full And Final',
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