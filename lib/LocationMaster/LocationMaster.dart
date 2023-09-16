import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/datamodel/LocationListModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'AssignLocation.dart';

class LocationMaster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationMaster();
}

class _LocationMaster extends State<LocationMaster> {
  List<LocationListModel> locationList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getLocationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Location master',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext ctx, int index) {
          return Card(
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignLocation(
                              id: locationList[index].id,
                              factoryName: locationList[index].name,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 36,
                        ),
                        Text(
                          locationList[index].name!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Text(
                            '${locationList[index].address1},'
                            '${locationList[index].address2},'
                            '${locationList[index].city},'
                            '${locationList[index].pinCode},'
                            '${locationList[index].state}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: locationList.length,
      ),
    );
  }

  _getLocationList() {
    String? userId = AppConfig.prefs.getString('user_id');

    var jsonEncoder = jsonEncode(<String, dynamic>{'user_id': userId});

    Commons().showProgressbar(context);

    WebService()
        .post(context, AppConfig.listLocations, jsonEncoder)
        .then((value) => {popIt(context), _parseLocationList(value!)});
  }

  _parseLocationList(Response res) {
    var data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      logIt('Location List-> $data');
      var content = data['content'] as List;
      locationList.clear();
      locationList
          .addAll(content.map((e) => LocationListModel.fromJSON(e)).toList());
      if (!mounted) return;
      setState(() {});
    }
  }
}
