import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {

  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  Future Function()? resumeCallBack;
  Future Function()? detachedCallBack;


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      if(detachedCallBack!=null)  await detachedCallBack!();
        break;
      case AppLifecycleState.resumed:
        if(resumeCallBack!=null)  await resumeCallBack!();
        break;
    }


  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)


}