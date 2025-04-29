import 'package:flutter/material.dart';
import 'package:projectscreen/firstscreen.dart';
import 'package:projectscreen/loginscreen.dart';
import 'package:projectscreen/home_screen.dart';
import 'package:projectscreen/ILR_temprature.dart';
import 'package:get/get.dart';
import 'getxwork/registrationgetx.dart';

void main() {
  // Ensures that Flutter is fully initialized before running the app
  //runApp(MaterialApp(debugShowCheckedModeBanner: false, home: FirstScreen()));
  //runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ilrtemp()));
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Registrationn())); // to call the getx class in getwork folder

  //runApp(MaterialApp(debugShowCheckedModeBanner: false, home: homescreen()));
}
