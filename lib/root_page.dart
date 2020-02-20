import 'package:flutter/material.dart';
import 'package:smart_attendance_system/login_page.dart';
import 'home_page.dart';
import 'auth.dart';

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

  Auth auth = Auth();
  UserStatus status;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setStatus();
  }

  void setStatus() async{
      auth.checkLogin().then((onValue){
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
