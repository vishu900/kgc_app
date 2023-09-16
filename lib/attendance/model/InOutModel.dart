import 'package:dataproject2/utils/Utils.dart';

class InOutModel{

  final String? punchTime;
  final bool isIn;
  bool isShift;
  bool isNightShift;

  InOutModel({this.punchTime, this.isIn=false,this.isShift=false,this.isNightShift=false});

  factory InOutModel.parse(Map<String,dynamic> data){

    return InOutModel(
      isIn: getString(data, 'direction')=='in',
     // isIn: getString(data, 'deviceid')=='3',
      punchTime: getString(data, 'logdate')
    );

  }

}