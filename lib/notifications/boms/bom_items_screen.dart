import 'package:flutter/material.dart';

class BomItemsScreen extends StatefulWidget {
  final bomdatareceived,
      processCode,
      processName,
      sod_pk,
      catalog_item,
      catalogITem1,
      catalog_name;

  const BomItemsScreen(
      {Key? key,
      this.bomdatareceived,
      this.processCode,
      this.processName,
      this.sod_pk,
      this.catalog_item,
      this.catalogITem1,
      this.catalog_name})
      : super(key: key);

  @override
  _BomItemsScreenState createState() => _BomItemsScreenState();
}

class _BomItemsScreenState extends State<BomItemsScreen> {
  int? total;
  void initState() {
    super.initState();

    print("bom data check");
    print(widget.processCode);
    print(widget.bomdatareceived[0]["bom_items"]);
    List list = widget.bomdatareceived[0]["bom_items"];
    total = list.length;
  }

  @override
  Widget build(BuildContext context) {
    List list2 = widget.bomdatareceived[0]['bom_items'];

// List list4=   list2.singleWhere((i) => i == "proc_code");
    // List filterproducts= list2.where((f) => f.bomdatareceived[0]['bom_items'][0]['process_code'].contains(widget.processCode)).toList();

    List filterproducts = [];
    filterproducts.addAll(list2
        .where((element) => element.containsValue(widget.processCode))
        .toList());

    List filterproducts2 = [];
    filterproducts2.addAll(filterproducts
        .where((element) => element.containsValue(widget.sod_pk))
        .toList());

    List filterproducts3 = [];
    filterproducts3.addAll(filterproducts2
        .where((element) => element.containsValue(widget.catalog_item))
        .toList());
//   List filterproducts=[];
//    filterproducts.addAll(widget.bomdatareceived[0]['bom_items'][0]['proc_code'].where((element) => element.contains(widget.processCode)).toList());
//    List filterproducts = list2.where((item) => item.contains(widget.processCode));
    // List filterproducts= list2.where((i) => widget.bomdatareceived[0]['bom_items'][0]['product_code'].contains(widget.processCode));

//    List list4=   list2.where(widget.bomdatareceived[0]['bom_items'][0][widget.processCode]).toList();
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'VIEW BOM',
          style: TextStyle(
            letterSpacing: 2.17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            fontSize: 20,
          ),
        )),
        backgroundColor: Color(0xFFFF0000),
      ),
      body: total == 0
          ? Center(
              child: Text('No BOM Items'),
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Catalog Item',
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 8, right: 5),
                            child: Text(widget.catalogITem1,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 96,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              'Catalog Name',
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
                          height: 96,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, right: 5),
                            child: Text(
                              widget.catalog_name.toString().trim(),
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Process Code',
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              widget.processCode,
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Process Name',
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
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              widget.processName,
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
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 16,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: filterproducts3.length,
                    itemBuilder: (context, index) {
                      print("length of items");

//                print(listprocessItems.length);
                      //        int index2 = index;

                      return Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 360,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF0000),
                                  border: Border.all(
                                    color: Color(0xFFFF0000),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'ITEM DETAILS - ' +
                                        (index + 1).toString() +
                                        "/" +
                                        filterproducts3.length.toString(),
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 4),
                                      child: Text(
                                        "Item Code",
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 5),
                                      child: Text(
                                        filterproducts3[index]
                                            ["bom_catalog_item"],
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
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment:CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Container(
//
//                              height: 32,
//                              width: 180,
//                              decoration: BoxDecoration(
//                                color: Colors.white,
//                                border: Border.all(
//                                  width:0.5,
//                                  color: Color(0xFF766F6F),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 20,top: 8),
//                                child: Text('Item Name',   style: TextStyle(backgroundColor: Colors.white,
//                                  color:Color(0xFF2e2a2a),
//                                  fontFamily: 'Roboto',
//                                  fontSize: 12,
//
//                                ),
//                                ),
//                              ),
//                            ),
//                            Container(
//                              height: 32,
//                              width: 180,
//                              decoration: BoxDecoration(
//                                color: Colors.white,
//                                border: Border.all(
//                                  width:0.5,
//                                  color: Color(0xFF766F6F),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 20,top: 8),
//                                child: Text("pending", style: TextStyle(backgroundColor: Colors.white,
//                                  color:Color(0xFF2e2a2a),
//                                  fontFamily: 'Roboto',
//                                  fontSize: 12,
//
//                                ),),
//                              ),
//                            ),
//
//                          ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 96,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: Text(
                                        'Item Description',
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
                                    height: 96,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10, right: 5),
                                      child: Text(
                                        filterproducts3[index]
                                                ["bom_item_description"]
                                            .toString()
                                            .trim(),
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        'Qty',
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        filterproducts3[index]["bom_qty_per"],
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        filterproducts3[index]["bom_qty_uom"],
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        'Stock Tag ',
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
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        filterproducts3[index]["stock_tag"],
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

//                        GestureDetector(
//                          onTap:  () {
//
//
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>BomItemsScreen(bomdatareceived: list2,)));
////                                                list.removeAt(index);
////
//
//
////                                                Fluttertoast.showToast(msg: "item id " + list[index]["sod_pk"] ,
////                                                    toastLength: Toast.LENGTH_SHORT,
////                                                    gravity: ToastGravity.CENTER,
////                                                    timeInSecForIosWeb: 1,
////                                                    backgroundColor: Colors.red,
////                                                    textColor: Colors.white,
////                                                    fontSize: 16.0);
//
////                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
//                          },
//                          child:  Container(
//                              width:320,
//                              height:40,
//                              decoration: BoxDecoration(
//                                color: Color(0xFFFF0000),
//                                border: Border.all(
//                                  color: Color(0xFFFF0000),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Center(child: Text("VIEW PROCESS",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                                  fontFamily: 'Roboto',
//                                  fontSize: 20,
//                                  letterSpacing: 2.17
//
//                              )))),
//                        ),
//                        GestureDetector(
//                          onTap:  () {
//
////                                                list.removeAt(index);
////
//
//                            showDialog(context: context,
//                                builder: (BuildContext context){
//                                  return AlertDialog(
//                                    title: Text('APPROVE ALERT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
//                                    content: SingleChildScrollView(
//                                      child: ListBody(
//                                        children: <Widget>[
//                                          Text('Are You Sure You Want To Approve this Item?'),
//                                          //Text('please enter the country?'),
//                                        ],
//                                      ),
//                                    ),
//                                    actions: <Widget>[
//                                      FlatButton(
//                                        child: Text('No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
//                                        onPressed: () {
//                                          setState(() {
////                                                                avatarImageFile1 =null;
//                                            Navigator.of(context).pop();
//                                          });
//
//                                        },
//                                      ),
//                                      FlatButton(
//                                        child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),),
//                                        onPressed: () async {
////                                                              getImage1();
//
//
//                                          Map data = {
//                                            'order_item_id': list[index]["sod_pk"].toString(),
//                                            'user_id': widget.userid.toString()
//                                          };
//                                          var jsonResponse = null;
//
//                                          var response = await http.post(approvalapiurl, body: data);
//                                          if (response.statusCode == 200) {
//                                            jsonResponse = json.decode(response.body);
//                                            print('Response status: ${response.statusCode}');
//                                            print('Response body: ${response.body}');
//                                            String errorcheck = jsonResponse['error'];
//
//                                            if (errorcheck == "false") {
//                                              list.removeAt(index);
//                                              print(index);
//                                              Navigator.of(context).pop();
//                                              //
//
//
//
//                                              if(list.length == 0){
//                                                print("final calling");
//                                                setState(() {
//
//                                                  _future = getdetailsoforders(widget.userid,widget.companycode);
////                                                                      print("order lengths");
////
////                                                                      firstdata.removeAt(index);
////                                                                      print(snapshot.data.content.length);
////
////                                                                      print("first data length");
////                                                                      if(firstdata.length == 0){
////
////                                                                        setState(() {
////                                                                          total = true;
////                                                                        });
////                                                                      }
////                                                                      print(firstdata.length);
//                                                  //  _future = getdetailsoforders(widget.userid,widget.companycode);
//
//                                                });
//                                              }
//                                              else{
//
//                                                print('no calling');
//                                              }
//
////                                                                  Map data = {
////                                                                    'user_id': widget.userid,
////                                                                    'company_code':widget.companycode
////
////                                                                  };
//
//
////                                                                  var response = await http.post(newapi, body: data);
////                                                                  if(response.statusCode == 200) {
////                                                                    print("called2");
////                                                                    jsonResponse = json.decode(response.body);
////
////
////
////                                                                    var firstdata = jsonResponse['content'];
////                                                                    List list1 = jsonResponse['content'];
////
////                                                                    List list = firstdata[list1.length -1]['order_items'];
////                                                                    print('first data');
////                                                                    print(firstdata);
////
////
////                                                                    print('list data');
////                                                                    print(list);
////
////                                                                    print('list length');
////                                                                    print(list1.length);
////
////                                                                    setState(() {
////                                                                      listorders = list1.length;
////
////                                                                      listitems = list.length;
////                                                                    });
////
////                                                                    print('list length2');
////                                                                    print(list.length);
////
////
////
////
////                                                                    return NewOrder.fromJson(jsonResponse);
////
////
////
////                                                                  }
////                                                                  else {
////                                                                    setState(() {
////                                                                      _isLoading = false;
////                                                                    });
////
////
////                                                                    print('login error');
////                                                                    print(response.body);
////                                                                  }
//
//
//                                              Fluttertoast.showToast(
//                                                  msg: "Order Item has been approved successfully.",
//                                                  toastLength: Toast.LENGTH_SHORT,
//                                                  gravity: ToastGravity.CENTER,
//                                                  timeInSecForIosWeb: 1,
//                                                  backgroundColor: Colors.red,
//                                                  textColor: Colors.white,
//                                                  fontSize: 16.0
//                                              );
//                                              setState(() {
//                                                //  _future = getdetailsoforders(widget.userid,widget.companycode);
//
//                                              });
//
//                                            }
//                                            else {
//                                              Navigator.of(context).pop();
//                                              Fluttertoast.showToast(
//                                                  msg: "Approval Not Successful",
//                                                  toastLength: Toast.LENGTH_SHORT,
//                                                  gravity: ToastGravity.CENTER,
//                                                  timeInSecForIosWeb: 1,
//                                                  backgroundColor: Colors.red,
//                                                  textColor: Colors.white,
//                                                  fontSize: 16.0
//                                              );
//                                            }
//                                          }
//                                          // approvalbutton(list[index]["sod_pk"].toString(),widget.userid.toString(), index1, index2);
//
//                                        },
//                                      ),
//                                    ],
//                                  );
//                                }
//                            );
//
////                                                Fluttertoast.showToast(msg: "item id " + list[index]["sod_pk"] ,
////                                                    toastLength: Toast.LENGTH_SHORT,
////                                                    gravity: ToastGravity.CENTER,
////                                                    timeInSecForIosWeb: 1,
////                                                    backgroundColor: Colors.red,
////                                                    textColor: Colors.white,
////                                                    fontSize: 16.0);
//
////                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
//                          },
//                          child:  Container(
//                              width:320,
//                              height:40,
//                              decoration: BoxDecoration(
//                                color: Color(0xFFFF0000),
//                                border: Border.all(
//                                  color: Color(0xFFFF0000),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Center(child: Text("APPROVE",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
//                                  fontFamily: 'Roboto',
//                                  fontSize: 20,
//                                  letterSpacing: 2.17
//
//                              )))),
//                        ),
                            ],
                          ),
//                                      Text(snapshot
//                                          .data.content[key][index][0].sodPk),
//                                      Text(snapshot
//                                          .data.content[key][index][0].sqdFk),
//                                      Text(snapshot.data.content[key][index][0]
//                                          .orderHeader.sohPk),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
