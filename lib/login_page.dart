import 'dart:convert';

import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/appicon/appiconenum.dart';
import 'package:dataproject2/dashboard.dart';
import 'package:dataproject2/push_notification/NotificationService.dart';
import 'package:dataproject2/utils/textupperformatter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commons/Commons.dart';

class LoginPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  // MyHomePage(this.data);

  LoginPage({Key? key, required this.data}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
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

  var user_id;

  Color left = Colors.black;
  Color right = Colors.white;

  // ProgressDialog pr;

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
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
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter,

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//                      user_id == "AMAR"||user_id =="GURPREET"?                      new Image(
//                      width: 340.0,
//                      height: 145.0,
//                      fit: BoxFit.fill,
//                      image: new AssetImage('images/splashscreen.png')):
                new Image(
                    width: 340.0,
                    height: 145.0,
                    fit: BoxFit.fill,
                    image: new AssetImage('images/splashscreen.png')),

                _buildSignIn(context)
              ],
            ),

//                                Expanded(
//                                  flex: 2,
//                                  child: PageView(
//                                    controller: _pageController,
//                                    onPageChanged: (i) {
//                                      if (i == 0) {
//                                        setState(() {
//                                          right = Colors.white;
//                                          left = Colors.black;
//                                        });
//                                      } else if (i == 1) {
//                                        setState(() {
//                                          right = Colors.black;
//                                          left = Colors.white;
//                                        });
//                                      }
//                                    },
//                                    children: <Widget>[
//                                      new ConstrainedBox(
//                                        constraints: const BoxConstraints.expand(),
//                                        child: _buildSignIn(context),
//                                      ),
//
//                                    ],
//                                  ),
//                                ),
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
    super.initState();
    getuserid();
    // pr = new ProgressDialog(context);
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
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
                    height: 360.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text('Log in', style: TextStyle(fontSize: 50)),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            inputFormatters: [UpperCaseTextFormatter()],
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
//                              icon: Icon(
//                                FontAwesomeIcons.envelope,
//                                color: Colors.black,
//                                size: 22.0,
//                              ),
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
                              hintText: "Username",

                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
//                        Container(
//                          width: 250.0,
//                          height: 1.0,
//                          color: Colors.grey[400],
//                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
//                            validator: pwdValidator,
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
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
                  margin: EdgeInsets.only(top: 270.0),
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
      signIn(loginEmailController.text.toUpperCase(),
          loginPasswordController.text);
    }
  }

  Future signIn(String name, pass) async {
    print("user name   " + name);
    print("password " + pass);
    print("sign in called");
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': name, 'password': pass};
    dynamic jsonResponse = null;
    print('check1');

    final response = await http.post(Uri.parse(loginapiUrl), body: data);
    print("check2");
    debugPrint("login_Response-> ${response.body}");
    print(data);
    if (response.statusCode == 200) {
      print('succesfull login called');
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      String errorcheck = jsonResponse['error'];
      print("errorche" + errorcheck);
//      if(jsonResponse != null) {
////        setState(() {
////          _isLoading = false;
////        });
//        sharedPreferences.setString("token", jsonResponse['token']);
//
//      }
      if (errorcheck == "false") {
        print('succesfull login called2');
//        pr.hide();

        if (jsonResponse['user']['location_check'] != null) {
          AppConfig.prefs.setString(
              'checkLocation', jsonResponse['user']['location_check']);
        } else {
          AppConfig.prefs.setString('checkLocation', 'N');
        }
        String userid = jsonResponse['user']['user_id'];
        String name = jsonResponse['user']['name'];
        //  String? password = jsonResponse['user']['password'];
        String? admin = jsonResponse['user']['admin_tag'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', userid);
        prefs.setString('name', name);
        prefs.setString('password', pass);
        prefs.setBool('isAdmin', admin == 'Y');
        //PRODUCTION
        prefs.setString("user", 'APPDBA');

        print('Logged user Id => $userid  name => $name');
        //  print(userid);
        loginPasswordController.clear();
        loginEmailController.clear();

        Fluttertoast.showToast(
            msg: "Sign In Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        NotificationService.isLoggedIn = true;

        if (userid == "GURPREET") {
          print("GURPREET is called  " + userid);
          IconType appIcon = IconType.BKInternational;
          AppIcon.setLauncherIcon(appIcon);
          if (widget.data == null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Dashboard(userid: userid, name: name)),
                (Route<dynamic> route) => false);
          } else {
            Commons.pushToScreen(widget.data!);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             NotificationSaleBomScreen(
            //               order_id: widget.data['order_id'],
            //               order_type: widget.data['notify_type'],
            //               company_code: widget.data['company_code'],
            //               user_id: user_id,
            //               iconlink: '',
            //             )),
            //     (Route<dynamic> route) => false);
          }
        } else if (userid == "AMAR") {
          print("AMAR is called  " + userid);
          IconType appIcon = IconType.BKInternational;
          AppIcon.setLauncherIcon(appIcon);
          if (widget.data == null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Dashboard(userid: userid, name: name)),
                (Route<dynamic> route) => false);
          } else {
            Commons.pushToScreen(widget.data!);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             NotificationSaleBomScreen(
            //               order_id: widget.data['order_id'],
            //               order_type: widget.data['notify_type'],
            //               company_code: widget.data['company_code'],
            //               user_id: user_id,
            //               iconlink: '',
            //             )),
            //     (Route<dynamic> route) => false);
          }
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) =>
          //             Dashboard(userid: userid, name: name)),
          //     (Route<dynamic> route) => false);
        } else {
          print("jass is called  " + userid);
          IconType appIcon = IconType.KG;
//          AppIcon.setLauncherIcon(appIcon);
          AppIcon.setLauncherIcon(appIcon);

          if (widget.data == null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Dashboard(userid: userid, name: name)),
                (Route<dynamic> route) => false);
          } else {
            Commons.pushToScreen(widget.data!);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => NotificationSaleBomScreen(
            //         order_id: widget.data['data']['order_id'],
            //         order_type: widget.data['data']['notify_type'],
            //         company_code: widget.data['data']['company_code'],
            //         user_id: user_id,
            //         iconlink:
            //             '${widget.data['data']['small_image']}${widget.data['data']['company_logo']}',
            //       ),
            //     ),
            //     (Route<dynamic> route) => false);
          }

          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) =>
          //             Dashboard(userid: userid, name: name)),
          //     (Route<dynamic> route) => false);
        }
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
                            color: Colors.white)),
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
  }

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
