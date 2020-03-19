import 'package:flutter/material.dart';
import '../../utils/util.dart';

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
  final Util util = Util();

  @override
  Widget build(BuildContext context) {
    StudentDetails _student = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: util.getAvgAttendance(_student.classStr, _student.branch, _student.sem, _student.enrollNumber),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return Text(snapshot.data.toString());
            }else{
              return Text('Loading...');
            }
          },
        )
      ),
      body: Center(
        child: Container(
          child: Text(_student.name.toUpperCase(),style: TextStyle(fontSize: 40,letterSpacing: 1.5),),
        ),
      ),
    );
  }
}
