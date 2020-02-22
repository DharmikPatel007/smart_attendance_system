import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

class Auth {

  Connectivity connectivity;
  SharedPreferences prefs;
  final String loginUrl = 'http://jatinparate.pythonanywhere.com/api/login/';
  final String uploadUrl = 'http://jatinparate.pythonanywhere.com/api/upload/';

  Future<String> uploadImages(List<img.Image> image) async {
    connectivity = Connectivity();
    Future<ConnectivityResult> futureStatus = connectivity.checkConnectivity();
    ConnectivityResult status = await futureStatus;
    if(status == ConnectivityResult.mobile ||
        status == ConnectivityResult.wifi){
      try{
        var response = await http.post(uploadUrl,
            body: {'property_id': '1', 'branch': 'CE' , 'class_str': 'E' , 'image': image});
        var data = jsonDecode(response.body);
        if(data['is_uploaded']){
          return 'true';
        }else{
          return 'false';
        }
      }catch(e){
        print(e);
        return 'error';
      }
    }else{
      return 'noConnection';
    }
  }
  Future<String> validateUser(String email,String password) async {
    connectivity = Connectivity();
    Future<ConnectivityResult> futureStatus = connectivity.checkConnectivity();
    ConnectivityResult status = await futureStatus;
    print('Internet Status is : $status');
    if (status == ConnectivityResult.mobile ||
        status == ConnectivityResult.wifi) {
      try {
        var response = await http.post(loginUrl,
            body: {'email': '$email', 'password': '$password'});
        var data = jsonDecode(response.body);
        if (data['is_logged_in']) {
          _setPrefrences(true, data);
          return 'true';
        } else {
          _setPrefrences(false, data);
          return 'false';
        }
      } catch (e) {
        print(e);
        return 'error';
      }
    } else {
      return 'noConnection';
    }
  }
  _setPrefrences(value,data) async {
    prefs = await SharedPreferences.getInstance();
    if(value){
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('login_name', data['name']);
      await prefs.setString('login_email', data['email']);
    }else{
      await prefs.setBool('is_logged_in', false);
    }
  }
  Future<bool> checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('is_logged_in')){
      return prefs.getBool('is_logged_in');
    }else{
      prefs.setBool('is_logged_in', false);
      return false;
    }
  }
  Future<List<String>> getNameAndEmail() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('login_name') && prefs.containsKey('login_email')){
      return [prefs.getString('login_name'),prefs.getString('login_email')];
    }else{
      return ['UserName','UserEmail'];
    }
  }
}