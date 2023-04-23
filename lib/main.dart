import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:java_call/views/wifi_info_view.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
  Directory.current = '/storage/emulated/0/Termux';
}

final networkInfo = NetworkInfo();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wifi Info',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WifiInfoViewScreen());
  }
}
