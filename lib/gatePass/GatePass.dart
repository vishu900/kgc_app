import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
//import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/datamodel/GatePassModel.dart';
import 'package:dataproject2/gatePass/CreateGatePass.dart';
import 'package:dataproject2/gatePass/EmpGatePassModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/quotation/ViewPdf.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class GatePass extends StatefulWidget {
  final PassType? passType;
  final String? compId;
  final String? entryby;
  final bool isDirectView;
  final bool isAlertView;

  const GatePass(
      {Key? key,
      this.passType,
      this.compId,
      this.entryby,
      this.isDirectView = false,
      this.isAlertView = false})
      : super(key: key);

  @override
  _GatePassState createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> with NetworkResponse {
  double cardRadius = 36;
  double imgHeight = 36;
  double imgWidth = 36;

  final sizeb = SizedBox(
    height: 12,
  );

  List<GatePassModel> _gatePassList = [];
  List<EmpGatePassModel> _empGatePassList = [];

  String imageBaseUrl = '';
  bool? hasVisitorOutPerm = false;
  bool isMarkIn = false;

  @override
  void initState() {
    hasVisitorOutPerm = ifHasPermission(
        compCode: widget.compId,
        permission: Permissions.VISITOR_OUT,
        permType: PermType.ALL);
    super.initState();
    logIt('PassType->${widget.passType}');
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPendingGatePass();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () async {
                  if (widget.isDirectView) {
                    popIt(context);
                  }
                  if (await _onBackPressed()) popIt(context);
                }),
            title: Text(widget.passType == PassType.Employee
                ? 'Employee Gate Pass'
                : 'Visitor Gate Pass'),
            centerTitle: false,
          ),
          body: _getListBody()),
    );
  }

  Widget _getListBody() {
    if (widget.passType == PassType.Employee) {
      return _empGatePassList.isNotEmpty
          ? ListView.builder(
              itemCount: _empGatePassList.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) => Card(
                    child: InkWell(
                      onTap: () async {
                        if (_empGatePassList[index].approvedDate!.isNotEmpty) {
                          Commons.showToast(
                              'This gate pass is approved, cannot be modified.');
                          return;
                        }
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateGatePass(
                                      passType: PassType.Employee,
                                      isEditMode: true,
                                      id: _empGatePassList[index].id,
                                    )));
                        _getPendingGatePass();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Table(
                              children: [
                                /// Serial No
                                TableRow(children: [
                                  Text('Serial no:',
                                      style: TextStyle(fontSize: 16)),
                                  Text(_empGatePassList[index].serialNo!,
                                      style: TextStyle(fontSize: 16)),
                                ]),

                                /// Due Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Due Date:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].dueDate!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Out Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Out Date:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].outDate!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Out By
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Out By:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].outByUser!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// In Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('In Date:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].inDate!.isEmpty
                                            ? 'N/A'
                                            : _empGatePassList[index].inDate!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// In By
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('In By:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index]
                                                .inByUser!
                                                .isEmpty
                                            ? 'N/A'
                                            : _empGatePassList[index].inByUser!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Approved By
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('To Approved By:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].approvedBy!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Approved Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Approved Date:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _empGatePassList[index].approvedDate!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(height: 12),
                            Container(
                              width: 100.0.h,
                              height: 44.h,
                              child: ListView.builder(
                                  itemCount:
                                      _empGatePassList[index].empList!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, subIndex) => Container(
                                        height: 42.0.h,
                                        width: 40.0.h,
                                        child: Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(64),
                                                  child: _empGatePassList[index]
                                                          .empList![subIndex]
                                                          .image!
                                                          .isEmpty
                                                      ? Image.asset(
                                                          'images/noImage.png',
                                                          height: 128,
                                                          width: 128)
                                                      : FadeInImage
                                                          .assetNetwork(
                                                          placeholder:
                                                              'images/loading_placeholder.png',
                                                          image:
                                                              '$imageBaseUrl${_empGatePassList[index].empList![subIndex].image}.png',
                                                          height: 128,
                                                          width: 128,
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                                SizedBox(height: 12),
                                                Table(
                                                  children: [
                                                    /// Employee Code
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3.sp),
                                                        child: Text(
                                                            'Employee Code:',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    13.sp)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3.0.sp),
                                                        child: Text(
                                                            _empGatePassList[
                                                                    index]
                                                                .empList![
                                                                    subIndex]
                                                                .employeeCode!,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                            )),
                                                      ),
                                                    ]),

                                                    /// Employee Name
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4.sp),
                                                        child: Text(
                                                            'Employee Name:',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    13.sp)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6),
                                                        child: Text(
                                                            _empGatePassList[
                                                                    index]
                                                                .empList![
                                                                    subIndex]
                                                                .employeeName!,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ),
                                                    ]),

                                                    /// Department
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4.sp),
                                                        child: Text(
                                                            'Department:',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    13.sp)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6),
                                                        child: Text(
                                                            _empGatePassList[
                                                                    index]
                                                                .empList![
                                                                    subIndex]
                                                                .department!,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ),
                                                    ]),

                                                    /// Designation
                                                    TableRow(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3.0.sp),
                                                        child: Text(
                                                            'Designation:',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3.0.sp),
                                                        child: Text(
                                                            _empGatePassList[
                                                                    index]
                                                                .empList![
                                                                    subIndex]
                                                                .designation!,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    13.sp)),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                            SizedBox(height: 12),
                            _getAction(index),
                          ],
                        ),
                      ),
                    ),
                  ))
          : Center(child: Text('No pass found!'));
    } else {
      return _gatePassList.isNotEmpty
          ? ListView.builder(
              itemCount: _gatePassList.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) => Card(
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateGatePass(
                                      passType: PassType.Visitor,
                                      isEditMode: true,
                                      id: _gatePassList[index].sNo,
                                    )));
                        _getPendingGatePass();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: _gatePassList[index].image.isEmpty
                                  ? Image.asset('images/noImage.png',
                                      height: 128, width: 128)
                                  : FadeInImage.assetNetwork(
                                      placeholder:
                                          'images/loading_placeholder.png',
                                      image:
                                          '$imageBaseUrl${_gatePassList[index].image}.png',
                                      height: 128,
                                      width: 128,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            SizedBox(height: 12),
                            Table(
                              children: [
                                /// Serial No
                                TableRow(children: [
                                  Text('Serial no:',
                                      style: TextStyle(fontSize: 16)),
                                  Text(_gatePassList[index].sNo!,
                                      style: TextStyle(fontSize: 16)),
                                ]),

                                /// Visitor Name
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Visitor Name:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].visitorName!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Contact
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Contact:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(_gatePassList[index].contact!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// In Date
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('In Date:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].inDate!.isEmpty
                                            ? 'N/A'
                                            : _gatePassList[index].inDate!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// In By
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('In By:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].inDate!.isEmpty
                                            ? 'N/A'
                                            : _gatePassList[index].entryBy!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Purpose
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Purpose:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(_gatePassList[index].purpose!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Person To Meet
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Person To Meet:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].personToMeet!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Total Person
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Total Person:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].totalPerson!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Company Name
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Company Name:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index]
                                            .company
                                            .handleEmpty(),
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// Address
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('Address:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(_gatePassList[index].address!,
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// City
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('City:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index].city.handleEmpty(),
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),

                                /// State
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text('State:',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                        _gatePassList[index]
                                            .state
                                            .handleEmpty(),
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Visibility(
                                  visible: hasVisitorOutPerm!,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _markVisitorGatePassOut(
                                            empCode:
                                                _gatePassList[index].empCode,
                                            sno: _gatePassList[index].sNo,
                                            srl: _gatePassList[index].srl);
                                      },
                                      child: Text('Mark Out')),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _downloadPdf(
                                          _gatePassList[index].sNo, 'Visitor');
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('View'),
                                        SizedBox(width: 4),
                                        Icon(Icons.download_outlined,
                                            color: Colors.white),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
          : Center(child: Text('No pass found!'));
    }
  }

  Widget _getAction(int index) {
    /// When Gate Pass is not Approved
    if (_empGatePassList[index].approvedDate!.isEmpty) {
      if (_empGatePassList[index].approverId == getUserId()) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  _approveEmpGatePass(
                      empCode: _empGatePassList[index].id,
                      sno: _empGatePassList[index].sno,
                      srl: _empGatePassList[index].serialNo);
                },
                child: Text('Approve')),
            ElevatedButton(
                onPressed: () {
                  _downloadPdf(_empGatePassList[index].serialNo, 'Employee');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View'),
                    SizedBox(width: 4),
                    Icon(Icons.download_outlined, color: Colors.white),
                  ],
                )),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: _empGatePassList[index].inDate!.isNotEmpty ||
                      _empGatePassList[index].outDate!.isEmpty
                  ? null
                  : () {
                      _markEmpGatePassIn(
                          empCode: _empGatePassList[index].id,
                          sno: _empGatePassList[index].sno,
                          srl: _empGatePassList[index].serialNo);
                    },
              child: Text('Mark In')),
          ElevatedButton(
              onPressed: () {
                _downloadPdf(_empGatePassList[index].serialNo, 'Employee');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View'),
                  SizedBox(width: 4),
                  Icon(Icons.download_outlined, color: Colors.white),
                ],
              )),
          ElevatedButton(
              onPressed: _empGatePassList[index].outDate!.isNotEmpty
                  ? null
                  : () {
                      _markEmpGatePassOut(
                          empCode: _empGatePassList[index].id,
                          sno: _empGatePassList[index].sno,
                          srl: _empGatePassList[index].serialNo);
                    },
              child: Text('Mark Out'))
        ],
      );
    }
  }

  _getPendingGatePass() {
    Map jsonBody = {
      'user_id': getUserId(),
    };

    if (widget.compId != null) jsonBody.addAll({'comp_code': widget.compId});
    if (widget.entryby != null) jsonBody.addAll({'entryby': widget.entryby});

    if (widget.passType == PassType.Employee) {
      WebService.fromApi(AppConfig.getPendingEmpPass, this, jsonBody)
          .callPostService(context);
    } else {
      WebService.fromApi(AppConfig.getPendingVisitorPass, this, jsonBody)
          .callPostService(context);
    }
  }

  _markEmpGatePassIn({
    String? sno,
    String? srl,
    String? empCode,
  }) {
    DateTime dt = DateTime.now();
    Map jsonBody = {
      'user_id': getUserId(),
      'sno': sno,
      'srl': srl,
      'code_pk': empCode,
      'gate_in_date': dt.format('yyyy-MM-dd HH:mm:ss'),
      'gate_in_user': getUserId()
    };
    WebService.fromApi(AppConfig.updateEmployeePass, this, jsonBody)
        .callPostService(context);
    isMarkIn = true;
  }

  _markEmpGatePassOut({
    String? sno,
    String? srl,
    String? empCode,
  }) {
    DateTime dt = DateTime.now();

    Map jsonBody = {
      'user_id': getUserId(),
      'sno': sno,
      'srl': srl,
      'code_pk': empCode,
      'gate_out_date': dt.format('yyyy-MM-dd HH:mm:ss'),
      'gate_out_user': getUserId()
    }; // approved_date

    WebService.fromApi(AppConfig.updateEmployeePass, this, jsonBody)
        .callPostService(context);
  }

  _markVisitorGatePassOut({
    String? sno,
    String? srl,
    String? empCode,
  }) {
    DateTime dt = DateTime.now();
    var time = DateFormat('hh:mm a').format(dt);

    Map jsonBody = {
      'user_id': getUserId(),
      'sno': srl,
      'slipno': sno,
      'outdate': dt.format('yyyy-MM-dd'),
      'outtime': time
    };

    logIt('MarkOutGatePass-> $jsonBody');

    WebService.fromApi(AppConfig.updateVisitorPass, this, jsonBody)
        .callPostService(context);
  }

  _approveEmpGatePass({
    String? sno,
    String? srl,
    String? empCode,
  }) {
    DateTime dt = DateTime.now();

    Map jsonBody = {
      'user_id': getUserId(),
      'sno': sno,
      'srl': srl,
      'code_pk': empCode,
      'approved_date': dt.format('yyyy-MM-dd HH:mm:ss')
    };

    WebService.fromApi(AppConfig.updateEmployeePass, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.getPendingVisitorPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              _gatePassList.clear();

              var content = data['content'] as List;

              _gatePassList.addAll(
                  content.map((e) => GatePassModel.parseVisitor(e)).toList());

              imageBaseUrl = getString(data, 'image_tiff_path');

              setState(() {});
            }
          }
          break;

        case AppConfig.getPendingEmpPass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              _empGatePassList.clear();

              var content = data['content'] as List;

              _empGatePassList.addAll(
                  content.map((e) => EmpGatePassModel.fromJson(e)).toList());
              imageBaseUrl = getString(data, 'image_tiff_path');

              setState(() {});
            }
          }
          break;

        case AppConfig.updateVisitorPass:
        case AppConfig.updateEmployeePass:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              showAlert(context, data['message'], 'Success', onOk: () {
                if (!isMarkIn) {
                  _getPendingGatePass();
                }
                logIt('isMarkIn1-> $isMarkIn');
                if (isMarkIn) isMarkIn = false;
                logIt('isMarkIn2-> $isMarkIn');
              });
            } else {
              showAlert(context, data['message'], 'Error!');
            }
          }
      }
    } catch (err, stack) {
      logIt('onResponse-> $err here -> $stack');
    }
  }

  _downloadPdf(String? docCode, String type) async {
    List<int> bytes = [];

    var url = type == 'Visitor'
        ? '${AppConfig.downloadVisitorGatePass}$docCode'
        : '${AppConfig.downloadEmployeeGatePass}$docCode';
    ;

    logIt('PdfUrls-> $url');

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode.pdf';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    //if (file2.existsSync()) {
    // logIt('File does EXIST -> $file2');
    // _viewPdf(file2, docCode);
    // } else {
    Commons().showProgressbar(this.context);
    logIt('File does not exist -> $file2');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    //final contentLength = res.contentLength;
    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);
        popIt(this.context);
        _viewPdf(file2, docCode);
      },
      onError: (e) {
        popIt(this.context);
        showAlert(this.context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
    // }
  }

  Future<bool> _onBackPressed() async {
    if (widget.isAlertView) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    userid: getUserId(),
                    name: getName(),
                  )),
          (route) => false);

      return false;
    } else {
      return Future.value(true);
    }
  }

  _viewPdf(File data, String? docCode) async {
    FocusScope.of(this.context).unfocus();
    Navigator.of(this.context)
        .push(MaterialPageRoute(builder: (context) => ViewPdf(data: data)));
  }
}
