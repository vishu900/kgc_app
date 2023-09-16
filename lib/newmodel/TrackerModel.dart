import 'TrackerItemModel.dart';

class TrackerModel {
  String? title = '';
  String? totalDocCount = '';
  List<TrackerItemModel>? trackerItems = [];

  TrackerModel({this.title, this.totalDocCount,this.trackerItems});

  factory TrackerModel.fromJson(Map<String, dynamic> json) {
    var products = json['details'] as List;
    return TrackerModel(
        title: json['title'] == null ? '' : json['title'],
        totalDocCount: getTotalDocCount(products),
        trackerItems: products.map((e) => TrackerItemModel.fromJson(e)).toList());
  }

 static String getTotalDocCount(List<dynamic> products){

    int count=0;
    List<TrackerItemModel> trackerItems = [];
    trackerItems.addAll(products.map((e) => TrackerItemModel.fromJson(e)).toList());

    trackerItems.forEach((element) {

      if(element.totalDocs!.isNotEmpty){

        try{

          count += int.parse(element.totalDocs!);

        }catch(err){
          print('An Error Occurred $err');
        }

      }

    });


    return count.toString();

  }

}
