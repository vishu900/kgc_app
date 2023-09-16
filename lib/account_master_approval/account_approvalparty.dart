import 'dart:convert';

import 'package:dataproject2/account_master_approval/account_master_approval.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountApprovalParty extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountApprovalParty();
}

class _AccountApprovalParty extends State<AccountApprovalParty>
    with NetworkResponse {

  List<AccountApprovalPartyModel> accountApprovalPartyMainList = [];
  List<AccountApprovalPartyModel> accountApprovalPartyList = [];
  final TextEditingController _partySearchController=TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  _init() {
    _getAllParties();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Account Approval Party"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16,12,16,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _partySearchController,
                    onChanged:(v)=> _filterParties(v.trim()),
                    decoration: InputDecoration(
                      isDense:true,
                      hintText: 'Search Party',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Total: ${accountApprovalPartyList.length}'
                      ,style: TextStyle(fontSize: 14,color: CupertinoColors.inactiveGray),),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: accountApprovalPartyList.length,
                  itemBuilder: (context, index) => Card(child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountMasterApproval(
                                  id: accountApprovalPartyList[index].id,
                                ),
                              ));
                          _partySearchController.clear();
                          _getAllParties(showLoader: false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  'Name',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  accountApprovalPartyList[index].name!,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  'BS Group',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  accountApprovalPartyList[index].groupname!,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  'Added Uid',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  accountApprovalPartyList[index].uid!,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  'Added Date',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  accountApprovalPartyList[index].date!,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ])
                            ],
                          ),
                        ),
                      ))
              ),
            ),
          ],
        )
    );

  }

  _getAllParties({bool showLoader = true}) {
    Map jsonBody = {'user_id': getUserId()};
    WebService.fromApi(AppConfig.accountPartyList, this, jsonBody).callPostService(context, showLoader: showLoader);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    if (requestCode == AppConfig.accountPartyList) {
      var data = jsonDecode(response!);
      if (data['error'] == 'false') {
        var content = data['content'] as List;
        accountApprovalPartyList.clear();
        accountApprovalPartyMainList.clear();
        accountApprovalPartyList.addAll(content
            .map((e) => AccountApprovalPartyModel.parsejson(e))
            .toList());
        accountApprovalPartyMainList.addAll(accountApprovalPartyList);
        setState(() {});
      }
    }
  }

  _filterParties(String str){
    accountApprovalPartyList.clear();
    if(str.isNotEmpty){
      accountApprovalPartyList.addAll(accountApprovalPartyMainList.where((a)=> a.id!.toLowerCase().contains(str.toLowerCase())
          || a.name!.toLowerCase().contains(str.toLowerCase())
          || a.date!.toLowerCase().contains(str.toLowerCase())
          || a.groupname!.toLowerCase().contains(str.toLowerCase())
          || a.uid!.toLowerCase().contains(str.toLowerCase()))
      );
    }else{
      accountApprovalPartyList.addAll(accountApprovalPartyMainList);
    }
    setState(() {});
  }

}

class AccountApprovalPartyModel {
  String? id, name, groupname, uid, date;

  AccountApprovalPartyModel({
    required this.name,
    required this.groupname,
    this.uid,
    this.date,
    this.id,
  });

  factory AccountApprovalPartyModel.parsejson(Map<String, dynamic> data) {
    return AccountApprovalPartyModel(
      id: getString(data, 'code'),
      groupname: getString(data['bs_group_name'], 'name'),
      name: getString(data, 'name'),
      uid: getString(data, 'ins_uid'),
      date: getFormattedDate(getString(data, 'ins_date'),
          outFormat: 'dd-MM-yyyy hh:mm a'),
    );
  }
}
