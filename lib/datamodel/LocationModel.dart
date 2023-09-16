class LocationModel {
  final String? id;
  final double? lat;
  final double? long;
  final int? range;

  LocationModel({this.id, this.lat, this.long, this.range});

  factory LocationModel.fromJSON(Map<String, dynamic> data) {
    var locData = data['factory_name'];
    return LocationModel(
        id: data['factory_code'] != null ? data['factory_code'].toString() : '',
        lat: double.parse(locData['latitude'].toString()),
        long: double.parse(locData['longitude'].toString()),
        range: int.parse(locData['location_area']));
  }
}
