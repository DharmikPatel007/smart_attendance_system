import 'package:flutter/material.dart';
import 'package:smart_attendance_system/drawer/manage_students/manage_students.dart';
import '../utils/util.dart';
import 'package:flutter/cupertino.dart';
import '../drawer/about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/root_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../drawer/take_attendance/take_attendance.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Util util = Util();
  bool progressIndicator = false;
  String _loginName = 'name';
  String _loginEmail = 'email';

  @override
  void initState() {
    super.initState();
    util.getNameAndEmail().then((onValue) {
      setState(() {
        _loginName = onValue[0].toUpperCase();
        _loginEmail = onValue[1];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progressIndicator,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Smart Attendance System'),
        ),
        drawer: Drawer(
          child: ListView(children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_loginName),
              accountEmail: Text(_loginEmail),
              currentAccountPicture: CircleAvatar(
                child: Text(_loginName.substring(0, 1)),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: Text('Take Attendance'),
              trailing: Icon(CupertinoIcons.create_solid),
              onTap: (){
                Navigator.of(context).pushNamed(AttendancePage.id);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Manage Students'),
              trailing: Icon(CupertinoIcons.gear_solid),
              onTap: (){
                Navigator.of(context).pushNamed(ManageStudentsPage.id);
                },
            ),
            Divider(),
            ListTile(
                title: Text('About US'),
                trailing: Icon(CupertinoIcons.group_solid),
                onTap: (){
                  Navigator.of(context).pushNamed(AboutPage.id);
                }
            ),
            Divider(),
            ListTile(
              title: Text('Sign Out'),
              trailing: Icon(CupertinoIcons.reply_thick_solid),
              onTap: () async {
                setState(() {
                  progressIndicator = true;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('is_logged_in', false);
                await Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pushReplacementNamed(RootPage.id);
                });
                setState(() {
                  progressIndicator = false;
                });
              },
            )
          ]),
        ),
<<<<<<< HEAD
        body: Center(
          child: Container(
            child: Text('Welcome To Smart Attendance System !'),
          ),
=======
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('No image selected'))
                : Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            child: SizedBox(
                              width: _image.width.toDouble(),
                              height: _image.height.toDouble(),
                              child: CustomPaint(
                                painter: FacePainter(
                                  _image,
                                  _faces,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  createDropDown(list: _branches, initialItem: _currentBranch, onChanged: (value){
                                    setState(() {
                                      _currentBranch = value;
                                    });
                                  }),
                                  createDropDown(list: _classes, initialItem: _currentClass, onChanged: (value){
                                    setState(() {
                                      _currentClass = value;
                                    });
                                  }),
                                  createDropDown(list: _sems, initialItem: _currentSem, onChanged: (value){
                                    setState(() {
                                      _currentSem = value;
                                    });
                                  }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                    child: RaisedButton(
                                      child: Text('Crop & Upload'),
                                      onPressed: () {
                                        setState(() {
                                          progressIndicator = true;
                                        });
                                        _cropAndUpload();
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      child: Text('Take Attendance'),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getImageAndDetectFaces,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
>>>>>>> master
        ),
      ),
    );
  }
}
