import 'dart:async';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'NetworkResponse.dart';

class WebService {
  String endUrl = "";
  late NetworkResponse networkResponse;
  String? requestCode;
  Map? jsonBody;
  AlertDialog? alertDialog;
  bool isShowing = false;
  String filePath = "";
  List<dynamic>? imageList;
  List<dynamic>? audioList;

  WebService(String url, NetworkResponse networkResponse, int requestCode) {
    this.endUrl = url;
    this.networkResponse = networkResponse;
  }

  WebService.fromApi(String url, NetworkResponse networkResponse, Map? jsonBody,
      {String? reqCode}) {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.jsonBody = jsonBody;
    this.requestCode = reqCode;
  }

  WebService.multipartApi(String url, NetworkResponse networkResponse,
      Map jsonBody, String filePath,
      {String? reqCode}) {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.jsonBody = jsonBody;
    this.filePath = filePath;
    this.requestCode = reqCode;
  }

  WebService.multipartGalleryImagesApi(String url,
      NetworkResponse networkResponse, Map jsonBody, List<dynamic> imageList) {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.jsonBody = jsonBody;
    this.imageList = imageList;
  }

  WebService.multipartAudioApi(String url, NetworkResponse networkResponse,
      Map jsonBody, List<dynamic> audioList) {
    this.endUrl = url;
    this.networkResponse = networkResponse;
    this.jsonBody = jsonBody;
    this.audioList = audioList;
  }

