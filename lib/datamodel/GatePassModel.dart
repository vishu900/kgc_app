import 'package:dataproject2/gatePass/CreateGatePass.dart';
import 'package:dataproject2/utils/Utils.dart';

class GatePassModel {
  final String? srl;
  final String? sNo;
  final String? empCode;
  final String? outDate;
  final String? outByUser;
  final String? inDate;
  final String? inByUser;
  final String? approvedBy;
  final String? approverId;
  final String? approvedDate;
  final String? placeToVisit;
  final String? purpose;
  final String? otherPurpose;
  final String? compName;
  final String? visitorName;
  final String? contact;
  final String? department;
  final String? designation;
  final String? personToMeet;
  final String? totalPerson;
  final String? entryBy;
  final String? address;
  final String? remarks;
  final String image;
  final String company;
  final String? cityCode;
  final String city;
  final String state;
  final PassType? passType;

  GatePassModel(
      {this.srl,
      this.sNo,
      this.outDate,
      this.address,
      this.empCode,
      this.outByUser,
      this.inDate,
      this.contact,
      this.inByUser,
      this.approvedBy,
      this.approverId,
      this.approvedDate,
      this.placeToVisit,
      this.purpose,
      this.otherPurpose,
      this.compName,
      this.visitorName,
      this.department,
      this.designation,
      this.personToMeet,
      this.totalPerson,
      this.remarks,
      this.passType,
      this.image='',
      this.company='',
      this.cityCode,
      this.city='',
      this.state='',
      this.entryBy});

  factory GatePassModel.parseEmployee(Map<String, dynamic> data) {
    return GatePassModel(
        srl: getString(data, 'srl'),
        sNo: getString(data, 'sno'),
        empCode: getString(data, 'emp_code'),
        outDate: getString(data, 'gate_out_date'),
        outByUser: getString(data, 'gate_out_user'),
        inByUser: getString(data, 'gate_in_user'),
        inDate: getString(data, 'gate_in_date'),
        approvedBy: getString(data['approver_name'], 'name'),
        approverId: getString(data, 'approved_user'),
        approvedDate: getString(data, 'approved_date'),
        placeToVisit: getString(data, 'place_to_visit'),
        purpose: getString(data, 'purpose'),
        image: getString(data['emp_profile_pic'], 'code_pk'),
        visitorName: getString(data['employee_name'], 'emp_name'),
        department: getString(data['employee_name'], 'dept_name'),
        designation: getString(data['employee_name'], 'desig_names'));
  }

  factory GatePassModel.parseVisitor(Map<String, dynamic> data) {

    var cityObj=data['city_name'];
    if(cityObj==null) cityObj={};

    return GatePassModel(
      sNo: getString(data, 'slipno'),
      visitorName: getString(data, 'name'),
      contact: getString(data, 'contact'),
      inDate: '${getString(data, 'indate')} ${getString(data, 'intime')}',
      purpose: getString(data, 'purpose') == 'Other'
          ? getString(data, 'other_purpose')
          : getString(data, 'purpose'),
      personToMeet: getString(data, 'person_to_meet'),
      totalPerson: getString(data, 'total_person'),
      remarks: getString(data, 'remarks'),
      outDate: '${getString(data, 'outdate')} ${getString(data, 'outtime')}',
      entryBy: getString(data, 'entryby'),
      srl: getString(data, 'sno'),
      image: getString(data, 'visitor_images_code_pk').isEmpty? getString(data['visitor_image'], 'code_pk'):getString(data, 'visitor_images_code_pk'),
      city: getString(cityObj, 'name'),
      cityCode: getString(cityObj, 'code'),
      state: getString(cityObj['state_name'], 'name'),
      company: getString(data, 'company_name'),
      address: getString(data, 'visitor_address').toString().isNotEmpty
          ? getString(data['visitor_address']['party_address'], 'acc_address')
          : getString(data, 'address'),
    );

  }

}
