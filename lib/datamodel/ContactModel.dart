import 'package:dataproject2/utils/Utils.dart';

class ContactModel {
  final String? id;
  String? title;
  String? titleId;
  String? name;
  String? address;
  String? address2;
  String? city;
  String? cityId;
  String? state;
  String? stateId;
  String? country;
  String? countryId;
  String? pinCode;
  String? mobile;
  String? mobile2;
  String? phone;
  String? fax;
  String? email;
  String? email2;
  String? email3;
  String? website;
  bool isActive;
  bool sendMailAuto;
  bool sendLedger;
  int imagePos;
  List<String?>? imageList;

  ContactModel(
      {this.id,
      this.title,
      this.titleId,
      this.name,
      this.address,
      this.address2,
      this.city,
      this.cityId,
      this.state,
      this.stateId,
      this.country,
      this.countryId,
      this.pinCode,
      this.mobile,
      this.mobile2,
      this.phone,
      this.fax,
      this.email,
      this.email2,
      this.email3,
      this.website,
      this.isActive = true,
      this.sendMailAuto = false,
      this.sendLedger = false,
      this.imageList,
      this.imagePos = 0});

  factory ContactModel.fromJSON(Map<String, dynamic> data) {
    var imageList = data['person_images'] as List;

    List<String?> _imageList = [];
    logIt('onResponse-> ${_imageList.length}');

    imageList.forEach((element) {
      _imageList.add(element['code']);
    });

    return ContactModel(
        id: getString(data, 'code').toString(),
        name: getString(data, 'name'),
        title: getString(data['title_name'], 'name'),
        titleId: getString(data['title_name'], 'code'),
        address: getString(data, 'add1'),
        address2: getString(data, 'add2'),
        city: getString(data['city_name'], 'name'),
        cityId: getString(data['city_name'], 'code'),
        state: getString(data['city_name']['state_name'], 'name'),
        stateId: getString(data['city_name']['state_name'], 'code'),
        country:
            getString(data['city_name']['state_name']['country_name'], 'name'),
        countryId:
            getString(data['city_name']['state_name']['country_name'], 'code'),
        pinCode: getString(data, 'pin_code'),
        email: getString(data, 'email_id'),
        email2: getString(data, 'email_id_2'),
        email3: getString(data, 'email_id_3'),
        mobile: getString(data, 'mobile_no1'),
        mobile2: getString(data, 'mobile_no2'),
        fax: getString(data, 'fax_no'),
        phone: getString(data, 'ph_no'),
        website: getString(data, 'url_id'),
        isActive: getString(data, 'active_tag') == 'Y',
        sendMailAuto: getString(data, 'send_email') == 'Y',
        imageList: _imageList);
  }
}
