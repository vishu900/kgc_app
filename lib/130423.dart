import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/Commons.dart' as com;
import 'package:dataproject2/account_master_approval/account_approvalparty.dart';
import 'package:dataproject2/appicon/appiconenum.dart';
import 'package:dataproject2/bomscreen/companyselection2.dart';
import 'package:dataproject2/company_selection.dart';
import 'package:dataproject2/gateEntry/gate_entry_comp_selection.dart';
import 'package:dataproject2/gatePass/CreateGatePass.dart';
import 'package:dataproject2/indent/IndentCompanySelection.dart';
import 'package:dataproject2/itemMaster/ItemMaster.dart';
import 'package:dataproject2/login_page.dart';
import 'package:dataproject2/productionview/CompaniesScreen.dart';
import 'package:dataproject2/purchaseOrder/PurchaseCompanySelection.dart';
import 'package:dataproject2/purchasePacking/pur_packing_comp_selection.dart';
import 'package:dataproject2/quotation/SearchSaleQuotation.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/tracker/Tracker.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mantra_mfs100/mantra_mfs100.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Commons/WebService.dart';
import 'LocationMaster/LocationMaster.dart';
import 'attendance/Attendance.dart';
import 'bankPayment/BankPaymentCompanySelection.dart';
import 'cash_payment/cash_payments_approval_comp_selection.dart';
import 'cash_payment/cash_receipt_approval_comp_selection.dart';
import 'cash_payment/search_payment_company_selection.dart';
import 'cash_payment/search_receipt_company_selection.dart';
import 'datamodel/LocationModel.dart';
import 'full_and_final/full _and _final _comp _selection.dart';
import 'loanentry/loan_entry_comp_selection.dart';
import 'purchaseBillApproval/pur_bill_comp_selection.dart';
import 'gatePass/GatePassCompanySelection.dart';
import 'imageEditor/ImageEditor.dart';
import 'network/NetworkResponse.dart';
import 'network/WebService.dart' as web;
import 'notifications/notificationslist.dart';
import 'salary/employee_advance_comp_selection.dart';
import 'salary/employee_salary_comp_selection.dart';
import 'saleEnquiry/SaleEnquiry.dart';

enum DashBoardPerm {
  BANK_RECEIPT,
  BANK_PAYMENT,
  INDENT_APPROVAL,
  PO_APPROVAL,
  SALE_ORDER_APPROVAL,
  SALE_QTN,
  SO_BOM_APPROVAL
}

class Dashboard extends StatefulWidget {
  final userid, name;

