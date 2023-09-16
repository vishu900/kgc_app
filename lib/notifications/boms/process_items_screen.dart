import 'package:dataproject2/bomscreen/bom_items_screen.dart';
import 'package:flutter/material.dart';

class ProcessItemsScreen extends StatefulWidget {
  final datareceived;

  const ProcessItemsScreen({Key? key, this.datareceived}) : super(key: key);

  @override
  _ProcessItemsScreenState createState() => _ProcessItemsScreenState();
}

class _ProcessItemsScreenState extends State<ProcessItemsScreen> {
  List? listprocessItems;

  int? total;

  void initState() {
    super.initState();

//    print("data check process items");
//    print(widget.datareceived);

//    List list = widget.datareceived[0]["order_items"];
//
//    print("data list check ");
//    print(list);

//    List list2 = list[0]["process_items"];

    setState(() {
      total = widget.datareceived.length;
    });
//
//    print("process list check ");
//
//    print(list2);
//    listprocessItems = widget.datareceived["order_items"]["process_items"];
  }

  @override
  Widget build(BuildContext context) {
    print('process list checking on');
    print(widget.datareceived);
//    List list = widget.datareceived[0]["order_items"];

    List? list2 = widget.datareceived;

    //  total = list2.length;
//    List list2 = list[0]["process_items"][0]["bom_items"];
//    listprocessItems = widget.datareceived['content'];
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'VIEW PROCESS ',
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
              child: Text('No Process Items'),
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
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(list2![0]["catalog_item"],
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
                              list2[0]['item_description'].toString().trim(),
                              textAlign: TextAlign.start,
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
                    itemCount: list2.length,
                    itemBuilder: (context, index) {
                      print("length of items");

//                print(listprocessItems.length);
                      //      int index2 = index;

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
                                        list2.length.toString(),
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
                                        "Process Code",
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
                                          left: 20, right: 5, top: 8),
                                      child: Text(
                                        list2[index]["proc_code"],
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
                                        'Process',
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
                                        list2[index]["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                        'Process Type',
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
                                      child: list2[index]["proc_type"] == "O"
                                          ? Text(
                                              "ORDER",
                                              style: TextStyle(
                                                backgroundColor: Colors.white,
                                                color: Color(0xFF2e2a2a),
                                                fontFamily: 'Roboto',
                                                fontSize: 12,
                                              ),
                                            )
                                          : Text(
                                              "PROCESS",
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
//                              width: 160,
//                              decoration: BoxDecoration(
//                                color: Colors.white,
//                                border: Border.all(
//
//                                  width:0.5,
//                                  color: Color(0xFF766F6F),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 20,top: 8),
//                                child: Text('Rank',   style: TextStyle(backgroundColor: Colors.white,
//                                  color:Color(0xFF2e2a2a),
//                                  fontFamily: 'Roboto',
//                                  fontSize: 12,
//
//                                ),),
//                              ),
//                            ),
//                            Container(
//                              height: 32,
//                              width: 160,
//                              decoration: BoxDecoration(
//                                color: Colors.white,
//                                border: Border.all(
//
//                                  width:0.5,
//                                  color: Color(0xFF766F6F),
//                                ),
//                                borderRadius: BorderRadius.circular(10.0),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 20,top: 8),
//                                child: Text("RANK PENDING", style: TextStyle(backgroundColor: Colors.white,
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
                                        'Visible Waste',
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
                                        list2[index]["v_wst"],
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
                                        'Invisible Waste ',
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
                                        list2[index]["v_wst"],
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
                                  print("process code check");
                                  print(list2[index]["proc_code"]);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BomItemsScreen(
                                                bomdatareceived: list2,
                                                processCode: list2[index]
                                                    ["proc_code"],
                                                processName: list2[index]
                                                    ["name"],
                                                sod_pk: list2[index]['sod_pk'],
                                                catalog_item: list2[index]
                                                    ["catalog_item"],
                                                catalogITem1: list2[0]
                                                    ["catalog_item"],
                                                catalog_name: list2[0]
                                                    ["item_description"],
                                              )));
//                                                list.removeAt(index);
//

//                                                Fluttertoast.showToast(msg: "item id " + list[index]["sod_pk"] ,
//                                                    toastLength: Toast.LENGTH_SHORT,
//                                                    gravity: ToastGravity.CENTER,
//                                                    timeInSecForIosWeb: 1,
//                                                    backgroundColor: Colors.red,
//                                                    textColor: Colors.white,
//                                                    fontSize: 16.0);

//                                Fluttertoast.showToast(msg: "Approved Item " + approvedbyperson.text + "  " + contactpersoncontroller.text) ;
                                },
                                child: Container(
                                    width: 360,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF0000),
                                      border: Border.all(
                                        color: Color(0xFFFF0000),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                        child: Text("VIEW BOM",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                letterSpacing: 2.17)))),
                              ),
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
