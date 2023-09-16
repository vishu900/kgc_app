import 'package:dataproject2/Permissions/Permissions.dart';
import 'package:dataproject2/gateEntry/gateEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GateEntrySelection extends StatefulWidget {

  final String? logo;
  final String? compCode;
  final String? compName;
  final String? imageBaseUrl;

  const GateEntrySelection({
        Key? key,
        this.compCode,
        this.compName,
        this.logo,
        this.imageBaseUrl}) : super(key: key);

  @override
  _GateEntrySelectionState createState() => _GateEntrySelectionState();

}

class _GateEntrySelectionState extends State<GateEntrySelection> {

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
        title: Text('Gate Entry Selection'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(12, 20, 12, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Gate Challan
            Visibility(
              visible:ifHasPermission(permType: PermType.INSERT,compCode: widget.compCode,permission: Permissions.GATE_ENTRY_CHALLAN)!,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => GateEntry(
                    compName: widget.compName,
                    compCode: widget.compCode,
                  )));
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
                              'images/indent_report.svg',
                              height: imgHeight,
                              width: imgWidth,
                            ),
                            backgroundColor: Color(0xFFE5E5E5),
                          ),
                        ),
                      ],
                    ),
                    _height,
                    Text('Gate Challan',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ),

            /// Gate Entry
            Visibility(
              visible:ifHasPermission(compCode: widget.compCode,permission: Permissions.GATE_ENTRY_BILL,permType: PermType.INSERT)!,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          GateEntry(
                              compName: widget.compName,
                              compCode: widget.compCode,
                              gateEntryType: GateEntryType.ENTRY)));
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
                              'images/indent_report.svg',
                              height: imgHeight,
                              width: imgWidth,
                            ),
                            backgroundColor: Color(0xFFE5E5E5),
                          ),
                        ),
                      ],
                    ),
                    _height,
                    Text('Gate Entry',
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
