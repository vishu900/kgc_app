import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/notification_model/notificationmodel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsList extends StatefulWidget {
  final name;

  const NotificationsList({Key? key, this.name}) : super(key: key);

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  dynamic jsonResponse = null;
  List<Notification>? companydetails;
  late var companyDetail;
  String? name;
  String? code;
  String companyorders = "${AppConfig.baseUrl}api/notification/lists";

  String full_image = "http://localhost/bkintl/public/uploads/company/";
  String small_image =
      "http://localhost/bkintl/public/uploads/company/512*512/";
  String clearall = "${AppConfig.baseUrl}api/notification/clear_all";
  String readall = "${AppConfig.baseUrl}api/notification/change_all";
  String readsingle = "${AppConfig.baseUrl}api/notification/single_update";
  String deletesinglenotification =
      "${AppConfig.baseUrl}api/notification/delete_single";
  var userid;
  int page = 0;
  double lastMaxScroll = 0;
  int numberOfItems = 100;
  List? firstdata = [];

  int noteItems = 0;

  ScrollController _scrollController = ScrollController();
  bool loadingMore = false;
  bool moreProductsAvailable = true;

  List notificationsList = [];

  bool? isLoading;

  void initState() {
    print('userid');
    super.initState();
    getuserid();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
//
//      if(maxScroll - currentScroll < delta){
//        page = page +1;
//
//        print("page number checking right now");
//        print(page);
//
//        updatenumber();
//
////        getMoreNotifications();
//      }

      if (maxScroll - currentScroll < delta) {
        page = page + 1;
//        lastMaxScroll = maxScroll;

        print("page number checking right now");
        print(page);

        getMoreNotifications(page);
      }
    });
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('user_id');
    /*  var name = prefs.getString('name');
    var password = prefs.getString('password'); */
    getnotifications(page);
  }

  clearallnotifications(String userid) async {
    Map data = {
      'user_id': userid.toString(),
//      "page":page.toString()
    };

    // var response2 = await http.get(companyApiURl, body: data);
    var response = await http.post(Uri.parse(clearall), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print("mark calling");
//    initState();
      firstdata!.clear();
      noteItems = 0;

      page = 0;
      getnotifications(page);
      print("mark calling");

      Fluttertoast.showToast(
          msg: "All Notifications Cleared",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

//      if(jsonResponse != null) {
//        setState(() {
//          _isLoading = false;
//        });
//
//      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  readallnotifications(String userid) async {
    Map data = {
      'user_id': userid.toString(),
//      "page":page.toString()
    };

    // var response2 = await http.get(companyApiURl, body: data);
    var response = await http.post(Uri.parse(readall), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
//      initState();

      print("mark calling");
//    initState();
      firstdata!.clear();
      noteItems = 0;

      page = 0;
      getnotifications(page);
      print("mark calling");

      Fluttertoast.showToast(
          msg: "All Notifications Marked Read",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      //getnotifications(0);

      // String? errorcheck = jsonResponse['error'];
//      if(jsonResponse != null) {
//        setState(() {
//          _isLoading = false;
//        });
//
//      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  readSingleNotifications(String userid, String notificationid) async {
    Map data = {'user_id': userid.toString(), "id": notificationid.toString()};

    // var response2 = await http.get(companyApiURl, body: data);
    var response = await http.post(Uri.parse(readsingle), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

//      if(jsonResponse != null) {
//        setState(() {
//          _isLoading = false;
//        });
//
//      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  deleteSingleNotifications(String userid, String notificationid) async {
    print("delete credentials");
    print(userid);
    print(notificationid);
    Map data = {'user_id': userid.toString(), "id": notificationid.toString()};

    // var response2 = await http.get(companyApiURl, body: data);
    var response =
        await http.post(Uri.parse(deletesinglenotification), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("deleting called ");

      print("dismiss check");
      print('$noteItems -- ${firstdata!.length}');

      Fluttertoast.showToast(
          msg: "DELETED NOTIFICATION",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
//      if(jsonResponse != null) {
//        setState(() {
//          _isLoading = false;
//        });
//
//      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  updatenumber() {
    page = page + 1;

    print("page number checking right now222222");
    print(page);
  }

  getnotifications(int page) async {
//    print("user name   " + userid);
//    print("password "  +pass);
//    print("sign in called");
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'user_id': userid.toString(), "page": page.toString()};

    // var response2 = await http.get(companyApiURl, body: data);
    var response = await http.post(Uri.parse(companyorders), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String? errorcheck = jsonResponse['error'];

      companyDetail = NotificationModel.fromJson(json.decode(response.body));

      int number1 = jsonResponse['notification'].length;

      firstdata = jsonResponse['notification'];

      noteItems = noteItems + number1;

      print("notes 1");
      print(noteItems);
//      print('names of companies');
//      print(companyDetail.content);

//       companyDetail.content.forEach((member){
//
//         List<String> codes = [];
//         codes.add(member['code']);
//         print('code printing');
//         print(codes);
//       });
//      print('names of companies');
//
//      print("errorche " + errorcheck);
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

  getMoreNotifications(int page) async {
    print("page number checking now1111111");
    print(page);

//    print("user name   " + userid);
//    print("password "  +pass);
//    print("sign in called");
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'user_id': userid.toString(), "page": page.toString()};

    var response = await http.post(Uri.parse(companyorders), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      String errorcheck = jsonResponse['error'];

      companyDetail = NotificationModel.fromJson(json.decode(response.body));
      print('names of companies 222222');
      print(companyDetail.content);

      var number1 = jsonResponse['notification'] as List;

      noteItems = number1.length;

      print("notes 2");
      print(noteItems);
      List list = jsonResponse['notification'];
      firstdata!.addAll(list);

//      list.add(companyDetail);
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
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('login error');
      print(response.body);
    }
  }

  Future<bool> _onWillPop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    var name = prefs.getString('name');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  userid: user_id,
                  name: name,
                )));

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Notifications',
          ),
          actions: [
            Tooltip(
              message: 'Refresh Notification',
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _refreshAlerts();
                },
              ),
            )
          ],
          backgroundColor: Color(0xFFFF0000),
        ),
        body: Container(
            child: jsonResponse == null
                ? Container(
                    child: Center(
                      child: Text('LOADING'),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Color(0xFFFF0000),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    readallnotifications(userid.toString());
                                  },
                                  child: Text(
                                    "MARK ALL READ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Spacer(),
                              GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => new AlertDialog(
                                        title: new Text(
                                            'Clear All Notifications!!'),
                                        content: new Text(
                                            'Are you sure you want to clear all the notifications? '),
                                        actions: <Widget>[
                                          new ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: new Text(
                                              'No',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          new ElevatedButton(
                                            onPressed: () {
                                              clearallnotifications(
                                                  userid.toString());
                                              Navigator.of(context).pop(true);
                                            },
                                            child: new Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );

                                    firstdata!.clear();
                                  },
                                  child: Text(
                                    "CLEAR ALL",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          controller: _scrollController,
                          itemCount:
                              (jsonResponse['notification'] as List).length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var firstdata = jsonResponse['notification'];
                            // final item = firstdata[index];
                            String arr = firstdata[index]['created_at'];

                            String? imagelink = jsonResponse['full_image'];
                            var arr2 = arr.split('-');
                            // var content = firstdata[index]['company_details']
                            ['logo_name'];
                            print('logo name check');
                            print(firstdata[index]);
                            print('$noteItems -- ${firstdata.length}');

                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 0.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: firstdata[index]['status'] == "0"
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                    child: ListTile(
                                      onTap: () {
                                        print(firstdata[index]['message']);
                                        String? notifytype =
                                            firstdata[index]['notify_type'];

                                        var mainData = Map<String, dynamic>();
                                        var data = Map<String, dynamic>();

                                        data['company_code'] =
                                            firstdata[index]['comp_code'];
                                        data['small_image'] = imagelink;
                                        data['company_logo'] = firstdata[index]
                                            ['company_details']['logo_name'];
                                        data['notify_type'] = notifytype;
                                        data['order_id'] =
                                            firstdata[index]['order_id'];

                                        mainData['data'] = data;

                                        print('NotificationList $mainData');

                                        Commons.pushToScreen(mainData);

                                        print('NotificationList pushToScreen');
                                      },
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),

                                        child: Image.network(
                                          jsonResponse['full_image'] +
                                              getString(
                                                  firstdata[index]
                                                      ['company_details'],
                                                  'logo_name'),
                                          width: 50.0,
                                          height: 50.0,
                                        ),
//
                                      ),

//
                                      title: Row(
//
                                        children: [
                                          Flexible(
                                            child: firstdata[index]['title'] !=
                                                    null
                                                ? AutoSizeText(
                                                    firstdata[index]['title'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(''),
                                          ),
//                                SizedBox(width: 2,),
//                                firstdata[index]['status'] == "1"?Image.asset('images/reddot.png',width: 10,height: 10,):Text("")
                                        ],
                                      ),

                                      subtitle: firstdata[index]['message'] !=
                                              null
                                          ? AutoSizeText(
                                              firstdata[index]['message'],
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(''),
                                      trailing:
                                          firstdata[index]['created_at'] != null
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      arr2[0],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      arr2[1],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                )
                                              : Text(''),
                                    ),
                                  )
                                  /* : Container(
                                          color: Colors.white,
                                          child: ListTile(
                                            onTap: () {
                                              print(firstdata[index]
                                                  ['message']);
                                              String notifytype =
                                                  firstdata[index]
                                                      ['notify_type'];
                                              String content =
                                                  firstdata[index]['content'];

                                              if (notifytype == "1") {
                                                //sale order

                                                print("sale order called");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NotificationSaleOrder(
                                                              order_id: firstdata[
                                                                      index][
                                                                  'order_id'],
                                                              company_code:
                                                                  firstdata[
                                                                          index]
                                                                      [
                                                                      'comp_code'],
                                                              user_id: firstdata[
                                                                      index]
                                                                  ['user_id'],
                                                              order_type: firstdata[
                                                                      index][
                                                                  'notify_type'],
                                                              iconlink: imagelink +
                                                                  firstdata[index]
                                                                          [
                                                                          'company_details']
                                                                      [
                                                                      'logo_name'],
                                                            )));
                                              } else if (notifytype == "2") {
                                                //bom order
                                                print("bom order called");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NotificationSaleBomScreen(
                                                              order_id: firstdata[
                                                                      index][
                                                                  'order_id'],
                                                              company_code:
                                                                  firstdata[
                                                                          index]
                                                                      [
                                                                      'comp_code'],
                                                              user_id: firstdata[
                                                                      index]
                                                                  ['user_id'],
                                                              order_type: firstdata[
                                                                      index][
                                                                  'notify_type'],
                                                              iconlink: imagelink +
                                                                  firstdata[index]
                                                                          [
                                                                          'company_details']
                                                                      [
                                                                      'logo_name'],
                                                            )));
                                              }
                                            },
//                                  leading: ClipRRect(
//                                      borderRadius: BorderRadius.circular(10),
//                                      child: Image.asset('images/appstore.png', width: 50, height: 50)
//                                  ) ,

                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),

                                              child: Image.network(
                                                jsonResponse['full_image'] +
                                                    firstdata[index][
                                                            'company_details']
                                                        ['logo_name'],
                                                width: 50.0,
                                                height: 50.0,
                                              ),
//                                  child: Image.asset('images/appstore.png', width: 50, height: 50)
                                            ),

//                                firstdata[index]['status'] == "1"?Image.asset('images/reddot.png',width: 9,height: 9,):Text(""),
//                          SizedBox(width: 2,),
//                      title: Container(
//                          height: 200,
//                          child: Text('Item $index')),
                                            title: Row(
//                                crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: firstdata[index]
                                                              ['title'] !=
                                                          null
                                                      ? AutoSizeText(
                                                          firstdata[index]
                                                              ['title'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(''),
                                                ),
//                                SizedBox(width: 2,),
//                                firstdata[index]['status'] == "1"?Image.asset('images/reddot.png',width: 10,height: 10,):Text("")
                                              ],
                                            ),

                                            subtitle: firstdata[index]
                                                        ['message'] !=
                                                    null
                                                ? AutoSizeText(
                                                    firstdata[index]
                                                        ['message'],
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(''),
                                            trailing: firstdata[index]
                                                        ['created_at'] !=
                                                    null
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        arr2[0],
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Text(
                                                        arr2[1],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  )
                                                : Text(''),
                                          ),
                                        ),*/
                                ],
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
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

  _refreshAlerts() {
    Commons().showProgressbar(context);

    WebService()
        .post(context, AppConfig.refreshAlerts,
            jsonEncode(<String, dynamic>{'user_id': userid}))
        .then((value) =>
            {Navigator.of(context).pop(), _parseRefreshAlerts(value!)});
  }

  _parseRefreshAlerts(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'true') {
        page = 0;
        getnotifications(page);
      }
    }
  }
}
