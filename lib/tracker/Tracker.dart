import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/newmodel/TrackerModel.dart';
import 'package:dataproject2/tracker/TrackerItemDetail.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';

class Tracker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Tracker();
}

class _Tracker extends State<Tracker> {
  List<TrackerModel> trackerList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTrackerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text('Tracker'),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            ListView.builder(
              itemCount: trackerList.length,
              padding: EdgeInsets.only(top: 14),
              itemBuilder: (context, index) {
                return ExpansionTileCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                trackerList[index].title! +
                                    ' (${trackerList[index].totalDocCount})',
                                style: TextStyle(
                                  color: Colors.black,
                                  //  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    expandedColor: Colors.grey[200],
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              trackerList[index].trackerItems!.length,
                              (subIndex) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackerItemDetail(
                                              compCode: trackerList[index]
                                                  .trackerItems![subIndex]
                                                  .compCode,
                                              docSrl: trackerList[index]
                                                  .trackerItems![subIndex]
                                                  .docSrl,
                                              docType: trackerList[index]
                                                  .trackerItems![subIndex]
                                                  .docType,
                                              reqUser: trackerList[index]
                                                  .trackerItems![subIndex]
                                                  .userId,
                                            )));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Text('Company Name')),
                                            Expanded(
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.network(
                                                      AppConfig.small_image +
                                                          trackerList[index]
                                                              .trackerItems![
                                                                  subIndex]
                                                              .logo!,
                                                      height: 20,
                                                      width: 20,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      trackerList[index]
                                                          .trackerItems![
                                                              subIndex]
                                                          .companyName!,
                                                      style: TextStyle(),
                                                      softWrap: true,
                                                    ),
                                                  )
                                                ])),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text('User name')),
                                            Expanded(
                                                child: Text(trackerList[index]
                                                    .trackerItems![subIndex]
                                                    .user!)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text('Total Docs')),
                                            Expanded(
                                                child: Text(trackerList[index]
                                                    .trackerItems![subIndex]
                                                    .totalDocs!)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                    ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  _getTrackerList() {
    var userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(context);

    WebService()
        .post(context, AppConfig.trackerList,
            jsonEncode(<String, dynamic>{'user_id': userId}))
        .then((value) =>
            {Navigator.of(context).pop(), _parseTrackerList(value!)});
  }

  _parseTrackerList(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;
        trackerList
            .addAll(contentList.map((e) => TrackerModel.fromJson(e)).toList());
        setState(() {});
      }
    }
  }
}
