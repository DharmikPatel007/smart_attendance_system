import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

class StudentDetailsPage extends StatefulWidget {
  static final String id = 'StudentDetailsPageID';

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final Util util = Util();
  bool _isLoading = false;
  int present;
  int total;

  @override
  Widget build(BuildContext context) {
    StudentDetails _student = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
            title: Text('Student Details')
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Column(
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
                            size: MediaQuery.of(context).size.width/2.5,
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
                                if(snapshot.hasData){
                                  if(snapshot.data[0] == 'noData' || snapshot.data[0] == 'noConnection' ||
                                      snapshot.data[0] == 'error') {
                                    return Text('Avg.Attendance : NA',
                                      style: TextStyle(fontSize: 28),
                                    );
                                  } else {
                                    present = snapshot.data[1];
                                    total = snapshot.data[2];
                                    return Text('Avg.Attendance : ${snapshot.data[0].toString()} %',
                                      style: TextStyle(fontSize: 28),
                                    );
                                  }
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
                                  Icon(Icons.arrow_downward,
                                  size: MediaQuery.of(context).size.width/23,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('Send Email',style: TextStyle(fontSize: 20),),
                                onPressed: (){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  util.sendEmail(_student.enrollNumber, _student.branch, _student.classStr, total, present)
                                  .then((onValue){
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if(onValue == 'noConnection'){
                                      Fluttertoast.showToast(
                                        msg: 'No Internet Connection.',
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    }else if(onValue == 'true'){
                                      Fluttertoast.showToast(
                                          msg: 'Email Sent Successfully !',
                                         toastLength: Toast.LENGTH_LONG,
                                      );
                                    }else if(onValue == 'error'){
                                      Fluttertoast.showToast(
                                        msg: 'Some Error Occured.',
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    }else if(onValue == 'false'){
                                      Fluttertoast.showToast(
                                        msg: 'No data available.',
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                    }
                                  });
                                },
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
          ),
        )
    );
  }
}
