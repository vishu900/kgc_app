import 'appConfig/AppConfig.dart';
import 'networking.dart';

const companyApiURl = "${AppConfig.baseUrl}api/company";

class CompanyModel {
  Future<dynamic> getCityWeather() async {
    NetworkHelper networkHelper = NetworkHelper('$companyApiURl');

    var companylistdata = await networkHelper.getData();
    return companylistdata;
  }
}
