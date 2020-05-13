import 'package:flutter/material.dart';
import 'package:smart_attendance_system/drawer/manage_students/manage_students.dart';
import '../utils/util.dart';
import 'package:flutter/cupertino.dart';
import '../drawer/about_us.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/root_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../drawer/take_attendance/take_attendance.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Util util = Util();
  bool progressIndicator = false;
  String _loginName = 'name';
  String _loginEmail = 'email';
  List<Widget> imageList = [];

  _signOut() async {
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
  }
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
    for(int i=0; i<6; i++){
      imageList.add(Image.asset('images/carousel/c$i.jpg',
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
      ));
    }
    return ModalProgressHUD(
      inAsyncCall: progressIndicator,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Smart Attendance System'),
        ),
        drawer: Drawer(
          elevation: 5,
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
              trailing: Icon(CupertinoIcons.group_solid),
              onTap: (){
                Navigator.of(context).pushNamed(ManageStudentsPage.id);
                },
            ),
            Divider(),
            ListTile(
                title: Text('About US'),
                trailing: Icon(Icons.format_align_left),
                onTap: (){
                  Navigator.of(context).pushNamed(AboutPage.id);
                }
            ),
            Divider(),
            ListTile(
              title: Text('Sign Out'),
              trailing: Icon(CupertinoIcons.reply_thick_solid),
              onTap: _signOut,
            )
          ]),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  pauseAutoPlayOnTouch: true,
                  height: MediaQuery.of(context).size.height/2,
                ),
                items: imageList,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ReusableCard(cardLabel: 'Take Attendance',iconData: CupertinoIcons.create_solid,routeName: AttendancePage.id,),
                ReusableCard(cardLabel: 'Manage Students',iconData: CupertinoIcons.group_solid,routeName: ManageStudentsPage.id,),
              ],
            ),
          ],
        )
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final IconData iconData;
  final String cardLabel;
  final String routeName;
  final Function onTouch;
  ReusableCard({@required this.iconData,@required this.cardLabel,this.routeName,this.onTouch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.height/5,
        child: Card(
          color: Colors.black38,
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(iconData,size: MediaQuery.of(context).size.width/5,),
              Padding(
                padding: const EdgeInsets.only(bottom: 4,top: 2),
                child: Text(cardLabel,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: routeName != null ? (){
        Navigator.of(context).pushNamed(routeName);
      } : onTouch,
    );
  }
}
