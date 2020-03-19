import 'package:flutter/material.dart';
import 'package:smart_attendance_system/drawer/manage_students.dart';
import 'package:smart_attendance_system/routes/result_page.dart';
import 'package:smart_attendance_system/routes/root_page.dart';
import 'package:flutter/services.dart';
import 'routes/root_page.dart';
import './drawer/about_us.dart';
import './drawer/take_attendance.dart';

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
        ResultPage.id : (BuildContext context) => ResultPage(),
        AboutPage.id : (BuildContext context) => AboutPage(),
        AttendancePage.id : (BuildContext context) => AttendancePage(),
        ManageStudentsPage.id : (BuildContext context) => ManageStudentsPage(),
      },

    );
  }
}
