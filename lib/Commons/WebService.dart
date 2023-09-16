import 'dart:async';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebService {
  final String TAG = "WebService";
  final isDebugModeEnabled = true;

  //POST
  Future<http.Response?> post(
      BuildContext context, String url, String jsonEncoder) async {
    if (isDebugModeEnabled) {
      print("$TAG httpUrl-> ${AppConfig.baseUrl + url}");

      print("$TAG PostParam-> $jsonEncoder ");

      if (!await Commons().isConnected().then((value) => value)) {
        Navigator.of(context).pop();
        showNetworkAlert(context);
        return null;
      }

      final http.Response data =
          await http.post(Uri.parse(AppConfig.baseUrl + url),
              headers: <String, String>{
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncoder);

      //  if (isDebugModeEnabled) debugPrint("$TAG Response is post-> ${data.body}",wrapWidth:1024);
      if (isDebugModeEnabled)
        debugPrint("$TAG Response is post-> ${data.body}");

      return data;
    }
    return null;
  }

  //POST With Token
  Future<http.Response?> postToken(BuildContext context, String url,
      String jsonEncoder, String token) async {
    if (isDebugModeEnabled) {
      print("$TAG httpUrl-> ${AppConfig.baseUrl + url}");
      print("$TAG Token-> $token ");
      print("$TAG PostParam-> $jsonEncoder ");
    }

    if (!await Commons().isConnected().then((value) => value)) {
      Navigator.of(context).pop();
      showNetworkAlert(context);
      return null;
    }

    http.Response? data;

    try {
      data = await http
          .post(Uri.parse(AppConfig.baseUrl + url),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncoder)
          .timeout(Duration(minutes: 3));
    } on TimeoutException catch (e) {
      debugPrint("TimeoutException ${e.message}");
    } on Exception catch (ex) {
      debugPrint("Exception $ex");
    }

    if (isDebugModeEnabled) print("$TAG Response is post-> ${data!.body}");

    return data;
  }

  //Get With Token
  Future<http.Response?> get(
      BuildContext context, String url, String token) async {
    if (!await Commons().isConnected().then((value) => value)) {
      Navigator.of(context).pop();
      showNetworkAlert(context);
      return null;
    }

    if (isDebugModeEnabled) {
      print("$TAG httpUrl-> ${AppConfig.baseUrl + url}");
      print("$TAG Token-> $token ");
    }

    final http.Response data = await http.get(
      Uri.parse(AppConfig.baseUrl + url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token'
      },
    );

    if (isDebugModeEnabled) print("$TAG Response is post-> ${data.body}");

    return data;
  }

  showNetworkAlert(BuildContext ctx) {
    AlertDialog alert = AlertDialog(
      title: Text('App Says' /*Strings.appName*/),
      content: Text("Internet connectivity not available"),
      actions: [
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(ctx, rootNavigator: true).pop();
          },
        ),
      ],
    );

    showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          return alert;
        });
  }

  static fromApi(String getCompany, _fullAndFinalCompSelection, Map jsonBody) {}
}
