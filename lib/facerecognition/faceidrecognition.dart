import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/facerecognition/passwordlogin.dart';
import 'package:dataproject2/push_notification/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognition extends StatefulWidget {
  final userid, name;
  final Map<String, dynamic>? data;

  const FaceRecognition({Key? key, this.userid, this.name, this.data})
      : super(key: key);

  @override
  _FaceRecognitionState createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  int count = 0;
  var user_id;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  void initState() {
    getuserid();
    super.initState();
  }

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;
    return new Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.center,
                        colors: [
                      Colors.transparent,
                      Color(0xFFFF0000).withOpacity(0.29),
                    ])
                    .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.color,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/background.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user_id == "AMAR" || user_id == "GURPREET"
                    ? new Image(
                        width: 340.0,
                        height: 145.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('images/splashscreen.png'))
                    : new Image(
                        width: 340.0,
                        height: 145.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('images/KGCWideLogo.png')),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: height * 10, left: width * 8, right: width * 8),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color(0xFFFF0000),
                  ),
                  child: MaterialButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          "LOGIN WITH FACE ID",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await _getListOfBiometricTypes();
                          await _authenticateUser();
                        } catch (error) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          // var user_id = prefs.getString('user_id');
                          //var name = prefs.getString('name');
                          var pswd = prefs.getString('password');

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PasswordLogin(
                                userid: widget.userid,
                                name: widget.name,
                                password: pswd,
                                data: widget.data,
                              ),
                            ),
                          );
                          debugPrint('Error While Using Biometrics $error');
                        }

                        //  showInSnackBar("Login button pressed");
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {});
  }

  Future<bool> isBiometricAvailable() async {
    bool isAvailable = false;

    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType>? listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print("prindatalogin" + listOfBiometrics!.length.toString());
    // ...
  }

  // Process of authentication user using
  // biometrics.
  Future<void> _authenticateUser() async {
    // ...
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
          localizedReason:
              "Please authenticate to view your transaction overview",
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ));
    } on PlatformException catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //   var user_id = prefs.getString('user_id');
      //  var name = prefs.getString('name');
      var pswd = prefs.getString('password');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PasswordLogin(
            userid: widget.userid,
            name: widget.name,
            password: pswd,
            data: widget.data,
          ),
        ),
      );
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      NotificationService.isLoggedIn = true;
      if (widget.data == null) {
        debugPrint('data is  Null faceRec ');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Dashboard(
              userid: widget.userid,
              name: widget.name,
            ),
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Dashboard(
                userid: widget.userid,
                name: widget.name,
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        debugPrint('data is NOT Null faceRec ');

        Commons.pushToScreen(widget.data!);
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var pswd = prefs.getString('password');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PasswordLogin(
            userid: widget.userid,
            name: widget.name,
            password: pswd,
            data: widget.data,
          ),
        ),
      );
    }
  }
}
