import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/home_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPageID';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String url = 'http://jatinparate.pythonanywhere.com/api/login/';

  void validateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      var response = await http.post(url,
          body: {
            'email' : '${email.text}',
            'password' : '${password.text}'
          });
      var data = jsonDecode(response.body);
      if (data['is_logged_in']) {
        await prefs.setBool('is_logged_in',true);
      //  print('Logged In Successfully');
        setState(() {
          isLoading = false;
        });
      //  Navigator.of(context).pushNamedAndRemoveUntil(HomePage.id,(Route<dynamic> route)=>false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>HomePage(loginEmail: email.text,)));
      }else{
        await prefs.setBool('is_logged_in',false);
       // print('Not Logged In');
        showAlertDialog(this.context);
      }
    }catch(e){
      print(e);
    }
  }
  showAlertDialog(context){
    setState(() {
      isLoading = false;
    });
    return showDialog(
        context: context,
      builder: (context){
        return CupertinoAlertDialog(
          title: Row(
            children: <Widget>[
              SizedBox(width: 40,),
              Icon(CupertinoIcons.info),
              SizedBox(width: 5,height: 50,),
              Text('Information'),
            ],
          ),
          content: Text('Username or Password is Invalid.'),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Retry',style: TextStyle(color: Colors.white),),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: AssetImage('images/classroom.jpg'),
              fit: BoxFit.cover,
              color: Colors.black87,
              colorBlendMode: BlendMode.darken,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FlutterLogo(
                    size: 20.0,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'Enter your email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Please enter valid email address.';
                              }else{
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Enter your password',
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Password is required.';
                              }else{
                                return null;
                              }
                            },
                          ),
                          MaterialButton(
                            child: Text('Login'),
                            color: Colors.teal,
                            splashColor: Colors.greenAccent,
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  isLoading = true;
                                });
                                validateUser();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
