import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

enum IconType { BKInternational, KG, Normal }

class AppIcon {
  static const MethodChannel platform = MethodChannel('appIconChannel');

  static Future<void> setLauncherIcon(IconType icon) async {
    if (!Platform.isIOS) return null;

    print("icon change called $icon");

    String iconName;

    switch (icon) {
      case IconType.BKInternational:
        iconName = 'BKInternational';

        print("icon change called BKInternational");
        break;
      case IconType.KG:
        iconName = 'KG';

        print("icon change called KG");
        break;
      default:
        iconName = 'Normal';

        print("icon change called Normal");
        break;
    }

    try {
      if (await FlutterDynamicIcon.getAlternateIconName() == iconName) {
        return;
      }

      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        print("Device Supports Alternative icon");
        await FlutterDynamicIcon.setAlternateIconName(iconName);
      } else {
        print("Device NOT Supports Alternative icon");
      }
    } on Exception catch (e) {
      print('Error while changing appicon $e');
    }

    //print("icon change called 4");
    //return await platform.invokeMethod('changeIcon', iconName);
  }
}