  Future<void> callGetService(BuildContext context,
      {bool showLoader = true}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode) print("URL---->" + endUrl);
      final response = await http.get(Uri.parse(AppConfig.baseUrl + endUrl));
      if (!kReleaseMode) print("Response---->" + response.body.toString());
      if (!kReleaseMode)
        print("StatusCode---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onResponse(
            requestCode: this.endUrl, response: response.body.toString());
      } else {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onError(
            requestCode: this.endUrl, response: response.body.toString());
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      Commons().showAlert(context, 'No Internet Connection!', '');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callPostService(BuildContext context,
      {bool showLoader = true, VoidCallback? onResult}) async {
    try {
      clearFocus(context);
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode) print("PostURLLL---->" + AppConfig.baseUrl + endUrl);
      if (!kReleaseMode) print("PostParams--->" + jsonBody.toString());

      final response = await http.post(Uri.parse(AppConfig.baseUrl + endUrl),
          body: jsonBody);
      if (!kReleaseMode) print("PostResponse---->" + response.body.toString());
      if (!kReleaseMode)
        print("StatusCodePost---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }

        // if (await ifTokenNotExpired(context, response.body.toString())) {
        if (onResult != null && response.statusCode == 200) onResult();
        networkResponse.onResponse(
            requestCode: requestCode != null ? this.requestCode : this.endUrl,
            response: response.body.toString());
        //}
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }
        networkResponse.onError(
            requestCode: requestCode != null ? this.requestCode : this.endUrl,
            response: response.body.toString());
      }
    } on SocketException catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callGetServiceWithToken(BuildContext context, String myToken,
      {bool showLoader = true}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode)
        print("URL-->" + AppConfig.baseUrl + endUrl + "token-->" + myToken);

      final response = await http.get(Uri.parse(AppConfig.baseUrl + endUrl),
          headers: {HttpHeaders.authorizationHeader: myToken});

      if (!kReleaseMode) print("Response------->" + response.body.toString());
      if (!kReleaseMode)
        print("StatusCode--->>" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onResponse(
            requestCode: requestCode != null ? this.requestCode : this.endUrl,
            response: response.body.toString());
      } else {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onError(
            requestCode: requestCode != null ? this.requestCode : this.endUrl,
            response: response.body.toString());
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callPostServiceToken(BuildContext context,
      {String myToken = '', bool showLoader = true}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }
      if (myToken.trim().isEmpty) {
        myToken = getToken()!;
      }

      if (!kReleaseMode)
        print("PostURL---> ${AppConfig.baseUrl + endUrl} Token--> $myToken");
      if (!kReleaseMode) print("PostParams---->" + jsonBody.toString());

      final response = await http.post(Uri.parse(AppConfig.baseUrl + endUrl),
          headers: {HttpHeaders.authorizationHeader: 'Bearer ' + myToken},
          body: jsonBody);

      if (!kReleaseMode) print("PostResponse --->" + response.body.toString());
      if (!kReleaseMode)
        print("StatusCode --->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        // if (await ifTokenNotExpired(context, response.body.toString())) {
        networkResponse.onResponse(
            requestCode: this.endUrl, response: response.body.toString());
        // }
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }
        networkResponse.onError(
            requestCode: this.endUrl, response: response.body.toString());
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callMultipartPostServiceToken(
      BuildContext context, String myToken,
      {bool showLoader = true}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode)
        print("PostURLLL--->" +
            AppConfig.baseUrl +
            endUrl +
            "Token---->" +
            myToken);
      if (!kReleaseMode) print("PostParams--->" + jsonBody.toString());
      if (!kReleaseMode) print("UserIdMulti" + jsonBody!['user_id']);

      //var fileName = path.basename(filePath);

      var request =
          http.MultipartRequest('POST', Uri.parse(AppConfig.baseUrl + endUrl));

      if (filePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath('images', filePath);
        request.files.add(pic);
        if (!kReleaseMode) print("FileName:--->" + filePath);
      }

      request.headers['authorization'] = myToken;
      request.fields.addAll(jsonBody as Map<String, String>);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (!kReleaseMode) print("Requests--->" + request.toString());
      if (!kReleaseMode) print("PostResponse----> " + responseString);
      if (!kReleaseMode)
        print("StatusCodePost---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onResponse(
            requestCode: this.endUrl, response: responseString);
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }
        networkResponse.onError(
            requestCode: this.endUrl, response: responseString);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callMultipartPostService(BuildContext context,
      {bool showLoader = true, String fileName = 'filename[]'}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode)
        print("PostURLLL--->" + AppConfig.baseUrl + endUrl + "Token---->");
      if (!kReleaseMode) print("PostParams--->" + jsonBody.toString());
      if (!kReleaseMode) print("UserIdMulti" + jsonBody!['user_id']);

      //var fileName = path.basename(filePath);

      var request =
          http.MultipartRequest('POST', Uri.parse(AppConfig.baseUrl + endUrl));

      if (filePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath(fileName, filePath);
        request.files.add(pic);
        if (!kReleaseMode) print("FileName:--->" + filePath);
      }

      request.fields.addAll(Map.from(jsonBody!));

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (!kReleaseMode) print("Requests--->" + request.toString());
      if (!kReleaseMode) print("PostResponse----> " + responseString);
      if (!kReleaseMode)
        print("StatusCodePost---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onResponse(
            requestCode: this.endUrl, response: responseString);
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }
        networkResponse.onError(
            requestCode: this.endUrl, response: responseString);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callMultipartCreateGalleryService(BuildContext context,
      {bool showLoader = true, String fileName = 'filename[]'}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      logIt("PostURLLL--->" + AppConfig.baseUrl + endUrl);
      logIt("PostParams-->" + jsonBody.toString());
      logIt("FileLength-->" + imageList!.length.toString());

      var request =
          http.MultipartRequest('POST', Uri.parse(AppConfig.baseUrl + endUrl));

      if (imageList != null && imageList!.isNotEmpty) {
        for (var i = 0; i < imageList!.length; i++) {
          logIt("FileName: " + imageList![i].toString());
          var pic = await http.MultipartFile.fromPath(
              fileName, imageList![i].toString());
          request.files.add(pic);
        }
      }

      request.fields.addAll(Map.from(jsonBody!));

      request.files.forEach((element) {
        logIt('InMultipartService-> ${element.filename}');
      });

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      logIt('ResponseData-> $responseData');
      var responseString = String.fromCharCodes(responseData);

      if (!kReleaseMode) print("Requests--->" + request.toString());
      if (!kReleaseMode) debugPrint("PostResponse---->" + responseString);
      if (!kReleaseMode)
        print("StatusCodePost---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }
        networkResponse.onResponse(
            requestCode: this.endUrl, response: responseString);
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }
        networkResponse.onError(
            requestCode: this.endUrl, response: responseString);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  Future<void> callUploadAudioService(BuildContext context, String myToken,
      {bool showLoader = true}) async {
    try {
      if (showLoader) {
        isShowing = true;
        showLoaderDialog(context);
      }

      if (!kReleaseMode)
        print("PostURLLL--->" +
            AppConfig.baseUrl +
            endUrl +
            "Token-->" +
            myToken);
      if (!kReleaseMode) print("PostParams-->" + jsonBody.toString());
      if (!kReleaseMode) print("UserIdMulti-->" + jsonBody!['user_id']);

      var request =
          http.MultipartRequest('POST', Uri.parse(AppConfig.baseUrl + endUrl));

      if (audioList != null && audioList!.isNotEmpty) {
        if (!kReleaseMode)
          print("FileLength--->" + audioList!.length.toString());
        for (var i = 0; i < audioList!.length; i++) {
          if (!kReleaseMode) print("FileName: " + audioList![i].toString());

          var pic = await http.MultipartFile.fromPath(
              'music', audioList![i].toString());

          request.files.add(pic);
        }
      }

      request.headers['authorization'] = myToken;
      request.fields.addAll(jsonBody as Map<String, String>);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (!kReleaseMode) print("Requests--->" + request.toString());
      if (!kReleaseMode) print("PostResponse---->" + responseString);
      if (!kReleaseMode)
        print("StatusCodePost---->" + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (showLoader) {
          if (alertDialog != null && isShowing) {
            isShowing = false;
            Navigator.pop(context);
          }
        }

        networkResponse.onResponse(
            requestCode: this.endUrl, response: responseString);
      } else {
        if (alertDialog != null && isShowing) {
          isShowing = false;
          Navigator.pop(context);
        }

        networkResponse.onError(
            requestCode: this.endUrl, response: responseString);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'No Internet Connection!');
      logIt('Socket Exception thrown --> $e');
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      showAlert(context, 'Please! Try Again');
      logIt('TimeoutException thrown --> $e');
    } catch (err) {
      Navigator.pop(context);
      logIt('Error While Making network call -> $err');
    }
  }

  void showLoaderDialog(BuildContext context) {
    if (alertDialog != null && isShowing) {
      isShowing = false;
      Navigator.pop(context);
    }
    alertDialog = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(AppColor.appRed)),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      barrierLabel: 'Loader',
      builder: (BuildContext context) {
        return alertDialog!;
      },
    );
  }

  void showAlert(BuildContext context, String msg,
      {VoidCallback? onOk,
      VoidCallback? onNo,
      String ok = 'OK',
      String? notOk}) {
    AlertDialog alert = AlertDialog(
      title: Text('Error!'),
      content: Text(msg),
      actions: [
        Visibility(
          visible: notOk != null,
          child: ElevatedButton(
            child: Text(notOk == null ? '' : notOk),
            onPressed: () {
              if (onNo != null) {
                onNo();
              }
            },
          ),
        ),
        ElevatedButton(
          child: Text(ok),
          onPressed: () {
            Navigator.of(context).pop();
            if (onOk != null) {
              onOk();
            }
          },
        )
      ],
    );

    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: alert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }
}