  const Dashboard({Key? key, this.userid, this.name}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with WidgetsBindingObserver, NetworkResponse, MSF100Event {
  int counter = 0;
  int bomcounter = 0;
  int? notificationcounting = 0;
  int? indentCount = 0;
  int? poCount = 0;
  int? bankCount = 0;
  int? trackCount = 0;
  int? visitorPassCount = 0;
  int? empPassCount = 0;
  int? pendingApprovalCount = 0;
  int? gateEntryCount = 0;
  int? purchasePackingCount = 0;
  int? accMasterApprovalCount = 0;
  int? cashPaymentApprovalCount = 0;
  int? cashReceiptApprovalCount = 0;

  var user_id;
  String userImage = '';
  String imageBaseUrl = '';

  bool? isGpsEnabled;
  bool BANK_PAYMENT = false;
  bool INDENT_APPROVAL = false;
  bool PO_APPROVAL = false;
  bool SALE_ORDER_APPROVAL = false;
  bool SALE_QTN = false;
  bool SO_BOM_APPROVAL = false;
  bool TRACKER_APPROVAL = false;
  bool PRODUCTION = false;

  GlobalKey key = GlobalKey();

  String counterApi = "${AppConfig.baseUrl}api/order_counts";
  String notificationcounter = "${AppConfig.baseUrl}api/notification/count";

  List<String?> permList = [];

  double cardRadius = 36;
  double imgHeight = 36;
  double imgWidth = 36;

  bool isSubscribed = false;
  bool isShowing = false;
  bool isFenceAlertShowing = false;
  bool isGPSInitialized = false;
  bool isFactoryAlertShowing = false;
  bool isImprest = false;
  AlertDialog? _alertDialog;
  AlertDialog? fenceAlert;
  AlertDialog? factoryAlert;
  AlertDialog? gpsAlert;
  AlertDialog? gpsPermAlert;
  late Timer _timer;

  StreamSubscription<Position>? positionStream;
  double myLat = 30.8749484;
  double myLong = 75.8975263;
  int? range = 100;
  File? mFile;
  final picker = ImagePicker();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String version = '';
  String buildNumber = '';
  bool _isPlatformSupported = false;
  final sizeH = SizedBox(
    height: 40,
  );

  final sizeb = SizedBox(
    height: 12,
  );

  late MantraMfs100 _mfs;
  static bool isConnected = false;
  static StreamController<dynamic> mfsController =
  StreamController<dynamic>.broadcast();

  void initState() {
    logIt('DashboardInit-> Name:${widget.name}, UserId:${widget.userid}');
    _isPlatformSupported = Platform.isAndroid;
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _addDeviceToken();
      _timer = new Timer.periodic(Duration(seconds: 30), (tmr) {
        getOrderCount();
      });
    });
    WidgetsBinding.instance.addObserver(this);
    getOrderCount();
    getuserid();
    _getVersionInfo();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_isPlatformSupported) {
        _mfs = MantraMfs100(this);
        _mfs.init();
      }
    });
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    logIt('UserId_FromPRef $user_id');
  }

  getnotificationscount() async {
    Map data = {
      'user_id': widget.userid,
//      'password': pass
    };
    dynamic jsonResponse = null;

    var response = await http.post(Uri.parse(notificationcounter), body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      String? errorcheck = jsonResponse['error'];
      int? counting = jsonResponse['notification'];
      //  int? counting2 = jsonResponse['bom_count'];

      if (errorcheck == "false") {
        if (!mounted) return;
        setState(() {
          notificationcounting = counting;
        });
      }

      print('sign in successful');
    } else {
      print('login error');
      print(response.body);
    }
  }

  getOrderCount() async {
    Map data = {
      'user_id': widget.userid,
    };

    var jsonResponse;

    var response = await http.post(Uri.parse(counterApi), body: data);

    if (response.statusCode == 200) {
      _getTrackerCount();

      jsonResponse = json.decode(response.body);

      String? errorCheck = jsonResponse['error'];

      var permCompanies = jsonResponse['fullCompanies'] as List;

      permCompanies.forEach((element) {
        String compCode = getString(element, 'code');
        var permContents = element['permissions'] as List;
        print("permission listdaa" + permContents.toList().toString());
        permContents.forEach((element) {
          print("permission listdaaaaa" + element['tid']);
          savePermission(compCode, element['tid'], element);
        });
      });

      /// Permissions
      if (jsonResponse['order_approval'] != null) {
        var perm = jsonResponse['order_approval'];
        AppConfig.prefs
            .setBool(Permissions.IndentApprove, perm['indent_sale_button']);
        AppConfig.prefs.setBool(
            Permissions.PurchaseOrderApprove, perm['purchase_order_button']);
        AppConfig.prefs
            .setBool(Permissions.SaleOrderApprove, perm['sale_order_button']);
      }

      /// Fetching Counts
      int counting = jsonResponse['count'];
      int counting2 = jsonResponse['bom_count'];
      visitorPassCount = jsonResponse['visitor_pass_count'];
      empPassCount = jsonResponse['employee_pass_count'];
      pendingApprovalCount = jsonResponse['pending_bill_approval_count'];
      indentCount = jsonResponse['indent_count'];
      poCount = jsonResponse['purchase_count'];
      bankCount = jsonResponse['bank_payment_count'];
      notificationcounting = jsonResponse['notification'];
      purchasePackingCount = jsonResponse['pending_purchase_packing_count'];
      gateEntryCount = jsonResponse['pending_gate_entry_count'];
      accMasterApprovalCount = jsonResponse['account_master_approval'];
      cashPaymentApprovalCount = jsonResponse['cash_payment_count'];
      cashReceiptApprovalCount = jsonResponse['cash_receipt_count'];
      range = jsonResponse['distance_radius'];

      isImprest = getString(jsonResponse['user_details'], 'imprest_acc_code')
          .isNotEmpty;

      if (jsonResponse['user_details']['location_check'] != null) {
        AppConfig.prefs.setString(
            'checkLocation', jsonResponse['user_details']['location_check']);

        imageBaseUrl = getString(jsonResponse, 'image_png_path');
        userImage =
            getString(jsonResponse['user_details']['user_images'], 'code_pk');
      } else {
        AppConfig.prefs.setString('checkLocation', 'N');
      }

      if (AppConfig.prefs.getString('checkLocation') == 'Y') {
        if (kReleaseMode) {
          _initGps();
        } else {
          Commons.showToast('Debug: Location is Disabled');
        }
      }
      var loc = jsonResponse['user_factories'] as List;

      AppConfig.locationList.clear();
      AppConfig.locationList
          .addAll(loc.map((e) => LocationModel.fromJSON(e)).toList());

      if (AppConfig.locationList.isEmpty) {
        showNoFactoryAlert(context);
      } else {
        _dismissFactoryAlert();
      }

      AppConfig.prefs.setInt('fcmCount',
          counting + counting2 + indentCount! + poCount! + bankCount!);

      if (errorCheck == "false") {
        var contents = jsonResponse['content'] as List;
        print("hello datateeeee" + jsonResponse['content'].toString());
        permList.clear();

        // permList.add('FANDF'); // todo : remove
        // permList.add('CASH_PAYMENT');
        // permList.add('CASH_PAYMENT_APPROVAL');
        // permList.add('CASH_RECEIPT');
        // permList.add('CASH_RECEIPT_APPROVAL');

        contents.forEach((element) {
          if ("BANK_RECEIPT" != element['tid']) {
            permList.add(element['tid']);
          }
        });

        /*if (!permList.contains('SALARY_PAY_CHECK')) {
          permList.add('SALARY_PAY_CHECK');
        }

        if (!permList.contains('ACC_MST_APPROVAL')) {
          permList.add('ACC_MST_APPROVAL');
        }

       if (!permList.contains('SALARY_ADVANCE_PAID')) {
          permList.add('SALARY_ADVANCE_PAID');
        }*/

        // print('UserDetails' + jsonResponse['user_details']);

        contents.forEach((element) {
          switch (element['tid']) {
            case 'BANK_PAYMENT':
              BANK_PAYMENT = true;
              break;
            case 'INDENT_APPROVAL':
              INDENT_APPROVAL = true;
              break;
            case 'PO_APPROVAL':
              PO_APPROVAL = true;
              break;
            case 'SALE_ORDER_APPROVAL':
              SALE_ORDER_APPROVAL = true;
              break;
            case 'SALE_QTN':
              SALE_QTN = true;
              break;
            case 'SO_BOM_APPROVAL':
              SO_BOM_APPROVAL = true;
              break;

            case 'TRACKER':
              TRACKER_APPROVAL = true;
              break;

            case 'MATERIAL_RECD_4_PROD_ORD':
              PRODUCTION = true;
              break;
          }
        });
        if (!mounted) return;
        setState(() {
          counter = counting;
          bomcounter = counting2;
        });
      }
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                iconSize: 40,
                icon: Icon(
                  Icons.notifications,
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsList(
                            name: widget.name,
                          )));
                },
              ),
              notificationcounting != 0
                  ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black)),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsList(
                                name: widget.name,
                              )));
                    },
                    child: Text(
                      '$notificationcounting',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
                  : new Container()
            ],
          ),
        ],
        title: user_id == "AMAR" || user_id == "GURPREET"
            ? Image(
            width: 125.0,
            height: 50.0,
            fit: BoxFit.fill,
            image: new AssetImage('images/splashscreen.png'))
            : Container(
          height: 56,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white70,
                    Colors.white70,
                    Colors.white.withOpacity(0),
                  ])),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Image.asset(
              'images/KGCWideLogo.png',
              height: 48,
              width: double.infinity,
            ),
          ),
        ),
        centerTitle: false,
      ),
      drawer: Container(
        width: 225,
        color: AppColor.appRed,
        child: Drawer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Stack(children: [
                        userImage.isEmpty
                            ? SvgPicture.asset('images/user.svg',
                            width: 124, height: 124)
                            : Container(
                          width: 128,
                          height: 128,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(62),
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder:
                                'images/loading_placeholder.png',
                                image: '$imageBaseUrl$userImage.png',
                                width: 124,
                                height: 124),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.appRed, width: 1.8),
                            borderRadius: BorderRadius.circular(64),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 5,
                            child: InkWell(
                              onTap: () {
                                popIt(context);
                                _uploadUserPic(context);
                              },
                              child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                      color: AppColor.appRed,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 16)),
                            ))
                      ])

                      /*     user_id == "AMAR" || user_id == "GURPREET"
                          ? new Image(
                              width: 150.0,
                              height: 137.0,
                              fit: BoxFit.fill,
                              image: new AssetImage('images/appstore.png'))
                          : Image.asset(
                              'images/newkg12.png',
                              height: 137,
                              width: 137,
                            ),*/
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 5,
              ),

              /// Sale Quotation
              Visibility(
                visible: SALE_QTN,
                child: ListTile(
                  leading: IconButton(
                    icon: SvgPicture.asset(
                      'images/quotation_form.svg',
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {},
                  ),
                  title: Text('Sale Quotation',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchSaleQuotation()));
                  },
                ),
              ),

              /// Sale Order
              Visibility(
                visible: SALE_ORDER_APPROVAL,
                child: ListTile(
                  leading: Image.asset(
                    'images/saleorder.png',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Sale Order Approval',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    counter != 0
                        ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanySelection(
                              userid: widget.userid,
                              name: widget.name,
                            )))
                        : Commons.showToast('No Sale Order is there!!!');
                  },
                ),
              ),

              /// Sale Order Bom
              Visibility(
                visible: SO_BOM_APPROVAL,
                child: ListTile(
                  leading: Image.asset(
                    'images/bom.png',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Sale Order Bom Approval',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    bomcounter != 0
                        ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanySelection2(
                              userid: widget.userid,
                              name: widget.name,
                            )))
                        : Commons.showToast('No BOM Order is there!!!');
                  },
                ),
              ),

              /// Indent
              Visibility(
                visible: INDENT_APPROVAL,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'images/indent_report.svg',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Indent Approval',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    indentCount != 0
                        ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => IndentCompanySelection(
                          userId: widget.userid,
                          name: widget.name,
                        )))
                        : Commons.showToast('No Indent Report is there!!!');
                    //  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()) );
                    // Navigator.pop(context);
                  },
                ),
              ),

              /// Purchase Order
              Visibility(
                visible: PO_APPROVAL,
                child: ListTile(
                  leading: Image.asset(
                    'images/purchaseorder.png',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Purchase Order Approval',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    poCount != 0
                        ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PurchaseCompanySelection(
                          userId: widget.userid,
                          name: widget.name,
                        )))
                        : Commons.showToast('No Purchase Order is there!!!');
                  },
                ),
              ),

              /// Bank Payment
              Visibility(
                visible: BANK_PAYMENT,
                child: ListTile(
                  leading: Image.asset(
                    'images/bankpayment.png',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Bank Payment',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    bankCount != 0
                        ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BankPaymentCompanySelection(
                          userId: widget.userid,
                          name: widget.name,
                        )))
                        : Commons.showToast('No Bank Payment is there!!!');
                  },
                ),
              ),

              /// Tracker
              Visibility(
                visible: TRACKER_APPROVAL,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'images/tracker.svg',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Tracker',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    trackCount != 0
                        ? Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Tracker()))
                        : Commons.showToast('No Tracker Report is there!!!');
                  },
                ),
              ),

              /*   Visibility(
                visible: PRODUCTION,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'images/tracker.svg',
                    height: 25,
                    width: 25,
                  ),
                  title: Text('Production',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CompaniesScreen()));
                    /*  trackCount != 0
                        ? Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Tracker()))
                        : Commons.showToast('No Tracker Report is there!!!'); */
                  },
                ),
              ), */

              /// Log Out
              ListTile(
                leading: Image.asset(
                  'images/logout.png',
                  height: 25,
                  width: 25,
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  popIt(context);
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
                },
              ),

              /// Version Info
              ListTile(
                title: Text(
                  'Version $version ($buildNumber)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              child: Column(children: <Widget>[
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.center,
                        colors: [
                          Colors.transparent,
                          Color(0xFFFF0000).withOpacity(0.70),
                        ]).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.color,
                  child: GestureDetector(
                    onTap: () {
                      if (!kReleaseMode) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoanEntryCompSelection()),
                        );
                      }
                    },
                    child: Container(
                      height: 100,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/dashboardbackground2.png',
                              ),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 30),
                        child: Text(
                          'Welcome, ' + widget.name,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                /*   InkWell(
                  child: SizedBox(
                      height: 60.0,
                      width: 110.0,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Production',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0),
                          ),
                        ),
                      ))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompaniesScreen()));
                  },
                ), */
                GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 15,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: List.generate(
                        permList.length, (index) => _getWidgets(index))),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _getWidgets(int index) {
    print("hello datat" + permList[index].toString());
    switch (permList[index]) {
      case 'ATTENDANCE':

      /// ATTENDANCE
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Attendance()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/attendance.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Attendance',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

      case 'SALE_ENQ':

      /// Sale Enquiry
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SaleEnquiry()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/enquiry.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Sale Enquiry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

      case 'MATERIAL_RECD_4_PROD_ORD':

      /// Sale Enquiry
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompaniesScreen(userID: widget.userid)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/production.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Production',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

      case 'EMP_GATEPASS':

      /// Gate Pass
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GatePassCompanySelection(
                    type: PassType.Employee,
                  )));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/gate_pass.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    empPassCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$empPassCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Emp Gate Pass',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'VISITOR_GATE_ENTRY':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GatePassCompanySelection(type: PassType.Visitor)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/gate_pass.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    visitorPassCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$visitorPassCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Visitor Gate Pass',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

    //break;

      case 'BANK_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              bankCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BankPaymentCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Bank Payment is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/bankpayment.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    bankCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$bankCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Bank\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'INDENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              indentCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IndentCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Indent Report is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/indent_report.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    indentCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$indentCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Indent\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'PO_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              poCount != 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurchaseCompanySelection(
                    userId: widget.userid,
                    name: widget.name,
                  )))
                  : Commons.showToast('No Purchase Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/purchaseorder.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    poCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$poCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'SALE_ORDER_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              counter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection(
                        userid: widget.userid,
                        name: widget.name,
                      )))
                  : Commons.showToast('No Sale Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/saleorder.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    counter != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale\nOrder Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'SALE_QTN':
        {
          return GestureDetector(
            onTap: () {
              print('bom Clciked');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchSaleQuotation()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/quotation_form.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Sale\nQuotation',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SO_BOM_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              print('bom Clciked');

              bomcounter != 0
                  ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySelection2(
                        userid: widget.userid,
                        name: widget.name,
                      )))
                  : Commons.showToast('No BOM Order is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/bom.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    bomcounter != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$bomcounter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Sale Order\nBom Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

// production part.....
    /* case 'VISITOR_GATE_ENTRY':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GatePassCompanySelection(type: PassType.Visitor)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/gate_pass.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    visitorPassCount != 0
                        ? new Positioned(
                            right: 11,
                            top: 11,
                            child: new Container(
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 10,
                                minHeight: 10,
                              ),
                              child: Text(
                                '$visitorPassCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Productions',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }

        break; */

      case 'TRACKER':
        {
          return GestureDetector(
            onTap: () {
              trackCount != 0
                  ? Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Tracker()))
                  : Commons.showToast('No Tracker Report is there!!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/tracker.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    trackCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$trackCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Tracker',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'LOCATION_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocationMaster()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/location.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Location Master',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'ITEM_MASTER':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ItemMaster()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/item_master.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Item Master',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    // break;

      case 'PUR_BILL_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurBillCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/tracker.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    pendingApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$pendingApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase Bill Approval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'PUR_PACKING_BILL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurPackingCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/shopping-bag.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    purchasePackingCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$purchasePackingCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Purchase Packing',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //   break;

      case 'GATE_ENTRY_BILL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GateEntryCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: SvgPicture.asset(
                          'images/indent_report.svg',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    gateEntryCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$gateEntryCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Gate Entry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SALARY_PAY_CHECK':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpSalaryCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/salary.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    /* gateEntryCount != 0 ? new Positioned(
                          right: 11,
                          top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$gateEntryCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')*/
                  ],
                ),
                sizeb,
                Text('Employee\nSalary Paid',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'SALARY_ADVANCE_PAID':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpAdvanceCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/cashback.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Advance Entry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'ACC_MST_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AccountApprovalParty()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/account_approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    accMasterApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$accMasterApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Account Master\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'FANDF':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullAndFinalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/salary.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Full And Final',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_PAYMENT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CashCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/payment-method.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Payment',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_PAYMENT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashPaymentApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/payment.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashPaymentApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$cashPaymentApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Payment\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_RECEIPT':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashRecCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/receipt.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Cash Receipt',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$cashReceiptApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;

      case 'CASH_RECEIPT_APPROVAL':
        {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashReceiptApprovalCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/receipt approval.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                    cashReceiptApprovalCount != 0
                        ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '$cashReceiptApprovalCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : new Text('')
                  ],
                ),
                sizeb,
                Text('Cash Receipt\nApproval',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          );
        }
    //  break;
      default:
        return Text('INVALID PERM');
    }
  }

  _addDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userid = prefs.getString('user_id');

    var fireToken = prefs.getString('fcmToken');
    var deviceId = prefs.getString('deviceId');

    var json = jsonEncode(<String, dynamic>{
      'user_id': userid,
      'token': fireToken,
      'device_id': deviceId,
    });

    WebService()
        .post(context, AppConfig.addToken, json)
        .then((value) => {logIt('OnAddTokenReResponse ${value!.body}')});
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

    //

    await WebService().post(context, AppConfig.removeToken, json).then(
            (value) => {
          Navigator.pop(context),
          logIt('OnRemoveTokenResponse ${value!.body}')
        });
  }

  _getTrackerCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = prefs.getString('user_id');

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
    });

    WebService()
        .post(context, AppConfig.getTrackerCount, json)
        .then((value) => {_parseTrackerCount(value!)});
  }

  _parseTrackerCount(Response value) {
    if (value.statusCode == 200) {
      var jsonResponse = jsonDecode(value.body);

      if (jsonResponse['error'] == 'false') {
        trackCount = jsonResponse['tracker_count'];
        if (!mounted) return;
        setState(() {});
      }
    }
  }

  @override
  void deactivate() {
    logIt('Screen is DeActivated');
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (AppConfig.prefs.getString('checkLocation') == 'Y') {
      dismissGpsPermAlert();
      dismissGPSAlert();
      if (state == AppLifecycleState.resumed) {
        if (!await Geolocator.isLocationServiceEnabled()) {
          logIt('Ready to boom');
          handleGpsDisable();
        } else {
          if (!await _checkPermission()) {
            Commons.showToast('GPS Permission denied! Please Turn it on.');
          } else {
            getPosition();
          }
        }
      }
    }

    logIt('AppLifeCycleState => $state');
  }

  _initGps() async {
    if (!isGPSInitialized) {
      isGPSInitialized = true;
      logIt('GPS Initializing...');
      if (await _checkPermission()) {
        logIt('GPS Permission Granted Successfully');

        if (await Geolocator.isLocationServiceEnabled()) {
          logIt('isLocationServiceEnabled Successfully');
          getPosition();
        } else {
          logIt('Else Executing');
          try {
            var pos = await Geolocator.getCurrentPosition(
                forceAndroidLocationManager: true,
                desiredAccuracy: LocationAccuracy.best);

            getPosition();
          } on LocationServiceDisabledException {
            logIt('Location is Disabled ');
            try {
              var pos = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.best);

              getPosition();
            } on LocationServiceDisabledException {
              logIt('GPS Enabled Request Denied Second Time!');
              handleGpsDisable();
            }
          } catch (e) {
            logIt('Exception => $e');
          }
        }
      } else {
        Commons.showToast('GPS Permission denied! Please Turn it on.');
      }
    }
  }

  handleGpsDisable() {
    dismissProgressbar();
    showAlertGPS(context, 'Please turn on the GPS', 'GPS Disabled!', ok: 'Exit',
        onOk: () async {
          exit(0);
        });
  }

  void showAlertGPS(BuildContext context, String msg, String title,
      {VoidCallback? onOk, String ok = 'OK'}) {
    dismissGPSAlert();

    gpsAlert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
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
            child: gpsAlert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      // barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  dismissGPSAlert() {
    if (gpsAlert != null) {
      popIt(context);
      gpsAlert = null;
    }
  }

  Future<bool> _checkPermission() async {
    LocationPermission perm = await Geolocator.checkPermission();

    logIt('Gps Permission $perm');

    if (perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse) {
      isGpsEnabled = true;
      return Future.value(isGpsEnabled);
    } else if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      isGpsEnabled = false;
      var result = await Geolocator.requestPermission();

      if (result == LocationPermission.always ||
          result == LocationPermission.whileInUse) {
        isGpsEnabled = true;
        return Future.value(isGpsEnabled);
      } else if (result == LocationPermission.deniedForever) {
        showAlertForever(context);
      } else {
        isGpsEnabled = false;
        showAlert(context);
        return Future.value(isGpsEnabled);
      }
    } else if (perm == LocationPermission.deniedForever) {
      showAlertForever(context);
    }
    return Future.value(isGpsEnabled);
  }

  isInFencing(double currentLat, double currentLong) {
    logIt('NoFactory $factoryAlert $isFactoryAlertShowing');
    if (AppConfig.locationList.isEmpty) {
      showNoFactoryAlert(context);
      return;
    } else {
      bool isOutSide = true;
      _dismissFactoryAlert();

      AppConfig.locationList.forEach((e) {
        logIt('My Lat-> ${e.lat} Long-> ${e.long} radius-> ${e.range} ');

        double distanceInMtr = Geolocator.distanceBetween(
            currentLat, currentLong, e.lat!, e.long!);

        if (distanceInMtr <= e.range!) isOutSide = false;

        logIt('Distance is -> $distanceInMtr');
      });

      if (isOutSide) {
        showFencingAlert(context);
      } else {
        dismissFenceAlert();
      }
    }
  }

  void showAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Permission Not Granted'),
      content: Text('Please grant GPS Permission to use this service'),
      actions: [
        ElevatedButton(
          child: Text("Grant Permission"),
          onPressed: () {
            Navigator.of(context).pop();
            _checkPermission();
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

  void showLocAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('GPS Not Enabled !'),
      content: Text('Please enable the GPS to use this service'),
      actions: [
        ElevatedButton(
          child: Text("Exit"),
          onPressed: () async {
            exit(0);
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

  dismissFenceAlert() {
    logIt(
        'dismissingFenceAlert FenceAlert $fenceAlert isShowing $isFenceAlertShowing');
    if (fenceAlert != null) {
      isFenceAlertShowing = false;
      fenceAlert = null;
      popIt(context);
    }
  }

  void showFencingAlert(BuildContext context) {
    if (fenceAlert != null && isFenceAlertShowing) {
      return;
    }

    fenceAlert = AlertDialog(
      title: Text('Out Of Boundary!'),
      content: Text(
        'You are out of company boundary, app access is denied.',
        textAlign: TextAlign.justify,
      ),
      actions: [
        ElevatedButton(
          child: Text("Exit"),
          onPressed: () {
            exit(0);
          },
        )
      ],
    );

    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        isFenceAlertShowing = true;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: fenceAlert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      // barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  _dismissFactoryAlert() {
    if (factoryAlert != null) {
      popIt(context);
      factoryAlert = null;
    }
  }

  void showNoFactoryAlert(BuildContext context) {
    if (factoryAlert != null) {
      return;
    }

    factoryAlert = AlertDialog(
      title: Text('No Factory Assigned!'),
      content: Text(
        'You do not have any factory assigned. Kindly contact your administrator for the same.',
        textAlign: TextAlign.start,
      ),
      actions: [
        ElevatedButton(
          child: Text("Exit"),
          onPressed: () {
            isFactoryAlertShowing = false;
            _dismissFactoryAlert();
          },
        )
      ],
    );

    showGeneralDialog(
      transitionBuilder: (context, a1, a2, widget) {
        isFactoryAlertShowing = true;
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: factoryAlert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      //barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  dismissGpsPermAlert() {
    if (gpsPermAlert != null) {
      popIt(context);
      gpsPermAlert = null;
    }
  }

  void showAlertForever(BuildContext context) {
    dismissGpsPermAlert();

    gpsPermAlert = AlertDialog(
      title: Text('GPS Permission Not Granted'),
      content: Text(
        'You have denied the GPS permission for forever, so you cannot use this service.\nIn case you want to use this service grant GPS permission manually',
        textAlign: TextAlign.justify,
      ),
      actions: [
        ElevatedButton(
          child: Text("Open Settings"),
          onPressed: () async {
            Geolocator.openLocationSettings();
          },
        ),
        ElevatedButton(
          child: Text("Exit"),
          onPressed: () {
            exit(0);
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
            child: gpsPermAlert,
          ),
        );
      },
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      //barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      // ignore: missing_return
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
          SizedBox(),
    );
  }

  void showLoaderDialog(BuildContext context) {
    if (_alertDialog != null) {
      isShowing = false;
      _alertDialog = null;
      popIt(context);
    }

    _alertDialog = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.appRed)),
          SizedBox(
            width: 15.0,
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("Fetching Location...")),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // isShowing = true;
        return _alertDialog!;
      },
    );
  }

  dismissProgressbar() {
    if (_alertDialog != null) {
      isShowing = false;
      _alertDialog = null;
      popIt(context);
    }
  }

  Future cancelStream() async {
    if (positionStream != null) {
      await positionStream!.cancel();
      logIt('Position Stream Disposed');
    }
  }

  _cancelTimer() {
    if (_timer.isActive) {
      logIt('Timer is active cancelling');
      _timer.cancel();
    }
  }

  _getVersionInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      setState(() {});
    });
  }

  @override
  void onDeviceAttached(bool hasPermission) {
    isConnected = true;
    mfsController.sink.add({'event': 'connected'});
  }

  @override
  void onDeviceDetached() {
    isConnected = false;
    mfsController.sink.add({'event': 'disConnected'});
    _mfs.unInit();
  }

  @override
  void onHostCheckFailed(String var1) {}

  @override
  void dispose() {
    _cancelTimer();
    cancelStream();
    WidgetsBinding.instance.removeObserver(this);
    if (_isPlatformSupported) {
      _mfs.unInit();
      _mfs.dispose();
      mfsController.close();
    }
    super.dispose();
  }

  _uploadUserPic(context) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageEditor(
              title: '',
            )));

    if (res != null) {
      mFile = res['file'];
      if (mFile != null) {
        uploadPic();
      }
    }
  }

  getImage(ImageSource imgSrc) async {
    final pickedFile = await picker.pickImage(source: imgSrc);

    if (pickedFile != null) {
      mFile = File(pickedFile.path);

      if (mFile != null) {
        uploadPic();
      }
    } else {
      logIt('No image selected.');
    }
  }

  uploadPic() {
    Map jsonBody = {'user_id': AppConfig.prefs.getString('user_id')};
    web.WebService.multipartApi(
        AppConfig.uploadUserPic, this, jsonBody, mFile!.absolute.path)
        .callMultipartPostService(context, fileName: 'filename');
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.uploadUserPic:
          {
            var data = jsonDecode(response!);
            if (data['error'] == 'false') {
              com.showAlert(context, getString(data, 'message'), 'Success',
                  onOk: () {
                    getOrderCount();
                  });
            } else {
              com.showAlert(context, getString(data, 'message'), 'Error');
            }
          }
          break;
      }
    } catch (err, stack) {
      logIt('onResponse-> $err $stack');
    }
  }

  getPosition() async {
    try {
      //  logIt('theContext-> currentContext-> ${_scaffoldKey.currentContext}');
      //logIt('theContext-> ${_scaffoldKey.currentState.context}');
      await cancelStream();

      showLoaderDialog(context);
      logIt('getPosition Fired');
      positionStream = Geolocator.getPositionStream(
        // forceAndroidLocationManager: true,
          locationSettings: LocationSettings(
            timeLimit: Duration(seconds: 10),
            accuracy: LocationAccuracy.best,
          )).listen((Position position) {
        dismissProgressbar();
        isInFencing(position.latitude, position.longitude);

        print(position == null
            ? 'Unknown'
            : 'getPositionStream-> Latitude ${position.latitude.toString()}' +
            ', ' +
            'Longitude ${position.longitude.toString()}');

        if (!mounted) return;
        setState(() {});
      }, onError: (err) {
        if (err is AlreadySubscribedException) {
          Commons.showToast('AlreadySubscribedException');
        }
        if (err is LocationServiceDisabledException) {
          handleGpsDisable();
        }
        logIt('An Error Occurred While Listening-> $err ');
      });
    } on LocationServiceDisabledException {
      logIt('GPS Disabled');
      Commons().showAlert(context, 'Please turn on the GPS', 'GPS Disabled!');
    }
  }
}
