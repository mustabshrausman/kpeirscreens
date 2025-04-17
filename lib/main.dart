import 'package:flutter/material.dart';
import 'package:projectscreen/firstscreen.dart';
import 'package:projectscreen/loginscreen.dart';
import 'package:projectscreen/home_screen.dart';

void main() {
  // Ensures that Flutter is fully initialized before running the app
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: FirstScreen()));
  //runApp(MaterialApp(debugShowCheckedModeBanner: false, home: homescreen()));
}
