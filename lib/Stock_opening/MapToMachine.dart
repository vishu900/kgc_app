import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Stock_opening/AddMachine.dart';
import 'package:dataproject2/Stock_opening/model/MachineModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MapToMachine extends StatefulWidget {
  final String? catalogCode;
  final String itemName;

  const MapToMachine(
      {Key? key, required this.catalogCode, required this.itemName})
      : super(key: key);

  @override
  _MapToMachineState createState() => _MapToMachineState();
}

class _MapToMachineState extends State<MapToMachine> with NetworkResponse {
  TextEditingController machineController = TextEditingController();
  List<MachineModel> machineList = [];
  final _formKey = GlobalKey<FormState>();

  String? _machineCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMachineList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Map To Machine',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddMachine()));
                _getMachineList();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Table(
                children: [
                  /// Catalog Item
                  TableRow(
                    children: [
                      Text(
                        'Catalog No:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.catalogCode!,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),

                  /// Catalog Name
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Catalog Name:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.itemName,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              TypeAheadFormField<MachineModel>(
                validator: (value) =>
                    _machineCode!.isEmpty ? 'Please select machine' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                itemBuilder: (BuildContext context, itemData) {
                  return ListTile(
                    title: Text(itemData.machineName!),
                    subtitle: Text(itemData.remarks!),
                  );
                },
                onSuggestionSelected: (sg) {
                  setState(() {
                    machineController.text = sg.machineName!;
                    _machineCode = sg.id;
                  });
                },
                suggestionsCallback: (String pattern) {
                  return _getFilteredMachine(pattern);
                },
                textFieldConfiguration: TextFieldConfiguration(
                    textAlign: TextAlign.start,
                    controller: machineController,
                    autofocus: false,
                    onChanged: (string) {
                      _machineCode = '';
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        hintText: 'Machine',
                        isDense: true)),
              ),
              SizedBox(
                height: 150,
              ),
              ElevatedButton(
                // color: AppColor.appRed,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _mapToMachine();
                  }
                },
                child: Text(
                  'Map Catalog',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getMachineList() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'table_name': 'MACHINE_MASTER',
      'catalog_code': widget.catalogCode
    };

    WebService.fromApi(AppConfig.searchItemParameters, this, jsonBody)
        .callPostService(context);
  }

  _mapToMachine() {
    Map jsonBody = {
      'user_id': AppConfig.prefs.getString('user_id'),
      'machine_code': _machineCode,
      'catalog_code': widget.catalogCode
    };
    logIt('params-> $jsonBody');
    WebService.fromApi(AppConfig.mapToCatalog, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.searchItemParameters:
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

        case AppConfig.mapToCatalog:
          {
            var data = jsonDecode(response!);
            if (data['message'] == null) return;
            if (data['error'] == 'false') {
              Commons().showAlert(context, data['message'], 'Success',
                  onOk: () {
                machineController.clear();
                _getMachineList();
              });
            } else {
              Commons().showAlert(context, data['message'], 'Failed');
            }
          }
      }
    } catch (err) {
      logIt('Error while onResponse-> $err');
    }
  }

  _getFilteredMachine(String str) {
    return machineList
        .where(
            (i) => i.machineName!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }
}
