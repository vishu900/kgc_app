import 'dart:async';

import 'package:dataproject2/facerecognition/faceidrecognition.dart';
import 'package:dataproject2/login_page.dart';
import 'package:dataproject2/push_notification/NotificationService.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/LifecycleEventHandler.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'utils/Utils.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppConfig.prefs = await SharedPreferences.getInstance();

  // ignore: invalid_use_of_visible_for_testing_member
  /*runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });*/

  runApp(MyApp());

  WidgetsBinding.instance
      .addObserver(LifecycleEventHandler(detachedCallBack: () async {
    debugPrint("AppController detachedCallBack");

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    /*  if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.updateBadgeCount(
          AppConfig.prefs.getInt('fcmCount') == null
              ? 0
              : AppConfig.prefs.getInt('fcmCount')!);
    } */

    cleanCache();
    debugPrint(
        "AppController detachedCallBack ==> ${AppConfig.prefs.getInt('fcmCount')}");
  }, resumeCallBack: () async {
    debugPrint("AppController resumeCallBack");
  }));

  debugPrint("AppController Init");
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, __, ___) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'BK International',
        theme: ThemeData(
          primarySwatch: AppColor.appRed,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(null),
        // home: FingerPrint(empCode: ''),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
      );
    });
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  Map<String, dynamic>? data_;

  MyHomePage(this.data_);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var user_id;

  @override
  void initState() {
    super.initState();
    NotificationService.instance.start();
    sessioncheck();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
  }

  sessioncheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    var name = prefs.getString('name');
    // var password = prefs.getString('password');

    setState(() {});
    print('Splash_UserId=> $user_id ');

    Timer(
        Duration(seconds: 3),
        () => {
              if (user_id == null)
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                data: widget.data_,
                              )))
                }
              else
                {
                  MyApp.navigatorKey.currentState!
                      .pushReplacement(MaterialPageRoute(
                          builder: (context) => FaceRecognition(
                                userid: user_id,
                                name: name,
                                data: widget.data_,
                              )))

                  /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FaceRecognition(
                                userid: user_id,
                                name: name,
                                data: widget.data_,
                              )))*/
                }
            });
  }

  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;
    print('Splash_UserId=> build ');
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter,

                begin: Alignment.center,
                end: Alignment.center,
                colors: [
                  Colors.transparent,
                  Color(0xFFFF0000).withOpacity(0.29),
                ]).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.color,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
//                    >= 775.0
//                    ? MediaQuery.of(context).size.height
//                    : 775.0,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/background.jpg',
                ),
                fit: BoxFit.cover,
              ),

//                  gradient: new LinearGradient(
//                      colors: [
//                        Theme.Colors.loginGradientStart,
//                        Theme.Colors.loginGradientEnd
//                      ],
//                      begin: const FractionalOffset(0.0, 0.0),
//                      end: const FractionalOffset(1.0, 1.0),
//                      stops: [0.0, 1.0],
//                      tileMode: TileMode.clamp),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              user_id != null
                  ? (user_id == "AMAR" || user_id == "GURPREET"
                      ? new Image(
                          width: 400.0,
                          height: 140.0,
                          fit: BoxFit.fill,
                          image: new AssetImage('images/splashscreen.png'))
                      : Image.asset(
                          'images/KGCWideLogo.png',
                          width: 400,
                          height: 140,
                        ))
                  : Image.asset(
                      'images/splashscreen.png',
                      width: 400,
                      height: 140,
                    ),
            ],
          ),
        )
      ],
    );
  }
}
