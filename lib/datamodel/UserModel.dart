import 'package:dataproject2/utils/Utils.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? company;
  final String image;
  final String lsCode;

  UserModel({this.id, this.name, this.company,this.image='',this.lsCode=''});

  factory UserModel.parseUser(Map<String, dynamic> data) {
    return UserModel(
      id: getString(data, 'user_id'),
      name: getString(data, 'name'),
    );
  }

  factory UserModel.parseEmployee(Map<String, dynamic> data) {
    return UserModel(
      id: getString(data, 'code'),
      image: getString(data['emp_profile_pic'], 'code_pk'),
      lsCode: getString(data, 'ls_code'),
      name: '${getString(data, 'first_name')} ${getString(data, 'middle_name')} ${getString(data, 'last_name')}',
    );
  }

}
