import 'package:dataproject2/utils/Utils.dart';

class ContactUserModel {

  final String name;
  final String inDate;
  final String purpose;
  final String otherPurpose;
  final String personToMeet;
  final String totalPerson;
  final String address;
  final String? company;
  final String? cityCode;
  final String addressCode;
  final String image;
  final String contact;
  bool isSelected;

  ContactUserModel({this.name = '',
    this.inDate = '',
    this.purpose = '',
    this.otherPurpose = '',
    this.personToMeet = '',
    this.totalPerson = '',
    this.address = '',
    this.addressCode = '',
    this.image = '',
    this.contact = '',
    this.company,
    this.cityCode,

    this.isSelected = false});

  factory ContactUserModel.parse(Map<String, dynamic> data){

    var vAddObj=data['visitor_address'];

    if(vAddObj==null) vAddObj={};

    return ContactUserModel(
      name: getString(data, 'name'),
      contact: getString(data, 'contact'),
      inDate: '${getString(data, 'indate')} ${getString(data, 'intime')}',
      purpose: getString(data, 'purpose') == 'Other'
          ? getString(data, 'other_purpose')
          : getString(data, 'purpose'),
      image: getString(data, 'visitor_images_code_pk')
          .trim()
          .isEmpty ? getString(data['visitor_image'], 'code_pk') : getString(
          data, 'visitor_images_code_pk'),
      otherPurpose: getString(data, 'other_purpose'),
      personToMeet: getString(data, 'person_to_meet'),
      totalPerson: getString(data, 'total_person'),
      cityCode: getString(data, 'city_code'),
      company: getString(data, 'address_type').toString() == 'Y'
        ? getString(data['visitor_address'], 'name')
        : getString(data, 'company_name'),
      addressCode: getString(data, 'address_type').toString() == 'Y'
          ? getString(data, 'address')
          : '',
      address: getString(data, 'address_type').toString() == 'Y'
          ? '${getString(
          vAddObj['party_address'], 'acc_address')}'.isEmpty? getString(data, 'address'):'${getString(
          vAddObj['party_address'], 'acc_address')}'
          : getString(data, 'address'),
    );
  }


}