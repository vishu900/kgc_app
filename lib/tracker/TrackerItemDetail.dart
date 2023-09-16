import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/TrackerDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TrackerItemDetail extends StatefulWidget {
  final String? docSrl;
  final String? docType;
  final String? reqUser;
  final String? compCode;

  const TrackerItemDetail(
      {Key? key, this.docSrl, this.docType, this.reqUser, this.compCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrackerItemDetail();
}

class _TrackerItemDetail extends State<TrackerItemDetail> {
  List<TrackerDetailModel> trackerDetailList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getTrackerDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text('Tracker Detail'),
      ),
      body: Stack(
        children: [
          ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemCount: trackerDetailList.length,
              itemBuilder: (context, index) => Container(
                    child: Card(
                      child: Table(
                        children: [
                          /// Doc No.
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Doc No'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(trackerDetailList[index].docNo!),
                            ),
                          ]),

                          /// Doc Date.
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Doc Date'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(trackerDetailList[index].docDate!),
                            ),
                          ]),

                          /// Catalog No
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Catalog No'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(trackerDetailList[index].catalogNo!),
                            ),
                          ]),

                          /// Catalog Name
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Catalog Name'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child:
                                  Text(trackerDetailList[index].catalogName!),
                            ),
                          ]),

                          /// Item Qty
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Order Quantity'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(trackerDetailList[index].quantity!),
                            ),
                          ]),

                          /// Complete Quantity
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Complete Quantity'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(
                                  trackerDetailList[index].completeQuantity!),
                            ),
                          ]),

                          /// Balance Quantity
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Balance Quantity'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text(
                                  trackerDetailList[index].balanceQuantity!),
                            ),
                          ]),

                          /// Company Name
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child: Text('Company Name'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              child:
                                  Text(trackerDetailList[index].companyName!),
                            ),
                          ]),

                          /// Client Name
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child: Text('Account Name'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child: Text(trackerDetailList[index].client!),
                            ),
                          ])
                        ],
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  _getTrackerDetail() {
    String? userId = AppConfig.prefs.getString('user_id');

    debugPrint(
        ' reqUser ${widget.reqUser} compCode ${widget.compCode} docSrl ${widget.docSrl} docType ${widget.docType}');

    try {
      Commons().showProgressbar(context);

      var jsonEncoder = jsonEncode(<String, dynamic>{
        'user_id': userId,
        'req_user_id': widget.reqUser,
        'comp_code': widget.compCode,
        'doc_type': widget.docType,
        'doc_srl': widget.docSrl,
      });

      WebService()
          .post(context, AppConfig.getTrackerDetails, jsonEncoder)
          .then((value) => {Navigator.pop(context), _parse(value!)});
    } catch (err) {
      Navigator.pop(context);
      debugPrint('Error While Firing Api => $err');
    }
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        trackerDetailList.clear();
        trackerDetailList.addAll(
            contentList.map((e) => TrackerDetailModel.fromJSON(e)).toList());
        setState(() {});
      }
    }
  }
}
