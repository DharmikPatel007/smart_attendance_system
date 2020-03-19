import 'package:flutter/material.dart';
class StudentDetails {
  final String classStr;
  final String branch;
  final String sem;
  final String enrollNumber;
  final String name;
  final String parentEmail;
  StudentDetails(this.classStr,this.branch,this.sem,this.enrollNumber,this.name,this.parentEmail);
}
class StudentDetailsPage extends StatelessWidget {
  static final String id = 'StudentDetailsPageID';
  @override
  Widget build(BuildContext context) {
    StudentDetails student = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(student.enrollNumber),
      ),
      body: Center(
        child: Container(
          child: Text(student.name.toUpperCase(),style: TextStyle(fontSize: 40,letterSpacing: 1.5),),
        ),
      ),
    );
  }
}
