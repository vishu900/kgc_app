//import 'package:flutter/cupertino.dart';
import 'package:dataproject2/Stock_opening/ItemSearch.dart';
import 'package:dataproject2/Stock_opening/ItemSearchCatalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'CatalogItemImages.dart';

class ItemMaster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemMaster();
}

class _ItemMaster extends State<ItemMaster> {
  double cardRadius = 36;
  double imgHeight = 36;
  double imgWidth = 36;
  final sizeb = SizedBox(
    height: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Item Master',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                sizeb,
                sizeb,
                Container(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ItemSearch()));
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
                            Text('Item Search',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ItemSearchCatalog()));
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
                            Text('Catalog Search',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                sizeb,
                Visibility(
                  visible: true,
                  child: Container(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CatalogItemImages()));
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
                                        'images/image_file.svg',
                                        height: imgHeight,
                                        width: imgWidth,
                                      ),
                                      backgroundColor: Color(0xFFE5E5E5),
                                    ),
                                  ),
                                ],
                              ),
                              sizeb,
                              Text('Catalog Item Images',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
