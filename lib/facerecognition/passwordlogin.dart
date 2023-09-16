import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/appicon/appiconenum.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/push_notification/NotificationService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';

class PasswordLogin extends StatefulWidget {
  final userid;
  final name;
  final password;
  final Map<String, dynamic>? data;

  PasswordLogin({Key? key, this.userid, this.name, this.password, this.data})
      : super(key: key);

  @override
  _PasswordLoginState createState() => new _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin>
    with SingleTickerProviderStateMixin {
  var basicurl = "http://103.141.115.18:24976/bkintl/public";
  var loginapiUrl = "${AppConfig.baseUrl}api/login";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController? _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  // ProgressDialog pr;
  var user_id;

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//
//     pr.style(message: 'Logging In...');

    return new Scaffold(
      key: _scaffoldKey,
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
                decoration: new BoxDecoration(
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
                user_id != null
                    ? (user_id == "AMAR" || user_id == "GURPREET"
                        ? new Image(
                            width: 400.0,
                            height: 140.0,
                            fit: BoxFit.fill,
                            image: new AssetImage('images/splashscreen.png'))
                        : Image.asset(
                            'images/KGCWideLogo.png',
                            width: 250,
                            height: 140,
                          ))
                    : Image.asset(
                        'images/splashscreen.png',
                        width: 200,
                        height: 100,
                      ),
                _buildSignIn(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  void initState() {
    getuserid();
    // pr = new ProgressDialog(context);
    /*  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.initState();
    if (widget.data == null) {
      //  Commons.showToast('InPassLogin Data  is Null');
    } else {
      //  Commons.showToast('InPassLogin Data  is Not null');
    }
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

//  String emailValidator(String value) {
////    Pattern pattern =
////        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
////    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value)) {
//      return 'Please Check Username';
//    } else {
//      return null;
//    }
//  }
//
//  String pwdValidator(String value) {
//    if (value.length < 4) {
//      return 'Password must be longer than 4 characters';
//    } else {
//      return null;
//    }
//  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _loginFormKey,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 350.0,
                    height: 320.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text('Log in', style: TextStyle(fontSize: 50)),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
//                            validator: pwdValidator,
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureTextLogin,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            onFieldSubmitted: (value) {
                              _login();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 220.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color(0xFFFF0000),
                  ),
                  child: MaterialButton(
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: _login),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _login() {
    if (_loginFormKey.currentState!.validate()) {
      NotificationService.isLoggedIn = true;

      if (loginPasswordController.text.toLowerCase() ==
          widget.password.toString().toLowerCase()) {
        if (widget.data == null) {
          print('InPassLogin Data  is Null');
          // Commons.showToast('InPassLogin Data  is Null');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Dashboard(userid: widget.userid, name: widget.name)),
              (Route<dynamic> route) => false);
        } else {
          //  Commons.showToast('InPassLogin Data  is Null');
          print('InPassLogin Data ${widget.data}');
          Commons.pushToScreen(widget.data!);
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'LOGIN ALERT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Wrong User Password\n' +
                          "Please Check User Password or Log Out to Login Again"),
                      //Text('please enter the country?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('OKAY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red)),
                    onPressed: () {
                      setState(() {
//                                                                avatarImageFile1 =null;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Log Out',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red)),
                    onPressed: () async {
                      await _removeDeviceToken();
                      Commons.clearPref();
                      IconType appIcon = IconType.BKInternational;
                      AppIcon.setLauncherIcon(appIcon);
                      // FlutterAppBadger.removeBadge();
                      AppConfig.prefs.setInt('fcmCount', 0);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                    data: null,
                                  )));

                      /* SharedPreferences prefs =
                      await SharedPreferences
                          .getInstance();
                      prefs.remove('user_id');
                      prefs.remove('name');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(
                                    data: null,
                                  )));*/

//                                           setState(() async {
////                                                                avatarImageFile1 =null;
//                                             Navigator.of(context).pop();
//
//                                           });
                    },
                  ),
                ],
              );
            });
      }
//                          signIn(loginEmailController.text.toUpperCase(), loginPasswordController.text);
    }
  }

  Future<void> _removeDeviceToken() async {
    Commons().showProgressbar(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString('user_id');
    var fireToken = prefs.getString('fcmToken');
    String? deviceId = prefs.getString('deviceId');

    var json = jsonEncode(<String, dynamic>{
      'user_id': userid,
      'token': fireToken,
      'device_id': deviceId,
    });

    await WebService().post(context, AppConfig.removeToken, json).then(
        (value) => {
              Navigator.pop(context),
              logIt('OnRemoveTokenResponse ${value!.body}')
            });
  }

/*  Future<http.Response> signIn(String name, pass) async {
    print("user name   " + name);
    print("password " + pass);
    print("sign in called");
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': name, 'password': pass};
    dynamic jsonResponse = null;
    print('check1');

    final response = await http.post(Uri.parse(loginapiUrl), body: data);
    print("check2");
    print(data);
    if (response.statusCode == 200) {
      print('succesfull login called');
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String errorcheck = jsonResponse['error'];
      print("errorche" + errorcheck);

      if (errorcheck == "false") {
        print('succesfull login called2');

        String userid = jsonResponse['user']['user_id'];
        String name = jsonResponse['user']['name'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', userid);
        prefs.setString('name', name);

        print('user Id  ');
        print(userid);
        loginPasswordController.clear();
        loginEmailController.clear();

        Fluttertoast.showToast(
            msg: "Sign In Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        //  if (widget.data == null) {
        print('InPassLogin Data  is Null');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    Dashboard(userid: userid, name: name)),
            (Route<dynamic> route) => false);
      } else {
        print('succesfull login called3');

        loginPasswordController.clear();
        loginEmailController.clear();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'LOGIN ALERT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Wrong User Credentials\n' +
                          "Please Check User Credentials"),
                      //Text('please enter the country?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('OKAY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red)),
                    onPressed: () {
                      setState(() {
//                                                                avatarImageFile1 =null;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            });
//        pr.hide();
//        Fluttertoast.showToast(
//            msg: "Wrong User Credentials",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.red,
//            textColor: Colors.white,
//            fontSize: 16.0
//        );
      }

      print('sign in successful');
    } else {
//      setState(() {
//        _isLoading = false;
//      });

      Fluttertoast.showToast(
          msg: "No Connection With Server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('login error');
      print(response.body);
    }

  }*/

  void onSignInButtonPress() {
    _pageController!.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void toggleLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
