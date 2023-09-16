import 'package:flutter/cupertino.dart';

class Dx {
  Dx._internal();

  static Dx instance = Dx._internal();

  static BuildContext? context;
  bool initialized = false;
  double? height;
  double? width;

  @Deprecated('in favour of Start')
  void initialize(BuildContext context) {
    if (!initialized) {
      Dx.context = context;
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
    }
  }

  static void s12() {
    assert(
      context != null,
    );
  }
}
