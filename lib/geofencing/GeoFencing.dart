import 'dart:async';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoFencing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeoFencing();
}

class _GeoFencing extends State<GeoFencing> {
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  bool? isGpsEnabled;
  StreamSubscription<Position>? positionStream;
  double myLat = 30.8749484;
  double myLong = 75.8975263;

  @override
  void initState() {
    super.initState();
    initGps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoFencing'),
        backgroundColor: AppColor.appRed,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                  icon: Icon(Icons.gps_fixed),
                  onPressed: () async {
                    var pos = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.best);

                    myLat = pos.latitude;
                    myLong = pos.longitude;
                    if (!mounted) return;
                    setState(() {});
                  }),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'My Latitude: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  myLat.toString(),
                  style: TextStyle(fontSize: 24),
                )
              ]),
              SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'My Longitude: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  myLong.toString(),
                  style: TextStyle(fontSize: 24),
                )
              ]),
              SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Latitude: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  latController.text,
                  style: TextStyle(fontSize: 24),
                )
              ]),
              SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Longitude: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  longController.text,
                  style: TextStyle(fontSize: 24),
                )
              ]),
              SizedBox(
                height: 30,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Address: ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Flexible(
                      child: Text(
                        addressController.text,
                        softWrap: true,
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ]),
              SizedBox(
                height: 30,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Distance: ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Flexible(
                      child: Text(
                        distanceController.text,
                        softWrap: true,
                        style: TextStyle(fontSize: 24, color: AppColor.appRed),
                      ),
                    )
                  ])
            ],
          )
        ],
      ),
    );
  }

  initGps() async {
    if (await checkPermission()) {
      //logIt('GPS Permission Granted Successfully');

      if (await Geolocator.isLocationServiceEnabled()) {
        getPosition();
      } else {
        debugPrint('Else Executing');
        try {
          getPosition();
        } on LocationServiceDisabledException {
          debugPrint('Location is Disabled ');
          //Commons.showToast('Turn on your GPS');
          try {
            getPosition();
          } on LocationServiceDisabledException {
            //logIt('GPS Enabled Request Denied Second Time!');
            Commons()
                .showAlert(context, 'Please turn on the GPS', 'GPS Disabled!',
                    onOk: () async {
              popIt(context);
              Geolocator.openLocationSettings();
            }, ok: 'Open Settings');
          } catch (err) {
            //logIt('Exception on Exception -> $err');
          }
        } catch (e) {
          debugPrint('Location is Disabled  AllExcep => $e');
          Commons.showToast('All Error Turn On GPS');
        }
      }
    } else {
      Commons.showToast('GPS Permission denied! Please Turn it on.');
    }
  }

  Future<bool> checkPermission() async {
    LocationPermission perm = await Geolocator.checkPermission();

    debugPrint('Gps Permission $perm');

    if (perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse) {
      isGpsEnabled = true;
      return isGpsEnabled!;
    } else if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      isGpsEnabled = false;
      var result = await Geolocator.requestPermission();

      if (result == LocationPermission.always ||
          result == LocationPermission.whileInUse) {
        isGpsEnabled = true;
        return isGpsEnabled!;
      } else if (result == LocationPermission.deniedForever) {
        showAlertForever(context);
        return false;
      } else {
        isGpsEnabled = false;
        showAlert(context);
        return isGpsEnabled!;
      }
    } else if (perm == LocationPermission.deniedForever) {
      showAlertForever(context);
      return false;
    } else {
      return false;
    }
  }

  getPosition() {
    debugPrint('getPosition Fired');

    try {
      positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 5)),
      ).listen((Position position) {
        getPlacemarks(position.latitude, position.longitude);
        _isInFencing(position.latitude, position.longitude);

        latController.text = position.latitude.toString();
        longController.text = position.longitude.toString();

        print(position == null
            ? 'Unknown'
            : 'Latitude ${position.latitude.toString()}' +
                ', ' +
                'Longitude ${position.longitude.toString()}');

        if (!mounted) return;
        setState(() {});
      }, onError: (err) {
        if (err is LocationServiceDisabledException) {
          Commons()
              .showAlert(context, 'Please turn on the GPS ', 'GPS Disabled!',
                  onOk: () async {
            popIt(context);
            Geolocator.openLocationSettings();
          }, ok: 'Open Settings');
        }
        // logIt('An Error Occurred While Listening-> $err ');
      });
    } on LocationServiceDisabledException {
      debugPrint('GPS Disabled');
      Commons().showAlert(context, 'Please turn on the GPS', 'GPS Disabled!');
    }
  }

  _isInFencing(double currentLat, double currentLong) {
    double distanceInMtr =
        Geolocator.distanceBetween(currentLat, currentLong, myLat, myLong);

    distanceController.text = distanceInMtr.toString();
  }

  getPlacemarks(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    placemarks.forEach((element) {
      addressController.text =
          ' ${element.name} ${element.street} ${element.subLocality} ${element.locality} ${element.postalCode} ${element.administrativeArea}  ${element.country}';

      debugPrint('Name ${element.name} '
          'Locality ${element.locality} Street ${element.street} '
          ' AdminArea ${element.administrativeArea}'
          ' PostalCode ${element.postalCode} Country ${element.country}');
    });
  }

  void showAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Permission Not Granted'),
      content: Text('Please grant GPS Permission to use this service'),
      actions: [
        ElevatedButton(
          child: Text("Grant Permission"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            checkPermission();
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
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
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

  void showAlertForever(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('GPS Permission Not Granted'),
      content: Text(
        'You have denied the GPS permission for forever, so you cannot use this service.\nIn case you want to use this service grant GPS permission manually',
        textAlign: TextAlign.justify,
      ),
      actions: [
        ElevatedButton(
          child: Text("Open Settings"),
          onPressed: () {
            //  Geolocator.openLocationSettings();
          },
        ),
        ElevatedButton(
          child: Text("Exit"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
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

  @override
  void dispose() {
    /* ß */
    super.dispose();
  }
}
