import 'package:dataproject2/utils/Utils.dart';

class LocationUserModel {
  final String? id;
  final String? name;
  final String? image;
  bool isAssigned;

  LocationUserModel({this.id, this.name, this.image, this.isAssigned = false});

  factory LocationUserModel.fromJSON(Map<dynamic, dynamic> data) {
    return LocationUserModel(
      id: data['user_id'].toString(),
      name: getString(data, 'name'),
      image: getString(data, 'image_name'),
      isAssigned: getString(data, 'have_factory_access').toString() == 'N'
          ? false
          : true,
    );
  }
}
