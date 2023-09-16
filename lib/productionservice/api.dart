import 'dart:convert';

import 'package:dataproject2/productionmodel/AddingResult.dart';
import 'package:dataproject2/productionmodel/Companies.dart';
import 'package:dataproject2/productionmodel/DocNo.dart';
import 'package:dataproject2/productionmodel/HdrRequest.dart';
import 'package:dataproject2/productionmodel/ListItem.dart';
import 'package:dataproject2/productionmodel/LoginResponse.dart';
import 'package:dataproject2/productionmodel/PendingOrder.dart';
import 'package:dataproject2/productionmodel/PkCode.dart';
import 'package:dataproject2/productionmodel/partynameresp.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<LoginResponse> login(String user, String password) async {
    final String baseUrl =
        'http://103.204.185.17:24977/webapi/api/Common/Validate?userid=$user&password=$password';
    LoginResponse loginResponse = LoginResponse();
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        loginResponse = LoginResponse.fromMap(data);
      }
      return loginResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Companies>> getCompanies() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final String baseUrl =
        'http://103.204.185.17:24977/webapi/api/Common/GetCompanyFromTask?p_Taskid=MATERIAL_RECD_4_PROD_ORD&p_userid=${pref.getString("user")}';
    List<Companies> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = List.from(data)
            .map<Companies>((e) => Companies.fromJson(e))
            .toList();
        print("bodydatacompanies" + data.toString());
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PkCode>> getPkCodes(bool is_head) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl = "";

    if (is_head) {
      baseUrl =
          'http://103.204.185.17:24977/webapi/api/Common/GetProdRecdHdrPk';
    } else {
      baseUrl =
          'http://103.204.185.17:24977/webapi/api/Common/GetProdRecdDtlPk';
    }

    List<PkCode> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        ebooksList =
            List.from(data).map<PkCode>((e) => PkCode.fromJson(e)).toList();
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PkCode>> getPkstockCodes() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl =
        "http://103.204.185.17:24977/webapi/api/Common/ProdRecdStkDtlPk";

    List<PkCode> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        ebooksList =
            List.from(data).map<PkCode>((e) => PkCode.fromJson(e)).toList();
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DocNo>> getDocNo(String finnumber) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? dataone = pref.getString("company");
    print("finddatadoc" + finnumber + "compa" + dataone!);
    String baseUrl = "";

    baseUrl =
        'http://103.204.185.17:24977/webapi/api/Common/GetProdRecdHdrDocNo?P_Comp_Code=${pref.getString("company")}&p_Finyear=$finnumber';

    List<DocNo> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList =
            List.from(data).map<DocNo>((e) => DocNo.fromJson(e)).toList();
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddingResult> postHdr(HdrRequest hdrRequest) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl = "";

    baseUrl = 'http://103.204.185.17:24977/webapi/api/ProdRecd/AddProdHdr';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    AddingResult ebooksList = AddingResult();
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(hdrRequest.toJson()),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = AddingResult.fromJson(data);
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddingResult> postPendingOrder(List<Map> hdrRequest) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl = "";

    baseUrl = 'http://103.204.185.17:24977/webapi/api/ProdRecd/AddProdDtl';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    AddingResult ebooksList = AddingResult();
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(hdrRequest),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = AddingResult.fromJson(data);
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddingResult> postStock(List<Map> hdrRequest) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl = "";

    baseUrl = 'http://103.204.185.17:24977/webapi/api/ProdRecd/AddProdStockDtl';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    AddingResult ebooksList = AddingResult();

    print("stockbodydata" + hdrRequest.toString());
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(hdrRequest),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = AddingResult.fromJson(data);
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  String machine =
      "http://103.204.185.17:24977/webapi/api/Common/GetAccContPerson?P_Acc_Code=";
  String godown =
      "http://103.204.185.17:24977/webapi/api/Common/GetGodown?P_Comp_code=";
  String acc = "http://103.204.185.17:24977/webapi/api/Common/GetAccMaster";

  List<ListItem> accList = [];
  List<ListItem> godownList = [];
  List<ListItem> machineList = [];
  Future<List<ListItem>> getList(String url, String input) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (url == machine) {
      machine = machine + pref.getString("acc")!;
      url = url + pref.getString("acc")!;
    }
    if (url == godown) {
      godown = godown + pref.getString("company")!;
      url = url + pref.getString("company")!;
    }

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (url == machine) {
          if (machineList.isEmpty) {
            machineList = List.from(data)
                .map<ListItem>((e) => ListItem.fromJson(e))
                .toList();
          }
          return machineList
              .where((o) => o.name!.toLowerCase().contains(input.toLowerCase()))
              .toList();
        }
        if (url == acc) {
          if (accList.isEmpty) {
            accList = List.from(data)
                .map<ListItem>((e) => ListItem.fromJson(e))
                .toList();
          }

          return accList
              .where((o) => o.name!.toLowerCase().contains(input.toLowerCase()))
              .toList();
        }
        if (url == godown) {
          if (godownList.isEmpty) {
            godownList = List.from(data)
                .map<ListItem>((e) => ListItem.fromJson(e))
                .toList();
          }
          return godownList
              .where((o) => o.name!.toLowerCase().contains(input.toLowerCase()))
              .toList();
        }
      }
      return <ListItem>[];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PendingOrder>> getPendingOrders() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();

    final String baseUrl =
        'http://103.204.185.17:24977/webapi/api/PendingOrder/GetPendingOrders?comp_code=3&acc_code=216';
    List<PendingOrder> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = List.from(data)
            .map<PendingOrder>((e) => PendingOrder.fromJson(e))
            .toList();
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Partnameresp>> getCompaniespartyname() async {
    final String baseUrl =
        'http://103.204.185.17:24977/webapi/api/Common/GetIntrlAcc';
    List<Partnameresp> ebooksList = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = List.from(data)
            .map<Partnameresp>((e) => Partnameresp.fromJson(e))
            .toList();
        print("bodydatacompanies" + data.toString());
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }
}
