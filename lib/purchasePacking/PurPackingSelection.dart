import 'package:dataproject2/purchasePacking/PurchasePackingBill.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PurPackingSelection extends StatefulWidget {
  final String? compCode;
  final String? compName;
  final String? logo;
  final String? imageBaseUrl;

  const PurPackingSelection(
      {Key? key, this.compCode, this.compName, this.logo, this.imageBaseUrl})
      : super(key: key);

  @override
  _PurPackingSelectionState createState() => _PurPackingSelectionState();
}

class _PurPackingSelectionState extends State<PurPackingSelection> {
  double cardRadius = 36;
  double imgHeight = 36;
  double imgWidth = 36;

  final _height = SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Purchase Packing Selection'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(12, 20, 12, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Purchase Packing Challan
            Visibility(
              visible:ifHasPermission(
                  permType: PermType.INSERT,
                  compCode: widget.compCode,
                  permission: Permissions.PUR_PACKING_CHALLAN)!,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PurchasePackingBill(
                          compCode: widget.compCode,
                          compName: widget.compName,
                          imageBaseUrl: widget.imageBaseUrl,
                          logo: widget.logo,
                          purPackType: PurPackType.Challan)));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                              'images/shopping-bag.svg',
                              height: imgHeight,
                              width: imgWidth,
                            ),
                            backgroundColor: Color(0xFFE5E5E5),
                          ),
                        ),
                      ],
                    ),
                    _height,
                    Text('Purchase Packing\nChallan',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ),

            /// Purchase Packing Entry
            Visibility(
              visible:ifHasPermission(
                  permType: PermType.INSERT,
                  compCode: widget.compCode,
                  permission: Permissions.PUR_PACKING_BILL)!,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PurchasePackingBill(
                          compCode: widget.compCode,
                          compName: widget.compName,
                          imageBaseUrl: widget.imageBaseUrl,
                          logo: widget.logo,
                          purPackType: PurPackType.Bill)));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                              'images/shopping-bag.svg',
                              height: imgHeight,
                              width: imgWidth,
                            ),
                            backgroundColor: Color(0xFFE5E5E5),
                          ),
                        ),
                      ],
                    ),
                    _height,
                    Text('Purchase Packing\nBill',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
