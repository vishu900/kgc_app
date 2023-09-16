/*
import 'dart:async';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class GeoLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeoLocation();
}

class _GeoLocation extends State<GeoLocation> {
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  bool isGpsEnabled;

  //StreamSubscription<Position> positionStream;
  double myLat = 30.8749484;
  double myLong = 75.8975263;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    _initGps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocation'),
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
                    */
/* var pos = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.best);

                    myLat = pos.latitude;
                    myLong = pos.longitude;
                    if (!mounted) return;
                    setState(() {});*//*

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

  _initGps() async {
    if (await _checkPermission()) {
      debugPrint('GPS Permission Granted Successfully');
      Commons.showToast('GPS Permission Granted');
      debugPrint('Location ${await location.serviceEnabled()}');

      if (await location.serviceEnabled()) {
        _getPosition();
      } else {
        debugPrint('Else Executing');
        try {
          var pos = await location.getLocation();

          if (pos != null) {
            _getPosition();
          }
        } catch (e) {
          debugPrint('Location is Disabled  AllExcep => $e');
          Commons.showToast('All Error Turn On GPS');
        }
      }
    }
  }

  Future<bool> _checkPermission() async {
    PermissionStatus perm = await location.hasPermission();

    debugPrint('Gps Permission $perm');

    if (perm == PermissionStatus.granted ||
        perm == PermissionStatus.grantedLimited) {
      isGpsEnabled = true;
      return isGpsEnabled;
    } else if (perm == PermissionStatus.denied ||
        perm == PermissionStatus.deniedForever) {
      isGpsEnabled = false;
      var result = await location.requestPermission();

      if (result == PermissionStatus.granted ||
          result == PermissionStatus.grantedLimited) {
        isGpsEnabled = true;
        return isGpsEnabled;
      } else if (result == PermissionStatus.deniedForever) {
        showAlertForever(context);
      } else {
        isGpsEnabled = false;
        showAlert(context);
        return isGpsEnabled;
      }
    } else if (perm == PermissionStatus.deniedForever) {
      showAlertForever(context);
    }
  }

  _getPosition() {
    debugPrint('getPosition Fired');

    try {
      location.onLocationChanged.listen((position) {
        _getPlacemarks(position.latitude, position.longitude);
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
      })..onError(() {
          logIt('Error Occurred While Location ');
        });

      */
/*positionStream = location.getPositionStream(
              desiredAccuracy: LocationAccuracy.best,
              intervalDuration: Duration(seconds: 5))
          .listen((Position position) {

        _getPlacemarks(position.latitude, position.longitude);
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
      });*//*

    } on PlatformException {
      logIt('on LOCATION PlatformException');
    } catch (err) {
      logIt('on Location Error-> $err');
    }
  }

  _isInFencing(double currentLat, double currentLong) {
    */
/* double distanceInMtr =
        location.distanceBetween(currentLat, currentLong, myLat, myLong);

    distanceController.text = distanceInMtr.toString();*//*

  }

  _getPlacemarks(double lat, double long) async {
    */
/*   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    placemarks.forEach((element) {
      addressController.text =
          ' ${element.name} ${element.street} ${element.subLocality} ${element.locality} ${element.postalCode} ${element.administrativeArea}  ${element.country}';

*//*
 */
/*      debugPrint(
          'Name ${element.name} '
              'Locality ${element.locality} Street ${element.street} '
              ' AdminArea ${element.administrativeArea}'
              ' PostalCode ${element.postalCode} Country ${element.country}');*//*
 */
/*
    });*//*

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
            child: WillPopScope(onWillPop: () {}, child: alert),
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
          Animation<double> secondaryAnimation) {},
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
            child: WillPopScope(onWillPop: () {}, child: alert),
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
          Animation<double> secondaryAnimation) {},
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
            //Geolocator.openAppSettings();
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
            child: WillPopScope(onWillPop: () {}, child: alert),
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
          Animation<double> secondaryAnimation) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
*/
