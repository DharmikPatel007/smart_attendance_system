import 'package:flutter/material.dart';
import '../utils/util.dart';

class Result {
  Result(this._classStr,this._branch,this._sem);
  final String _classStr;
  final String _branch;
  final String _sem;
}

class ResultPage extends StatelessWidget {
  static final String id = 'ResultPageID';
  final Util util = Util();
  @override
  Widget build(BuildContext context) {
    final Result args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Green: Present  |  Red: Absent'),
      ),
      body: Container(
        child: FutureBuilder(
          future: util.recogniseStudents(args._classStr, args._branch, args._sem),
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
                }else if(snapshot.data[0].klass == 'No Students'){
                  return Center(
                    child: Text('No Students Available !'),
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                        color: snapshot.data[index].isPresent ? Colors.lightGreen : Colors.redAccent,
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
                                child: Text(snapshot.data[index].name,
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
                      );
                    },
                  );
                }
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
