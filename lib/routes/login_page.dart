import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:connectivity/connectivity.dart';
import '../utils/util.dart';

class LoginPage extends StatefulWidget {
  LoginPage({@required this.isLogin});
  final VoidCallback isLogin;

  static String id = 'LoginPageID';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Util util = Util();
  String _connectionStatus = 'none';
  StreamSubscription<ConnectivityResult> subscription;
  Connectivity connectivity;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  void initState() {
    connectivity = Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _connectionStatus = result.toString();
        print(_connectionStatus);
      } else {
        _connectionStatus = result.toString();
        showAlertDialog(
            context: this.context, text: 'No Internet Connection !');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showAlertDialog({BuildContext context, @required String text}) {
    setState(() {
      isLoading = false;
    });
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Row(
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                Icon(CupertinoIcons.info),
                SizedBox(
                  width: 5,
                  height: 50,
                ),
                Text('Information'),
              ],
            ),
            content: Text(text),
            actions: <Widget>[
              CupertinoButton(
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_connectionStatus == ConnectivityResult.wifi.toString() ||
                      _connectionStatus ==
                          ConnectivityResult.mobile.toString()) {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
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
                  child: Center(
                      child: Text('Login to \nSmart Attendance System'.toUpperCase(),textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22,letterSpacing: 2,color: Colors.teal,
                            fontWeight: FontWeight.w600),
                      )
                  )
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
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@') || !value.contains('.')) {
                                return 'Please enter valid email address.';
                              } else {
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Password is required.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          MaterialButton(                     
                            child: Text('Login'),
                            color: Colors.teal,
                            splashColor: Colors.greenAccent,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                util.validateUser(email.text,password.text).then((onValue){
                                  print('value is : $onValue');
                                  if(onValue == 'true'){
                                    widget.isLogin();
                                  }else if(onValue == 'false'){
                                    showAlertDialog(
                                        context: this.context, text: 'Username or Password is Invalid.'
                                    );
                                  }else if(onValue == 'noConnection'){
                                    showAlertDialog(
                                      context: this.context,text: 'No Internet Connection !'
                                    );
                                  }
                                });
                                setState(() {
                                  isLoading = true;
                                });
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
