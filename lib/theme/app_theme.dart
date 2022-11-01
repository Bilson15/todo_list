import 'package:flutter/material.dart';

final appTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: accentColor),
    fillColor: accentColor,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: accentColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: accentColor),
    ),
    focusColor: accentColor,
  ),
);

//Colors
const accentColor = Color(0xff1C5052);
const accentColorTransparent = Color(0xffe6eff7);
const accentLight = Color(0xffE6E6F4);
const backgroundColor = Color(0xfff5f5f5);
const primaryColor = Color(0xffffffff);
const backDialogColor = Color(0xffD9D9D9);
const orange = Color(0xffff3d00);
const yellow = Color(0xffffbc11);
const gray = Color(0xff36393b);
const graySecundary = Color.fromARGB(255, 163, 163, 163);
