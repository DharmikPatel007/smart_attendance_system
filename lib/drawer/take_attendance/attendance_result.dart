import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../utils/util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Result {
  Result(this._classStr,this._branch,this._sem,this._lec);
  final String _classStr;
  final String _branch;
  final String _sem;
  final String _lec;
}

class ResultPage extends StatefulWidget {
  static final String id = 'ResultPageID';

  @override
  _ResultPageState createState() => _ResultPageState();
}
//class CustomStudent{
//  final String enrollNumber;
//  final bool isPresent;
//  CustomStudent(this.enrollNumber, this.isPresent);
//
//  Map<String, dynamic> toJson() => {
//    'enrollment_no' : enrollNumber,
//    'is_present' : isPresent
//  };
//}
class _ResultPageState extends State<ResultPage> {
  final Util util = Util();
  List students = [];
  int present = 0;
  int absent = 0;
  bool progressIndicator = false;

  void _updateStatus(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Result args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text('Present : $present'),
            ),
            Expanded(
              child: Text('Absent : $absent'),
            )
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: progressIndicator,
        child: Container(
          child: FutureBuilder(
            future: util.recogniseStudents(args._classStr, args._branch, args._sem).whenComplete((){
              _updateStatus();
            }),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                  if(snapshot.data[0].klass == 'Error'){
                    return Center(
                      child: Text('Something went wrong !'),
                    );
                  }else if(snapshot.data[0].klass == 'Not Connected'){
                    return Center(
                      child: Text('No Internet Connection'),
                    );
                  }else if(snapshot.data[0].klass == 'No Face'){
                    return Center(
                      child: Text('No Face Data Available !'),
                    );
                  }else{
                    return Column(
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              var details = {
                                'enrollment_no' : snapshot.data[index].enrollNumber,
                                'is_present' : snapshot.data[index].isPresent
                              };
                              if(students.length < snapshot.data.length){
                                students.add(details);
                                students[index]['is_present'] ? present++ : absent++;
                              }
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    students[index]['is_present'] = students[index]['is_present'] ? false : true;
                                    students[index]['is_present'] ? present++ : present--;
                                    absent = snapshot.data.length - present;
                                  });
                                },
                                child: Card(
                                  color: students[index]['is_present'] ? Colors.lightGreen : Colors.redAccent,
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 8,
                                          child: Text('E.NO: ${snapshot.data[index].enrollNumber}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(snapshot.data[index].name.toString().toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 16
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(snapshot.data[index].klass),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: MaterialButton(
                                child: Text('Register'),
                                color: Colors.blueAccent,
                                onPressed: (){
                                  setState(() {
                                    progressIndicator = true;
                                  });
                                  util.makeAttendance(args._branch, args._classStr,
                                      args._sem, args._lec, students).then((onValue){
                                        setState(() {
                                          progressIndicator = false;
                                        });
                                    if(onValue == 'true'){
                                      Fluttertoast.showToast(msg: 'Registered Successfully.', toastLength: Toast.LENGTH_LONG);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }else if(onValue == 'false'){
                                      Fluttertoast.showToast(msg: 'Registration Failed !', toastLength: Toast.LENGTH_LONG);
                                    }else if(onValue == 'error'){
                                      Fluttertoast.showToast(msg: 'Error Registering !', toastLength: Toast.LENGTH_LONG);
                                    }else if(onValue == 'noConnection'){
                                      Fluttertoast.showToast(msg: 'No Internet Connection.', toastLength: Toast.LENGTH_LONG);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
