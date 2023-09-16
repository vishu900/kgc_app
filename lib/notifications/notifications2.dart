import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:dataproject2/datamodel/content.dart';
import 'package:dataproject2/notification_model/notificationmodel.dart';

//import 'extra class.dart';

const companyApiURl = "${AppConfig.baseUrl}api/company";

class Notifcations2 extends StatefulWidget {
  final CompanyList;

  final userid, name;

  const Notifcations2({Key? key, this.CompanyList, this.userid, this.name})
      : super(key: key);
  @override
  _Notifcations2State createState() => _Notifcations2State();
}

class _Notifcations2State extends State<Notifcations2> {
  // get http => null;
  dynamic jsonResponse = null;
  List<Content>? companydetails;
  late var companyDetail;
  String? name;
  String? code;
  String companyorders = "${AppConfig.baseUrl}api/notification/lists";
  bool? isLoading;
  void initState() {
    super.initState();
    print('userid');
    print(widget.userid);

    getcompanies();

    print('Notification2 Running');
  }

  getcompanies() async {
//    print("user name   " + userid);
//    print("password "  +pass);
//    print("sign in called");
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'user_id': "JASS", "page": "0"};

    // var response2 = await http.get(companyApiURl, body: data);
    var response = await http.post(Uri.parse(companyorders), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String errorcheck = jsonResponse['error'];

      companyDetail = NotificationModel.fromJson(json.decode(response.body));
      print('names of companies');
      print(companyDetail.content);

//       companyDetail.content.forEach((member){
//
//         List<String> codes = [];
//         codes.add(member['code']);
//         print('code printing');
//         print(codes);
//       });
      print('names of companies');

      print("errorche " + errorcheck);
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        // sharedPreferences.setString("token", jsonResponse['token']);
      }
      if (errorcheck == "false") {
        // print()
        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Dashboard()), (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(msg: "Wrong User Credentials!");
      }

