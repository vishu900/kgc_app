import 'package:flutter/material.dart';

class OrderListing extends StatefulWidget {
  final ordernumber, diff;
  final int? itemcount;
  final companycode, userid;
  final snap, key1, ordernumber1;

  const OrderListing(
      {Key? key,
      this.ordernumber,
      this.diff,
      this.itemcount,
      this.ordernumber1,
      this.companycode,
      this.userid,
      this.key1,
      this.snap})
      : super(key: key);

  @override
  _OrderListingState createState() => _OrderListingState();
}

class _OrderListingState extends State<OrderListing> {
  @override
  Widget build(BuildContext context) {
    //  final heightSize = SizedBox(height:25);
    return Container(
//        width:screenSize.width,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        // color: Colors.red,
//            width: screenSize.width,
        //  height: screenSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //order container
                    Container(
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Order Date',
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
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text('19 May 2020'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
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
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Vardhman Textiles Ltd',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Order No.',
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
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          widget.ordernumber,
                          style: TextStyle(
                            backgroundColor: Colors.white,
                            color: Color(0xFF2e2a2a),
                            fontFamily: 'Roboto',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Contact Person',
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
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //hintText: 'Username',
                          ),

                          textAlign: TextAlign.center,
//                              controller:contactpersoncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            backgroundColor: Colors.white,
                            color: Color(0xFF2e2a2a),
                            fontFamily: 'Roboto',
                            fontSize: 12,
                          ),
                        ),
//                                  child: TextFormField(
//
//                                      keyboardType: TextInputType.text,
//                                    controller:contactpersoncontroller
//
//
//
//                                  ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Approval By',
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
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Color(0xFF766F6F),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            //hintText: 'Username',
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
//                              controller:approvedbyperson,
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
              ],
            ),
            // ListView()
            SizedBox(
              height: 25,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 16,
                        );
                      },
                      //scrollDirection: Axis.vertical,

                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: widget.itemcount!,

                      itemBuilder: (BuildContext ctx, int index) {
                        List? setup = widget.ordernumber1;
                        print('check');
                        print(setup.toString());
                        String? catalognum;
                        for (int i = 0; i < widget.itemcount!; i++) {
                          catalognum = widget.ordernumber1[0].sodPk;
                        }

                        print('check2');
                        print(catalognum);

//                       String var1 = widget.ordernumber1[widget.key1].sodPk.toString();

                        return ItemDetails(
                          diff: widget.diff,
                          index1: index,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemDetails extends StatefulWidget {
  int? index1;

  String? ordernumber, diff;
  ItemDetails({this.ordernumber, this.diff, this.index1});
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  void initState() {
    super.initState();

    print(widget.index1);
  }

  @override
  Widget build(BuildContext context) {
    // final heightSize = SizedBox(height:25);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            width: 320,
            decoration: BoxDecoration(
              color: Color(0xFFFF0000),
              border: Border.all(
                color: Color(0xFFFF0000),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'ITEM DETAILS - ' + "1/2",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment:CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    "Catalog Item",
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    widget.diff!,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'QTY.',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '10',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Uom',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Pc.',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Net Rate',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '1',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Uom',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Pc.',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Amount ',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '10',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Party Order No.',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Text1',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 32,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Delivery Date',
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
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Color(0xFF766F6F),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '25 May 2020',
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
          GestureDetector(
            onTap: () {
//                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
            },
            child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFFF0000),
                  border: Border.all(
                    color: Color(0xFFFF0000),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                    child: Text("APPROVE",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            letterSpacing: 2.17)))),
          ),
        ],
      ),
    );
  }
}
