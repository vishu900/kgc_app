import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MIButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsets padding;
  const MIButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: borderColor),
        ),
        child: CupertinoButton(
          child: child,
          onPressed: onPressed,
          color: backgroundColor,
          padding: padding,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          side: MaterialStateProperty.all(BorderSide(color: borderColor)),
          padding: MaterialStateProperty.all<EdgeInsets>(padding),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: child,
      );
    }
  }
}
