import 'package:dataproject2/utils/Utils.dart';

class AddressModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String cityCode;
  final String state;
  final String stateCode;
  final bool isVisitor;

  AddressModel(
      {this.id = '',
      this.name = '',
      this.address = '',
      this.city = '',
      this.cityCode = '',
      this.state = '',
      this.stateCode = '',
      this.isVisitor = false});

  factory AddressModel.parseAddress(Map<String, dynamic> data) {

    var partyObj=data['party_address_with_city'];
    if(partyObj==null) partyObj={};
    var partyStateObj=partyObj['city_name'];
    if(partyStateObj==null) partyStateObj={};

    return AddressModel(
        isVisitor: false,
        id: getString(data, 'code'),
        name: getString(data, 'name'),
        address: getString(partyObj, 'add1'),
        city: getString(partyObj['city_name'], 'name'),
        cityCode: getString(partyObj['city_name'], 'code'),
        state: getString(partyStateObj['state_name'], 'name'),
        stateCode: getString(partyStateObj['state_name'], 'code'),
    );

  }

  factory AddressModel.parseVisitorAddress(Map<String, dynamic> data) {
    return AddressModel(isVisitor: true, address: getString(data, 'address'));
  }

}
