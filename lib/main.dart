import 'package:flutter/material.dart';
import 'package:smart_attendance_system/root_page.dart';
import 'package:flutter/services.dart';
import 'root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: RootPage.id,
      routes: {
        RootPage.id : (BuildContext context) => RootPage(),
      },
    );
  }
}
