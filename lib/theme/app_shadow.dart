import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  static List<BoxShadow> light = [
    BoxShadow(
      color: Colors.black.withOpacity(.06),
      blurRadius: 25,
      offset: const Offset(0, 10),
    )
  ];

  static List<BoxShadow> dark = [
    BoxShadow(
      color: Colors.black.withOpacity(.35),
      blurRadius: 30,
      offset: const Offset(0, 10),
    )
  ];
}