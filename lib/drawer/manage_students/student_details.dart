import 'package:flutter/material.dart';
class StudentDetails {

}
class StudentDetailsPage extends StatelessWidget {
  static final String id = 'StudentDetailsPageID';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
      ),
      body: Center(
        child: Container(
          child: Text('Details Page.'),
        ),
      ),
    );
  }
}