      print('sign in successful');
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  userid: widget.userid,
                  name: widget.name,
                )));
    return Future.value(false);
  }

  String? companyName;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'SELECT COMPANY',
            style: TextStyle(
              letterSpacing: 2.17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 20,
            ),
          )),
          backgroundColor: Color(0xFFFF0000),
        ),
        body: Container(
            decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage('images/city_background.jpg'),
//            fit: BoxFit.cover,
//          ),
                ),
            constraints: BoxConstraints.expand(),
            child: jsonResponse == null
                ? Container(
                    child: Center(
                      child: Text('LOADING'),
                    ),
                  )
                : ListView.builder(
                    itemCount: companyDetail.content.length,
                    itemBuilder: (context, index) {
                      var firstdata = jsonResponse['notification'];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: InkWell(
//                onTap: widget.onTap,
                          child: Container(
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
//                          Image.network(widget.product.image,width: 90,height: 100,),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                firstdata[index]['user_id'],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
//                                    TextMoneyFromString(widget.product.price),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 0.0),
                                  child: (Text(
                                      'Update: ${"widget.product.create_at"}')),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
//          return Dismissible(
//            background: Container(
//              color: Colors.red,
//            ),
//            key: Key(items[index]),
//            onDismissed: (direction) {
//              items.removeAt(index);
//              Scaffold.of(context).showSnackBar(
//                SnackBar(
//                  content: Text('Item is removed'),
//                ),
//              );
//            },
//            child: Padding(
//              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
//              child: InkWell(
////                onTap: widget.onTap,
//                child:  Container(
//                  height: 100,
//                  child: Stack(
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
////                          Image.network(widget.product.image,width: 90,height: 100,),
//                          Column(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(items[index]['name'],),
//                                    SizedBox(height: 10,),
////                                    TextMoneyFromString(widget.product.price),
//                                    SizedBox(height: 4,),
//                                  ],
//                                ),
//                              ),
//
//                            ],
//                          ),
//                        ],
//
//                      ),
//                      Container(
//                        alignment: Alignment.topRight,
//                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 0.0),
//                        child: (Text('Update: ${"widget.product.create_at"}')),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            )
//          );
                    },
                  )

//          ListView.builder(
//
//
//
//            itemCount: 5,
//            itemBuilder: (BuildContext ctx, int index){
//              var firstdata = jsonResponse['notification'];
//
////              code = firstdata[index]['code'];
//              name = firstdata[index]['name'];
//              List list1 = firstdata[index]['notification'];
//              print("list length of users");
////              print(list1.length);
//
//              companyDetail.content;
//
//              return
//
//                ExpansionTileCard(
//
//
//                  leading: GestureDetector(
//                    onTap: (){
//
//                      var firstdata = jsonResponse['notification'];
//
////                      code = firstdata[index]['code'];
//                      name = firstdata[index]['name'];
//
//                    //  Navigator.push(context, MaterialPageRoute(builder: (context) =>PageViewClass(companycode: firstdata[index]['code'],userid: widget.userid,)));
//                    },
//                    child: ClipRRect(
//                        borderRadius: BorderRadius.circular(10),
//                        child: Image.asset('images/appstore.png', width: 50, height: 50)),
////                  onTap: (){
////                    Navigator.push(context, MaterialPageRoute(
////                        builder: (context) => ProfileVisit(postAuthorId: widget.postAuthorId,)
////                    ));
////                  },
////                  child: CircleAvatar(
////                    radius: 30,
////                  backgroundImage: AssetImage('images/background.jpg',),
////                  //  backgroundImage: widget.postAuthorProfilePicurl !=null? CachedNetworkImageProvider(widget.postAuthorProfilePicurl): AssetImage("assets/user.png"),
////
////                  ),
//                  ),
//
//                  title: GestureDetector(
//                    onTap: (){
//
//                      var firstdata = jsonResponse['content'];
//
////                      code = firstdata[index]['code'];
//                      name = firstdata[index]['name'];
//
//                     // Navigator.push(context, MaterialPageRoute(builder: (context) =>PageViewClass(companycode: code,userid: widget.userid,)));
//                    },
////                    child: Text(firstdata[index]['name'] ?? 'NULL PASSED')
//                    child: Padding(
//                      padding: const EdgeInsets.only(left: 10),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          Text(firstdata[index]['name'] ?? 'NULL PASSED'),
//                          SizedBox(width: 2,),
//                          Text("(${firstdata[index]['order_count'].toString()})")
//                        ],
//                      ),
//                    ),
//
//                  ),
////                trailing: Text(firstdata[index]['order_count'].toString()),
//                  children: <Widget>[
//                    Divider(
//                      thickness: 1.0,
//                      height: 1.0,
//
//                    ),
//                    Align(
//                      alignment: Alignment.center,
//                      child: Padding(
//                          padding: const EdgeInsets.symmetric(
//                            horizontal: 16.0,
//                            vertical: 8.0,
//                          ),
//
//                          child:ListView.builder(
//                              shrinkWrap: true,
//                              itemCount: list1.length,
//                              itemBuilder: (BuildContext ctx, int index){
//
////                        var firstdata = jsonResponse['content'];
//
//                                return Padding(
//                                  padding: const EdgeInsets.only(left: 60),
//                                  child: ListTile(
//                                    title:Text(list1[index]['name']) ,
//                                    trailing: Text(list1[index]['count'].toString()),
//                                  ),
//                                );
//
////                      return Column(
////                        crossAxisAlignment: CrossAxisAlignment.start,
////                        children: [
////                        Text(list1[index]['name']),
////                        Text(list1[index]['count'].toString())
////                      ],);
////                       return Text(list1[index]['name']);
////                        Text(firstdata[index]['user_lists']);
//
//
//                              }
//                          )
////                      child: Text(
////                        "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"+
////
////                            "bom_order_count.postcontent \n"+
////                            "bom_order_count.postcontent \n"
////
////
////                        ,
////                        style: Theme.of(context)
////                            .textTheme
////                            .body1
////                            .copyWith(fontSize: 16),
////                      ),
//                      ),
//                    ),
////                  Align(
////                    alignment: Alignment.centerLeft,
////                    child: Padding(
////                      padding: const EdgeInsets.symmetric(
////                        horizontal: 16.0,
////                        vertical: 8.0,
////                      ),
////                      child: Text(
////                        "widget.postcontent",
////                        style: Theme.of(context)
////                            .textTheme
////                            .body1
////                            .copyWith(fontSize: 16),
////                      ),
////                    ),
////                  ),
////                  ButtonBar(
////                    alignment: MainAxisAlignment.spaceAround,
////                    buttonHeight: 52.0,
////                    buttonMinWidth: 90.0,
////                    children: <Widget>[
////                      FlatButton(
////                        shape: RoundedRectangleBorder(
////                            borderRadius: BorderRadius.circular(4.0)),
////                        onPressed: () async {
////
////                        },
////                        child: Column(
////                          children: <Widget>[
////                            Icon(Icons.block, color: Colors.red,),
////                            Padding(
////                              padding: const EdgeInsets.symmetric(vertical: 2.0),
////                            ),
////                            Text('REPORT'),
////                          ],
////                        ),
////                      ),
////                      FlatButton(
////                        shape: RoundedRectangleBorder(
////                            borderRadius: BorderRadius.circular(4.0)),
////                        onPressed: () {
////
//// },
////                        child: Column(
////                          children: <Widget>[
////                            Icon(Icons.star_border, color: Colors.deepOrange,),
////                            Padding(
////                              padding: const EdgeInsets.symmetric(vertical: 2.0),
////                            ),
////                            Text('Mark'),
////                          ],
////                        ),
////                      ),
////                      FlatButton(
////                        shape: RoundedRectangleBorder(
////                            borderRadius: BorderRadius.circular(4.0)),
////                        onPressed: () {
////
////
////
////                        },
////                        child: Column(
////                          children: <Widget>[
////                            Icon(Icons.favorite,color: Colors.lightGreenAccent,),
////                            Padding(
////                              padding: const EdgeInsets.symmetric(vertical: 2.0),
////                            ),
////                            Text('Support'),
////
////                          ],
////                        ),
////                      ),
////
////                    ],
////                  ),
//                  ],
//                );
////              return ListTile(
////
////                onTap: (){
////                  var firstdata = jsonResponse['content'];
////
////                  code = firstdata[index]['code'];
////                  name = firstdata[index]['name'];
////
////                  Navigator.push(context, MaterialPageRoute(builder: (context) =>PageViewClass(companycode: code,userid: widget.userid,)));
////                },
//////                leading: Text(firstdata[index]['code'].toString()),
////                title: Text(firstdata[index]['name']),
////                trailing: Text(firstdata[index]['order_count'].toString()),
////
////
////
////              );
//            },
//          ),
//        child: SafeArea(
//          child: Column(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(5.0),
//                child: TextField(
//                  style: TextStyle(
//                    color: Colors.black,
//                  ),
//                  decoration: kTextFieldInputDecoration,
//                  onChanged: (value) {
//                    companyName = value;
//                  },
//                ),
//              ),
//                IconButton(icon: Icon(Icons.search),),
////              FlatButton(
////                onPressed: () {
////                  Navigator.pop(context, companyName);
////                },
////                child: Text(
////                  'Get Company',
////                  style: kButtonTextStyle,
////                ),
////              ),
//            ],
//          ),
//        ),
            ),
      ),
    );
  }
}
