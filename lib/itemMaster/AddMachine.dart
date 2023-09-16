import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/itemMaster/model/MachineTypeModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'model/MachineModel.dart';

class AddMachine extends StatefulWidget {
  @override
  _AddMachineState createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> with NetworkResponse {
  final _machineTypeFormKey = GlobalKey<FormState>();
  final _machineFormKey = GlobalKey<FormState>();

  TextEditingController _typeController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _machineTypeController = TextEditingController();
  TextEditingController _machineController = TextEditingController();
  TextEditingController _machineRemarksController = TextEditingController();
  String? machineTypeCode = '';
  List<MachineModel> machineList = [];
  List<MachineTypeModel> _macTypeList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMachineType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Add Machine',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Form(
                      key: _machineTypeFormKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Machine Type',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: _typeController,
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Please enter type'
                                  : null,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Type',
                                  isDense: true)),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: _remarksController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Remarks',
                                  isDense: true)),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                // color: AppColor.appRed,
                                onPressed: () {
                                  if (_machineTypeFormKey.currentState!
                                      .validate()) {
                                    _addType();
                                  }
                                },
                                child: Text(
                                  'Add Type',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: _machineFormKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Machine',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TypeAheadFormField<MachineTypeModel>(
                            validator: (value) => machineTypeCode!.isEmpty
                                ? 'Please select machine type'
                                : null,
                            itemBuilder: (BuildContext context, itemData) {
                              return ListTile(
                                title: Text(
                                  itemData.name!,
                                ),
                                subtitle: Text(itemData.remarks!),
                              );
                            },
                            onSuggestionSelected: (sg) {
                              _machineTypeController.text = sg.name!;
                              machineTypeCode = sg.id;
                              _getMachineList();
                              //  setState(() {});
                            },
                            suggestionsCallback: (String pattern) {
                              return _getFilteredMachineType(pattern);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: _machineTypeController,
                                textAlign: TextAlign.start,
                                onChanged: (string) {
                                  machineTypeCode = '';
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.search),
                                    hintText: 'Search Machine Type',
                                    isDense: true)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TypeAheadFormField<MachineModel>(
                            validator: (value) => machineTypeCode!.isEmpty
                                ? 'Please select machine type'
                                : null,
                            itemBuilder: (BuildContext context, itemData) {
                              return ListTile(
                                title: Text(
                                  itemData.machineName!,
                                ),
                                subtitle: Text(itemData.remarks!),
                              );
                            },
                            onSuggestionSelected: (sg) {
                              _machineController.text = sg.machineName!;
                            },
                            suggestionsCallback: (String pattern) {
                              return _getFilteredMachine(pattern);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: _machineController,
                                textAlign: TextAlign.start,
                                onChanged: (string) {},
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.search),
                                    hintText: 'Search Machine',
                                    isDense: true)),
                          ),

                          /*TextFormField(
                              controller: _machineController,
                              validator: (value) => value.trim().isEmpty
                                  ? 'Please enter machine'
                                  : null,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Machine',
                                  isDense: true)),*/
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: _machineRemarksController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Remarks',
                                  isDense: true)),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                // color: AppColor.appRed,
                                onPressed: () {
                                  if (_machineFormKey.currentState!
                                      .validate()) {
                                    _addMachine();
                                  }
                                },
                                child: Text(
                                  'Add Machine',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _addType() {
    FocusScope.of(context).unfocus();
    Map json = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'name': _typeController.text.trim(),
      'remarks': _remarksController.text.trim()
    };

    WebService.fromApi(AppConfig.addMachineType, this, json)
        .callPostService(context);
  }

  _addMachine() {
    FocusScope.of(context).unfocus();
    Map json = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'name': _machineController.text.trim(),
      'machine_type': machineTypeCode,
      'remarks': _machineRemarksController.text.trim()
    };

    logIt('Params-> $json');

    WebService.fromApi(AppConfig.addMachine, this, json)
        .callPostService(context);
  }

  _getMachineType() {
    Map json = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'table_name': 'MACHINE_TYPE',
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, json)
        .callPostService(context);
  }

  _getMachineList() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'table_name': 'MACHINE_MASTER',
      'machine_type': machineTypeCode
      // 'catalog_code': widget.catalogCode
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody,
            reqCode: AppConfig.MACHINE_MASTER)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.MACHINE_MASTER:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var contentList = data['content'] as List;

              machineList.clear();
              machineList.addAll(
                  contentList.map((e) => MachineModel.fromJSON(e)).toList());
              setState(() {});
            }
          }
          break;

        case AppConfig.addMachineType:
          {
            var data = jsonDecode(response!);
            if (data['message'] == null) return;
            if (data['error'] == 'false') {
              Commons().showAlert(context, data['message'], 'Success',
                  onOk: () {
                _getMachineType();
              });
              _typeController.clear();
              _remarksController.clear();
            } else {
              Commons().showAlert(context, data['message'], 'Failed');
            }
          }
          break;
        case AppConfig.addMachine:
          {
            var data = jsonDecode(response!);
            if (data['message'] == null) return;
            if (data['error'] == 'false') {
              Commons().showAlert(context, data['message'], 'Success',
                  onOk: () {
                _getMachineList();
              });
              machineTypeCode = '';
              _machineTypeController.clear();
              _machineRemarksController.clear();
              _machineController.clear();
            } else {
              Commons().showAlert(context, data['message'], 'Failed');
            }
          }
          break;
        case AppConfig.searchItemParameters:
          {
            var data = jsonDecode(response!);

            if (data['error'] == 'false') {
              var content = data['content'] as List;
              _macTypeList.clear();
              _macTypeList.addAll(
                  content.map((e) => MachineTypeModel.fromJSON(e)).toList());
              setState(() {});
            } else {
              if (data['message'] == null) return;
              Commons().showAlert(context, data['message'], 'Failed');
            }
          }
          break;
      }
    } catch (err) {
      logIt('Error while onResponse-> $err');
    }
  }

  _getFilteredMachineType(String str) {
    return _macTypeList
        .where((i) => i.name!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _getFilteredMachine(String str) {
    return machineList
        .where(
            (i) => i.machineName!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }
}
