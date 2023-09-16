import 'dart:core';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dataproject2/bankPayment/BankPayment.dart';
import 'package:dataproject2/gatePass/CreateGatePass.dart';
import 'package:dataproject2/gatePass/GatePass.dart';
import 'package:dataproject2/indent/IndentReport.dart';
import 'package:dataproject2/main.dart';
import 'package:dataproject2/notifications/boms/notification_sbom.dart';
import 'package:dataproject2/notifications/notification_saleorder/notification_sorder.dart';
import 'package:dataproject2/purchaseOrder/PurchaseOrders.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Commons {
  void enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void disableRotation() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    print("disableRotation");
  }

  void showAlert(BuildContext context, String msg, String title,
      {VoidCallback? onOk,
      VoidCallback? onNo,
      String ok = 'OK',
      String? notOk}) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
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

  void showAnimatedDialog(BuildContext context, AlertDialog alert) {
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

  String getFormattedDate(String date) {
    if (date.trim().isEmpty) return "";
    final formatter = new DateFormat('MM/dd/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  String getDDMMYYYYDate(String date) {
    if (date.trim().isEmpty) return "";
    final formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  /*  static Future<File?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
    );
    return result;
  } */

  void showProgressbar(BuildContext context) {
    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: 'CLoader',
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  static void pushToScreen(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');
    var type = data['data']['notify_type'];
    debugPrint('pushToScreen $type');

    switch (type) {
      /// Sale Order and Sale Order BOM
      case '1':
        {
          debugPrint('pushToScreen Sale Order and Sale Order BOM');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => NotificationSaleOrder(
                order_id: data['data']['order_id'],
                order_type: data['data']['notify_type'],
                company_code: data['data']['company_code'],
                user_id: userId,
                iconlink:
                    '${data['data']['small_image']}${data['data']['company_logo']}',
              ),
            ),
          );
        }
        break;

      case '2':
        {
          debugPrint('pushToScreen Sale Order and Sale Order BOM');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => NotificationSaleBomScreen(
                order_id: data['data']['order_id'],
                order_type: data['data']['notify_type'],
                company_code: data['data']['company_code'],
                user_id: userId,
                iconlink:
                    '${data['data']['small_image']}${data['data']['company_logo']}',
              ),
            ),
          );
        }
        break;

      ///  3 Bank payment
      case '3':
        {
          debugPrint('pushToScreen Bank payment');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => BankPayment(
                  companycode: data['data']['company_code'],
                  userid: userId,
                  iconlink:
                      '${data['data']['small_image']}${data['data']['company_logo']}',
                  alertType: 'alert',
                  orderType: data['data']['notify_type'],
                  orderId: data['data']['order_id'],
                  type: PaymentSelection.payment),
            ),
          );
        }
        break;

      /// 4 Bank Receipt
      case '4':
        {
          debugPrint('pushToScreen Bank Receipt');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => BankPayment(
                  companycode: data['data']['company_code'],
                  userid: userId,
                  iconlink:
                      '${data['data']['small_image']}${data['data']['company_logo']}',
                  orderType: data['data']['notify_type'],
                  orderId: data['data']['order_id'],
                  alertType: 'alert',
                  type: PaymentSelection.receipt),
            ),
          );
        }
        break;

      /// 5 Indent Report
      case '5':
        {
          debugPrint('pushToScreen Indent Report');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => IndentReport(
                companycode: data['data']['company_code'],
                userid: userId,
                iconlink:
                    '${data['data']['small_image']}${data['data']['company_logo']}',
                type: 'alert',
                orderType: data['data']['notify_type'],
                orderId: data['data']['order_id'],
              ),
            ),
          );
        }
        break;

      /// 6 Purchase Order
      case '6':
        {
          debugPrint('pushToScreen Indent Report');

          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => PurchaseOrders(
                userid: userId,
                companycode: data['data']['company_code'],
                iconlink:
                    '${data['data']['small_image']}${data['data']['company_logo']}',
                orderType: data['data']['notify_type'],
                orderId: data['data']['order_id'],
                type: 'alert',
              ),
            ),
          );
        }
        break;

      /// 7 Employee Gate Pass
      case '7':
      case '8':
        {
          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => GatePass(
                compId: data['data']['company_code'],
                passType: PassType.Employee,
                isAlertView: true,
              ),
            ),
          );
        }
        break;

      default:
        {
          debugPrint('pushToScreen default ');

          MyApp.navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (_) => MyHomePage(null)));
        }
    }
  }

  static showToast(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.appRed[600],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static clearPref() {
    AppConfig.prefs.remove('user_id');
    AppConfig.prefs.remove('name');
    AppConfig.prefs.remove(Permissions.IndentApprove);
    AppConfig.prefs.remove(Permissions.PurchaseOrderApprove);
    AppConfig.prefs.remove(Permissions.SaleOrderApprove);
  }

  static showSnackBar(BuildContext context,
      GlobalKey<ScaffoldState> _scaffoldKey, String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w300),
      ),
      backgroundColor: AppColor.appRed,
      duration: Duration(seconds: 3),
    ));
  }
}

/// Extension Function
/// Safe Pop , It first checks that if Widget can be Pop or Not, then it pops (To prevent the empty stack)
void popIt(BuildContext context, {dynamic args}) {
  if (Navigator.canPop(context)) Navigator.pop(context, args);
}

String? getToken() {
  return AppConfig.prefs.getString('token');
}

void showAlert(BuildContext context, String msg, String title,
    {VoidCallback? onOk,
    VoidCallback? onNo,
    String ok = 'OK',
    String? notOk,
    Color? okColor,
    Color? notOkColor}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      ElevatedButton(
        child: Text(ok, style: TextStyle(color: okColor ?? Colors.red)),
        onPressed: () {
          Navigator.of(context).pop();
          if (onOk != null) {
            onOk();
          }
        },
      ),
      Visibility(
        visible: notOk != null,
        child: ElevatedButton(
          child: Text(notOk == null ? '' : notOk,
              style: TextStyle(color: notOkColor ?? Colors.red)),
          onPressed: () {
            if (onNo != null) {
              onNo();
            }
          },
        ),
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
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 200),
    barrierLabel: '',
    // ignore: missing_return
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        SizedBox(),
  );
}


/*
void showAlertYesNo(BuildContext context, String msg, String title,
    {VoidCallback onOk, VoidCallback onNo, String ok = 'OK', String notOk,Color okColor,Color notOkColor}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      ElevatedButton(
        child: Text(ok,style: TextStyle(color: okColor?? Colors.red)),
        onPressed: () {
          Navigator.of(context).pop();
          if (onOk != null) {
            onOk();
          }
        },
      ),
      Visibility(
        visible: notOk != null,
        child: ElevatedButton(
          child: Text(notOk == null ? '' : notOk,style: TextStyle(color: notOkColor?? Colors.red)),
          onPressed: () {
            if (onNo != null) {
              onNo();
            }
          },
        ),
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
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 200),
    barrierLabel: '',
    // ignore: missing_return
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {},
  );
}
*/
