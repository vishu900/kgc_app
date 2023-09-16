import 'package:dataproject2/utils/Utils.dart';

class CompanySelectionModel {
  final String? id;
  final String? companyName;
  final String? companyLogo;
  final String? count;
  List<CompanyUserModel>? userList = [];

  CompanySelectionModel(
      {this.id, this.companyName, this.companyLogo, this.userList, this.count});

  factory CompanySelectionModel.fromJSON(Map<String, dynamic> data) {
    var userContentList = data['user_lists'] as List;
    List<CompanyUserModel> userList = [];
    userList.addAll(
        userContentList.map((e) => CompanyUserModel.fromJSON(e)).toList());

    return CompanySelectionModel(
        id: getString(data, 'code'),
        companyName: getString(data, 'name'),
        companyLogo: getString(data, 'code') == '99'
            ? 'bk_intl.png'
            : getString(data, 'logo_name'), //bk_intl.png
        count: getString(data, 'inder_order_count'),
        userList: userList);
  }
}

class CompanyUserModel {
  final String? id;
  final String? userName;
  final int? count;

  CompanyUserModel({this.id, this.userName, this.count});

  factory CompanyUserModel.fromJSON(Map<String, dynamic> data) {
    return CompanyUserModel(
        id: getString(data, 'user_id'),
        userName: getString(data, 'name'),
        count: int.parse(getString(data, 'count')));
  }
}
