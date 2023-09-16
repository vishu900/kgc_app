import 'package:dataproject2/utils/Utils.dart';

class LocationListModel {
  final String? id;
  final String? name;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? pinCode;

  LocationListModel(
      {this.id,
      this.name,
      this.pinCode,
      this.address1,
      this.address2,
      this.city,
      this.state});

  factory LocationListModel.fromJSON(Map<dynamic, dynamic> data) {
    logIt('LocationModel-> PinCode ${getString(data, 'pin_code,')}');

    return LocationListModel(
      id: getString(data, 'code').toString(),
      name: getString(data, 'name').toString(),
      address1: getString(data, 'address_line_1').toString(),
      address2: getString(data, 'address_line_2').toString(),
      city: getString(data, 'city').toString(),
      state: getString(data, 'state').toString(),
      pinCode: getString(data, 'pin_code').toString(),
    );
  }
}
