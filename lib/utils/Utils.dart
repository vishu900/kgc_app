import 'dart:io';

import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
export 'package:dataproject2/Permissions/Permissions.dart';
export 'package:dataproject2/appConfig/AppConfig.dart';

logIt(String? msg) {
  if (!kReleaseMode) {
    print(msg);
  }
}

@Deprecated('Use getString(), getInt() instead')
getValue(data, String key) {
  if (data[key] != null) {
    return data[key];
  } else {
    return '';
  }
}

String getString(data, String key) {
  if (data == null) return '';
  if (data[key] != null) {
    return data[key].toString();
  } else {
    return '';
  }
}

String getStringValue(data, String key) {
  if (data == null) return '';
  if (data[key] != null) {
    return data[key].toString();
  } else {
    return '';
  }
}

getJsonObj(data, String key) {
  if (data == null) return {};
  if (data[key] != null) {
    return data[key];
  } else {
    return {};
  }
}

Future<File> createFileFromUint8List(Uint8List memoryBytes) async {
  final tempDir = await getTemporaryDirectory();
  final kFile = await File('${tempDir.path}/temp_signature.png').create();
  if (kFile.existsSync()) {
    kFile.deleteSync();
  }
  kFile.writeAsBytesSync(memoryBytes);
  return Future.value(kFile);
}

String? getName() => AppConfig.prefs.getString('name');

String? getUserId() => AppConfig.prefs.getString('user_id');

String getFormattedDate(String date,
    {String inFormat = 'yyyy-MM-dd hh:mm:ss',
    String outFormat = 'MM-dd-yyyy hh:mm:ss'}) {
  // logIt('inDate-> $date');
  if (date.trim().isEmpty) return date;
  var dt = DateFormat(inFormat).parse(date);
  return DateFormat(outFormat).format(dt);
}

clearFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

cleanCache() async {
  try {
    final tempDir = await getTemporaryDirectory();
    final kFile = File('${tempDir.path}');

    if (kFile.existsSync()) kFile.deleteSync();
  } catch (err) {
    logIt('cleanCache-> $err');
  }
}

showAnimatedDialog(BuildContext context, AlertDialog alert) {
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

extension BoolExtension on bool {
  bool toggle() => !this;
}

extension DateFormatExt on DateTime {
  String format(String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }

  DateTime dateOnly({String format = 'dd MMM yyyy'}) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(this).toDateTime();
  }
}

extension StringExt on String {
  DateTime toDateTime({String format = 'dd MMM yyyy'}) {
    DateFormat _format = DateFormat(format);
    return _format.parse(this);
  }

  handleEmpty({String str = 'N/A'}) {
    if (this.isEmpty || this == 'null')
      return str;
    else
      return this;
  }

  int toInt() {
    try {
      if (this.isNotEmpty) {
        return int.parse(this.trim());
      } else {
        return 0;
      }
    } catch (err, stack) {
      logIt('toInt-> $err, $stack');
      return 0;
    }
  }

  double toDouble() {
    try {
      if (this.isNotEmpty) {
        return double.parse(this);
      } else {
        return 0.0;
      }
    } catch (err, stack) {
      logIt('toInt-> $err, $stack');
      return 0.0;
    }
  }

  String fileExt() {
    return this.split('.')[1];
  }
}

extension DoubleExt on double {
  Widget width() {
    return SizedBox(width: this);
  }

  Widget height() {
    return SizedBox(width: this);
  }
}

extension IntExt on int {
  Widget width() {
    return SizedBox(width: this.toDouble());
  }

  Widget height() {
    return SizedBox(width: this.toDouble());
  }
}

/*extension SharedPrefExt on SharedPreferences{

    clearExcept(List<String> mList){

       var res = AppConfig.prefs.getKeys();

       logIt('AllSharedPrefKeysAre-> $res');

    }

}*/
