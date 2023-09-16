import 'package:dataproject2/utils/Utils.dart';

class DataModel {
  final String? id;
  final String? name;
  final String? stateName;
  final String? countryName;
  final bool isSelected;

  DataModel(
      {this.id,
      this.name,
      this.stateName,
      this.countryName,
      this.isSelected = false});

  factory DataModel.fromJSON(Map<String, dynamic> data) {
    return DataModel(
        id: getString(data, 'code').toString(), name: getString(data, 'name'));
  }

  factory DataModel.fromJSONCity(Map<String, dynamic> data) {
    return DataModel(
      id: getString(data, 'code').toString(),
      name: getString(data, 'name'),
      stateName: getString(data['state_name'], 'name'),
      countryName: getString(data['state_name']['country_name'], 'name'),
    );
  }
}
