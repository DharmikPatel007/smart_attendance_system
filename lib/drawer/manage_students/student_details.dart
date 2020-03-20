import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/util.dart';

class StudentDetails {
  final String classStr;
  final String branch;
  final String sem;
  final String enrollNumber;
  final String name;
  final String parentEmail;
  StudentDetails(this.classStr, this.branch, this.sem, this.enrollNumber,
      this.name, this.parentEmail);
}

class StudentDetailsPage extends StatelessWidget {
  static final String id = 'StudentDetailsPageID';
  final Util util = Util();

  @override
  Widget build(BuildContext context) {
    StudentDetails _student = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
            title: Text('Student Details')
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Icon(
                          Icons.account_box,
                          size: 200,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(_student.name.toUpperCase(),
                            style: TextStyle(fontSize: 25,letterSpacing: 1.3),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Branch : ${_student.branch}',
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('E.NO : ${_student.enrollNumber}',
                          style: TextStyle(fontSize: 27),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: FutureBuilder(
                            future: util.getAvgAttendance(_student.classStr, _student.branch,
                                _student.sem, _student.enrollNumber),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Text('Average Attendance : ${snapshot.data.toString()} %',
                                  style: TextStyle(fontSize: 28),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(_student.sem.toUpperCase(),
                                    style: TextStyle(fontSize: 50),
                                  ),
                                  Text('SEMESTER',style: TextStyle(fontSize: 29),)
                                ],
                              )
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(_student.classStr,style: TextStyle(fontSize: 50),),
                                Text('CLASS',style: TextStyle(fontSize: 29),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('To Mail the parent regarding Low Attendance Press Below Button.',
                                style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.arrow_downward)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text('Send Email',style: TextStyle(fontSize: 20),),
                              onPressed: (){},
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        )
    );
  }
}
