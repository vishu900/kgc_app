import 'package:dataproject2/gatePass/EmpModel.dart';
import 'package:dataproject2/utils/Utils.dart';

class EmpGatePassModel{
  final String? id;
  final String? serialNo;
  final String? sno;
  final String? dueDate;
  final String? outDate;
  final String? outByUser;
  final String? inDate;
  final String? inByUser;
  final String? approvedBy;
  final String? approverId;
  final String? approvedDate;
  final List<EmpModel>? empList;

  EmpGatePassModel(
      {this.id,
      this.dueDate,
      this.serialNo,
      this.sno,
      this.outDate,
      this.outByUser,
      this.inDate,
      this.inByUser,
      this.approvedBy,
      this.approverId,
      this.approvedDate,
      this.empList
      });

  factory EmpGatePassModel.fromJson(Map<String,dynamic> data){

    var empList=data['emp_lists'] as List;
    List<EmpModel> employeeList =[];

    if(empList.isNotEmpty){
      employeeList.addAll(empList.map((e) => EmpModel.fromJson(e) ).toList());
    }

    return EmpGatePassModel(
      id: getString(data, 'code_pk'),
      serialNo: getString(data, 'sno'),
      sno: getString(data, 'srl'),
      dueDate: getString(data, 'out_date'),
      outDate: getString(data, 'gate_out_date'),
      outByUser: getString(data, 'gate_out_user'),
      inDate: getString(data, 'gate_in_date'),
      inByUser: getString(data, 'gate_in_user'),
      approverId: getString(data, 'approved_user'),
      approvedDate: getString(data, 'approved_date'),
      approvedBy: getString(data['approver_name'], 'name'),
      empList:employeeList
    );

  }

}