import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/datamodel/LocationUserModel.dart'
    show LocationUserModel;
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AssignLocation extends StatefulWidget {
  final String? id;
  final String? factoryName;

  const AssignLocation({Key? key, required this.id, required this.factoryName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AssignLocation();
}

class _AssignLocation extends State<AssignLocation> {
  List<LocationUserModel> userList = [];

  String? imageBaseUrl = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          '${widget.factoryName}',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Visibility(
        visible: userList.isNotEmpty,
        child: ListView(
          padding: EdgeInsets.only(bottom: 8),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemBuilder: (BuildContext ctx, int index) {
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    child: userList[index].image!.trim().isEmpty
                                        ? Icon(
                                            Icons.person_rounded,
                                            size: 28,
                                            color: Colors.white,
                                          )
                                        : Image.network(
                                            '$imageBaseUrl${userList[index].image}',
                                            fit: BoxFit.fill),
                                    decoration:
                                        BoxDecoration(color: Colors.grey[400]),
                                  ),
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userList[index].name!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      userList[index].id!,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                                value: userList[index].isAssigned,
                                onChanged: (val) {
                                  setState(() {
                                    userList[index].isAssigned =
                                        !userList[index].isAssigned;
                                  });
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: userList.length,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Container(
                height: 48,
                child: ElevatedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    _saveLocationPermission();
                  },
                  // color: AppColor.appRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getUserList() {
    String? userId = AppConfig.prefs.getString('user_id');
    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'factory_code': widget.id});

    Commons().showProgressbar(context);

    WebService()
        .post(context, AppConfig.factoryUsers, jsonEncoder)
        .then((value) => {popIt(context), _parseUserList(value!)});
  }

  _parseUserList(Response res) {
    var data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      logIt('Location List-> $data');
      imageBaseUrl = data['image_tiff_path'];
      var content = data['content'] as List;
      userList.clear();
      userList
          .addAll(content.map((e) => LocationUserModel.fromJSON(e)).toList());
      userList.sort((a, b) => a.name!.compareTo(b.name!));
      if (!mounted) return;
      if (userList.isEmpty)
        Commons().showAlert(
            context, 'No users found for ${widget.factoryName}', 'Not Found',
            onOk: () {
          popIt(context);
        });
      setState(() {});
    }
  }

  _saveLocationPermission() async {
    String data = await _getUserCodes();
    String? userId = AppConfig.prefs.getString('user_id');
    logIt('Data-> $data');

    // ignore: unnecessary_null_comparison
    if (data == null) data = '0';

    var jsonEncoder = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'factory_code': widget.id,
      'selected_user_id': data
    });

    Commons().showProgressbar(context);

    WebService()
        .post(context, AppConfig.updateFactoryUser, jsonEncoder)
        .then((value) => {popIt(context), _parseSavePerm(value!)});
  }

  _parseSavePerm(Response res) {
    var data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      logIt('savePermission-> $data');
      if (data['error'] == 'false') {
        Commons().showAlert(context, data['message'], 'Success');
      } else {
        Commons().showAlert(context, data['message'], 'Error');
      }
    }
  }

  Future<String> _getUserCodes() {
    var str;

    userList.forEach((e) {
      if (str == null) {
        if (e.isAssigned) str = '${e.id}';
      } else {
        if (e.isAssigned) str = "$str,${e.id}";
      }
    });
    return Future.value(str);
  }
}
