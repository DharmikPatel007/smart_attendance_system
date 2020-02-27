import 'package:flutter/material.dart';
import 'package:smart_attendance_system/routes/login_page.dart';
import 'home_page.dart';
import '../utils/util.dart';

class RootPage extends StatefulWidget {
  static String id = 'RootPadeID';
  @override
  _RootPageState createState() => _RootPageState();
}


enum UserStatus {
  isLoggedIn,
  isNotLoggedIn
}


class _RootPageState extends State<RootPage> {

  Util util = Util();
  UserStatus status;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setStatus();
  }

  void setStatus() async{
      util.checkLogin().then((onValue){
        if(onValue){
          setState(() {
            status = UserStatus.isLoggedIn;
            isLoading = false;
          });
        }else{
          setState(() {
            status = UserStatus.isNotLoggedIn;
            isLoading = false;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?CircularProgressIndicator():(status == UserStatus.isLoggedIn)? HomePage() : LoginPage(isLogin: setStatus,);
  }
}
