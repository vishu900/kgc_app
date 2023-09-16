import 'dart:convert';
import 'package:dataproject2/attendance/EmployeeDetail.dart';
import 'package:dataproject2/attendance/model/EmployeeAttendanceModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../material_issue/Url/url.dart';
import 'EmployeeMachineMapping.dart';

// ignore: must_be_immutable
class ViewAttendance extends StatefulWidget {
  List<EmployeeAttendanceModel> inList;
  String? totalEmployee;
  String? presentEmployee;
  String? absentEmployee;
  String? imageBaseUrl;
  Map? jsonBody;

  ViewAttendance(this.inList,
      {this.totalEmployee,
      this.presentEmployee,
      this.absentEmployee,
      this.imageBaseUrl,
      this.jsonBody});

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> with NetworkResponse {
  //bool _isDay=true;
  //bool _isNight=true;
  String maleEmployee = '';
  String femaleEmployee = '';
  List<Map<String, dynamic>> lastPresent = [];

  List<String> lastATT = [];

  Future<void> getlastpresent(String emp_code) async {
    String att = "";
    final url = Uri.parse(
        "${Reusable.baseUrl}/webapi/api/Common/lastpresent?EMP_CODE=" +
            emp_code);
    final response = await http.get(url);

    try {
      final jsonResponseList = json.decode(response.body);
      setState(
            () {
              lastPresent = List.castFrom(jsonResponseList);
att = lastPresent[0]["LAST_PRESENT"];
              lastATT.add(att);
        },
      );
    } catch (e) {
      print("SaleOrdSP: "+ e.toString());
      lastATT.add("");
    }

    //return att;
  }

  @override
  void initState() {
    setState(() {
      for(var l in widget.inList){
        print("Rahul123 "+l.employeeCode!);
        getlastpresent(l.employeeCode!);
      }
    });
    _processShift();
    _init();
    super.initState();

  }

  _init() {
    var maleContent =
        widget.inList.where((element) => element.gender == 'MALE');
    var femaleContent =
        widget.inList.where((element) => element.gender == 'FEMALE');
    print(maleContent.length.toString());
    maleEmployee = maleContent.length.toString();
    femaleEmployee = femaleContent.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Attendance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 10),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Table(
                children: [
                  /// Total Employee
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      child: Text('Total Employee',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: Text(widget.totalEmployee!,
                          style: TextStyle(fontSize: 16)),
                    )
                  ]),

                  /// Present Employee
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      child: Text('Present Employee',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: Text(widget.presentEmployee!,
                          style: TextStyle(fontSize: 16)),
                    )
                  ]),

                  /// Absent Employee
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      child: Text('Absent Employee',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: Text(widget.absentEmployee!,
                          style: TextStyle(fontSize: 16)),
                    )
                  ]),

                  /// Male Employee
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      child:
                          Text('Male Employee', style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: Text(maleEmployee, style: TextStyle(fontSize: 16)),
                    )
                  ]),

                  /// Female Employee
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 6, 6),
                      child: Text('Female Employee',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child:
                          Text(femaleEmployee, style: TextStyle(fontSize: 16)),
                    )
                  ])
                ],
              ),
            )),
            SizedBox(height: 10),
            /* Row(
              children: [
                SizedBox(width: 10),
                FilterChip(
                  checkmarkColor: _isDay? Colors.white:Colors.black,
                  selectedColor: Colors.red[400],
                  labelStyle: TextStyle(color:_isDay? Colors.white:Colors.black,),
                  selected: _isDay,label: Text('Day'), onSelected: (bool value) { setState(() {
                  _isDay=value;
                });  },),
                SizedBox(width: 10),
                FilterChip(
                  checkmarkColor: _isNight? Colors.white:Colors.black,
                  selectedColor: Colors.red[400],
                  labelStyle: TextStyle(color:_isNight? Colors.white:Colors.black,),
                  selected: _isNight,label: Text('Night'), onSelected: (bool value) {
                  setState(() {
                    _isNight=value;
                  });
                },),
              ],
            ),*/
            Column(
              children: List.generate(
                widget.inList.length,
                (index) {
                  return Card(
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeDetail(
                                    employeeCode:
                                        widget.inList[index].employeeCode,
                                  )));
                      _getAttendanceList();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(62),
                                child: widget.inList[index].image!.isEmpty
                                    ? Image.asset('images/noImage.png',
                                        width: 124, height: 124)
                                    : FadeInImage.assetNetwork(
                                        fit: BoxFit.fill,
                                        placeholder:
                                            'images/loading_placeholder.png',
                                        image:
                                            '${widget.imageBaseUrl}${widget.inList[index].image}.png',
                                        width: 124,
                                        height: 124),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Table(
                            children: [
                              /// Employee Code
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Employee Code',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      widget.inList[index].employeeCode!,
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),

                              /// Employee Name
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Employee Name',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      widget.inList[index].employeeName!,
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),

                              /// Last Present
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Last Present',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text( lastATT[index] == ""? "": DateFormat('dd.MM.yyyy').format(DateTime.parse(
                                      lastATT[index])),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),

                              /// Work Sec Code
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Work Sec Code',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      widget.inList[index].workSecCode
                                          .handleEmpty(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),

                              /// Work Machine Code
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Work Machine Code',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      widget.inList[index].workMacCode
                                          .handleEmpty(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                            ],
                          ),
                          SizedBox(height: 4),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.inList[index].inOutList!.length,
                              itemBuilder: (context, subIndex) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Visibility(
                                        visible: widget.inList[index]
                                            .inOutList![subIndex].isShift,
                                        child: Text(
                                            'Day - ${widget.inList[index].inOutList![subIndex].punchTime!.length > 10 ? getFormattedDate(widget.inList[index].inOutList![subIndex].punchTime!, inFormat: 'yyyy-MM-dd HH:mm:ss', outFormat: 'dd MMM yyyy') : ''}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600))),
                                    Visibility(
                                        visible: widget.inList[index]
                                            .inOutList![subIndex].isNightShift,
                                        child: Text(
                                            'Night - ${widget.inList[index].inOutList![subIndex].punchTime!.length > 10 ? getFormattedDate(widget.inList[index].inOutList![subIndex].punchTime!, inFormat: 'yyyy-MM-dd HH:mm:ss', outFormat: 'dd MMM yyyy') : ''}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600))),
                                    Table(
                                      border: TableBorder(
                                          verticalInside: BorderSide(
                                              width: 0.5,
                                              color: Colors.black,
                                              style: BorderStyle.solid),
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Colors.black,
                                              style: BorderStyle.solid)),
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(widget
                                                        .inList[index]
                                                        .inOutList![subIndex]
                                                        .punchTime!
                                                        .length <
                                                    10
                                                ? 'Total Hrs'
                                                : (widget
                                                        .inList[index]
                                                        .inOutList![subIndex]
                                                        .isIn
                                                    ? 'In Time'
                                                    : 'Out Time')),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(widget
                                                        .inList[index]
                                                        .inOutList![subIndex]
                                                        .punchTime!
                                                        .length >
                                                    10
                                                ? getFormattedDate(
                                                    widget
                                                        .inList[index]
                                                        .inOutList![subIndex]
                                                        .punchTime!,
                                                    inFormat:
                                                        'yyyy-MM-dd HH:mm:ss',
                                                    outFormat:
                                                        'dd MMM yyyy hh:mm a')
                                                : widget
                                                    .inList[index]
                                                    .inOutList![subIndex]
                                                    .punchTime!),
                                          )
                                        ])
                                      ],
                                    ),
                                  ],
                                );
                              }),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  height: 0.8,
                                  color: Colors.grey,
                                ),
                              ),
                              Text('Shifts',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic)),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  height: 0.8,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          /// Day Night Count
                          Table(
                            border: TableBorder(
                                verticalInside: BorderSide(
                                    width: 0.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Day Shift(s)',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${widget.inList[index].inOutList!.where((element) => element.isShift).length}'),
                                ),
                              ]),
                            ],
                          ),

                          SizedBox(height: 8),

                          Table(
                            border: TableBorder(
                                verticalInside: BorderSide(
                                    width: 0.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Night Shift(s)',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${widget.inList[index].inOutList!.where((element) => element.isNightShift).length}'),
                                ),
                              ]),
                            ],
                          ),

                          SizedBox(height: 8),
                          SizedBox(height: 8),
                          Visibility(
                            visible: widget.inList[index].inOutList!.isEmpty
                                ? false
                                : DateFormat('yyyy-MM-dd')
                                        .parse(widget.inList[index].inOutList!
                                            .first.punchTime!)
                                        .isAtSameMomentAs(
                                            DateFormat('yyyy-MM-dd').parse(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime.now()))) &&
                                    widget.inList[index].empCode == '20',
                            child: OutlinedButton(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeMachineMapping(
                                                employeeCode: widget
                                                    .inList[index].employeeCode,
                                                date: widget.inList[index].date,
                                                compCode: widget
                                                    .inList[index].compCode,
                                                empName: widget
                                                    .inList[index].employeeName,
                                                fatherName: widget
                                                    .inList[index].fatherName,
                                              )));
                                  _getAttendanceList();
                                },
                                child: Text('Map Machine')),
                          )
                        ],
                      ),
                    ),
                  ),
                );},
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getAttendanceList() {
    WebService.fromApi(AppConfig.attendanceList, this, widget.jsonBody)
        .callPostService(context, showLoader: true);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) async {
    try {
      switch (requestCode) {
        case AppConfig.attendanceList:
          {
            var data =  await compute(jsonDecode,response!) ;

            if (data['error'] == 'false') {
              var content = data['content'] as List;

              widget.totalEmployee = getString(data, 'total_employees');
              widget.presentEmployee = getString(data, 'present_employees');
              widget.absentEmployee = getString(data, 'absent_employees');
              widget.imageBaseUrl = getString(data, 'image_png_path');

              widget.inList.clear();
              widget.inList.addAll(content
                  .map((e) => EmployeeAttendanceModel.parseAttendance(e))
                  .toList());
              _processShift();
              _init();
              setState(() {



              });
            }
          }
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

  _processShift() {
    widget.inList.forEach((mainElement) {
      DateTime? dateTime;
      mainElement.inOutList!.forEach((element) {
        if (dateTime != null) {
          if (element.isIn) {
            if (element.punchTime!.length > 10) {
              if (element.punchTime!.toDateTime(format: 'yyyy-MM-dd') !=
                  dateTime) {
                element.isShift = true;
                dateTime = element.punchTime!.toDateTime(format: 'yyyy-MM-dd');
              }

              DateTime nightShift = DateTime(
                  dateTime!.year, dateTime!.month, dateTime!.day, 19, 30, 00);
              if (element.punchTime!
                  .toDateTime(format: 'yyyy-MM-dd hh:mm:ss')
                  .isAfter(nightShift)) {
                element.isShift = false;
                element.isNightShift = true;
              }
            }
          }
        } else {
          if (element.isIn) {
            if (element.punchTime!.length >= 10) {
              dateTime = element.punchTime!.toDateTime(format: 'yyyy-MM-dd');
              element.isShift = true;
            }

            DateTime nightShift = DateTime(
                dateTime!.year, dateTime!.month, dateTime!.day, 19, 30, 00);
            if (element.punchTime!
                .toDateTime(format: 'yyyy-MM-dd hh:mm:ss')
                .isAfter(nightShift)) {
              element.isShift = false;
              element.isNightShift = true;
            }
          }
        }
      });
    });
  }
}
