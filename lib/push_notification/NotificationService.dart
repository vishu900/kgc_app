import 'dart:async';
import 'dart:convert';
import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/main.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  /// We want singelton object of ``NotificationService`` so create private constructor
  /// Use NotificationService as ``NotificationService.instance``
  NotificationService._internal();

  BuildContext? context;

  static StreamController<double> controller =
      StreamController<double>.broadcast();

  static bool isLoggedIn = false;

  static final NotificationService instance = NotificationService._internal();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /*  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
 */
  bool? appBadgeSupported;

  /// For local_notification id
  int _count = 0;
  String? user_id;

  /// ``NotificationService`` started or not.
  /// to start ``NotificationService`` call start method
  bool _started = false;

  /// Call this method on startup
  /// This method will initialise notification settings
  void start() async {
    if (!_started) {
      //initPlatformState();
      debugPrint('FCM Started');
      _integrateNotification();
      _refreshToken();
      _started = true;
      _saveDeviceId();
    }
  }

  _saveDeviceId() async {
    try {
      String deviceId =
          await (PlatformDeviceId.getDeviceId as FutureOr<String>);
      AppConfig.prefs.setString('deviceId', deviceId);
    } catch (err) {
      debugPrint('Error while retrieving device id $err');
    }
  }

  /*_initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
  }*/

  void _integrateNotification() {
    _registerNotification();
    _initializeLocalNotification();
  }

  /// initialize firebase_messaging plugin
  void _registerNotification() {
    debugPrint('FCM _registerNotification');

    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          {
            "title": message.notification!.title,
            "body": message.notification!.body,
            "data": message.data,
          },
        );
        _saveToPref(message.data);
      }
    });

    /// Handling Fcm Click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      var msg = await _firebaseMessaging.getInitialMessage();
      if (msg != null) {
        _performActionOnNotification(msg.data);
      } else {
        _performActionOnNotification(message.data);
      }
    });

    /// Handling FCM
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _firebaseMessaging.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);
  }

  /// Token is unique identity of the device.
  /// Token is required when you want to send notification to perticular user.
  void _refreshToken() {
    _firebaseMessaging.getToken().then((token) async {
      print('token: $token');
      _tokenRefresh(token!);
    }, onError: _tokenRefreshFailure);
  }

  /// This method will be called device token get refreshed
  void _tokenRefresh(String newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', newToken);
    print('New Token : $newToken');
  }

  void _tokenRefreshFailure(error) {
    print("FCM token refresh failed with error $error");
  }

/*  /// This method will be called on tap of the notification which came when app was in foreground
  ///
  /// Firebase messaging does not push notification in notification panel when app is in foreground.
  /// To send the notification when app is in foreground we will use flutter_local_notification
  /// to send notification which will behave similar to firebase notification
  Future<void> _onMessage(Map<String, dynamic> message) async {
    print('FCM_onMessage: $message');

    if (Platform.isIOS) {
      message = _modifyNotificationJson(message);
    }

    if (message['data']['notify_type'] != '0') {
      _saveToPref(message);
      _showNotification(
        {
          "title": message['notification']['title'],
          "body": message['notification']['body'],
          "data": message['data'],
        },
      );
    } else {
      // print('controller triggered');
      //   controller.add(0.0);
    }
  }*/

  /// Saving In Preference
  _saveToPref(Map<String, dynamic> data) {
    var count = data['data']['aps']['badge'].toInt();
    // debugPrint('Notification Count is before saving $count');
    AppConfig.prefs.setInt('fcmCount', count);
    //   debugPrint('Notification Count from prefs saving ${AppConfig.prefs.getInt('fcmCount')}');
  }

  /*/// This method will be called on tap of the notification which came when app was closed
  Future<void> _onLaunch(Map<String, dynamic> message) {
    print('onLaunch: $message');
    if (Platform.isIOS) {
      message = _modifyNotificationJson(message);
    }
    _performActionOnNotification(message);
    return null;
  }

  /// This method will be called on tap of the notification which came when app was in background
  Future<void> _onResume(Map<String, dynamic> message) {
    print('onResume: $message');
    if (Platform.isIOS) {
      message = _modifyNotificationJson(message);
    }
    _performActionOnNotification(message);
    return null;
  }*/

  /* /// This method will modify the message format of iOS Notification Data
  Map _modifyNotificationJson(Map<String, dynamic> message) {
    message['data'] = Map.from(message ?? {});
    message['notification'] = message['aps']['alert'];
    return message;
  }*/

  /// We want to perform same action of the click of the notification. So this common method will be called on
  /// tap of any notification (onLaunch / onMessage / onResume)
  void _performActionOnNotification(Map<String, dynamic> message) {
    print('OnNotiTap $message');
    _openIntent(message);
  }

  /// used for sending push notification when app is in foreground
  void _showNotification(message) async {
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    /* var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      ++_count,
      message['title'],
      message['body'],
      platformChannelSpecifics,
      payload: json.encode(
        message['data'],
      ),
    ); */

    // _addBadge(_count);
  }

  /// initialize flutter_local_notification plugin
  void _initializeLocalNotification() {
    // Settings for Android
    // Settings for iOS
    /*   var iosInitializationSettings = new IOSInitializationSettings();
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings),
      onSelectNotification: _onSelectLocalNotification,
    ); */
  }

  /// This method will be called on tap of notification pushed by flutter_local_notification plugin when app is in foreground
  Future? onSelectLocalNotification(String? payLoad) {
    Map? data = json.decode(payLoad!);
    Map<String, dynamic> message = {
      "data": data,
    };
    _performActionOnNotification(message);
    return null;
  }

/*   void _addBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }
 */
  /* initPlatformState() async {
    try {
      appBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
    } on PlatformException {
      print('Failed to get badge support.');
    }
  } */

  void _openIntent(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user_id = prefs.getString('user_id');

    debugPrint('_openIntent $isLoggedIn');

    // ignore: unnecessary_null_comparison
    if (data == null) {
      print('NotificationService ==> NULL');
    } else {
      print('NotificationService ==> NOT null');
    }

    if (isLoggedIn) {
      Commons.pushToScreen(data);
    } else {
      MyApp.navigatorKey.currentState!
          .push(MaterialPageRoute(builder: (_) => MyHomePage(data)));
    }
  }
}

/*Future<void> fcmBackgroundHandler(Map<String, dynamic> message) async {
  logIt('OnBackground-> $message');
}*/

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var data = message.data;
  logIt('OnBackground-> $data');
}
