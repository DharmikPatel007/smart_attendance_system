import 'package:flutter/material.dart';
import '../utils/util.dart';

class ResultPage {
  ResultPage(this._classStr,this._branch,this._sem);
  final String _classStr;
  final String _branch;
  final String _sem;
}

class ResultPageState extends StatelessWidget {
  static final String id = 'ResultPageID';
  final Util util = Util();
  @override
  Widget build(BuildContext context) {
    final ResultPage args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Container(
        child: FutureBuilder(
          future: util.recogniseStudents(args._classStr, args._branch, args._sem),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.length > 1){
                if(snapshot.data[0].klass == 'Error'){
                  return Center(
                    child: Text('Something went wrong !'),
                  );
                }else if(snapshot.data[0].klass == 'Not Connected'){
                  return Center(
                    child: Text('No Internet Connection'),
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      return ListTile(
                          title: Text('Enroll No : ${snapshot.data[index].enrollNumber}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Name : ${snapshot.data[index].name}'),
                              Text('isPresent : ${snapshot.data[index].isPresent}'),
                            ],
                          )
                      );
                    },
                  );
                }
              }else{
                return Container(
                  child: Center(
                    child: Text('Face data not available !'),
                  ),
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
