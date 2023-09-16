
import 'dart:convert';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/newmodel/QCompanyModel.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'gateEntry.dart';
import 'gate_entry_selection.dart';

class GateEntryCompSelection extends StatefulWidget {


  final GateEntryType gateEntryType;

  const GateEntryCompSelection({
    Key? key,
    this.gateEntryType= GateEntryType.CHALLAN
  }): super(key: key);

  @override
  _GateEntryCompSelectionState createState() => _GateEntryCompSelectionState();

}

class _GateEntryCompSelectionState extends State<GateEntryCompSelection>
    with NetworkResponse {

  List<QCompanyModel> companyList = [];
  String _imageBaseUrl='';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCompanyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            /*Container(
              height: 28,
              width: 28,
              child: Image.network(
                  '${widget.imageBaseUrl}${widget.logo}'),
            ),
            SizedBox(width: 8),*/
            Flexible(child: Text('Gate Entry')),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: companyList.length,
          itemBuilder: (ctx, index) =>
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GateEntrySelection(
                              compCode: companyList[index].id,
                              compName: companyList[index].name,
                              imageBaseUrl: _imageBaseUrl,
                              logo: companyList[index].logoName,
                            )
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 28,
                          width: 28,
                          child: Image.network(
                              '${AppConfig.small_image}${companyList[index].logoName}'),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  companyList[index].name!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                companyList[index].count,
                                style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  _getCompanyList() {
    Map jsonBody = {
      'user_id': getUserId(),
      'tid':Permissions.GATE_ENTRY_BILL,
      'mode_flag':'A,I'
    };
    WebService.fromApi(AppConfig.getCompany, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {

      switch (requestCode) {

        case AppConfig.getCompany:
          {

            var data = jsonDecode(response!);

            if (data['error'] == 'false') {

              logIt('GetCompany-> $data');

              var content = data['content'] as List;
              companyList.clear();
              companyList.addAll(content.map((e) => QCompanyModel.parseGateEntryComp(e)).toList());
              setState(() {});

            }

          }
          break;
      }

    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

}
