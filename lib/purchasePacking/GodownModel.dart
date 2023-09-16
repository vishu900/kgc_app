import 'package:dataproject2/utils/Utils.dart';

class GodownModel{

  final String? id;
  final String? name;
  final String? godownTag;

  GodownModel({this.id, this.name, this.godownTag});

  factory GodownModel.fromJson(Map<String,dynamic> data){

    return GodownModel(
      id: getString(data, 'code'),
      name: getString(data, 'name'),
      godownTag: getString(data, 'godown_tag')
    );

  }

}