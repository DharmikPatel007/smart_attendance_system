import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_attendance_system/login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image/image.dart' as Images;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePageID';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _loginName = 'name';
  String _loginEmail = 'email';
  bool progressIndicator = false;
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      final image = FirebaseVisionImage.fromFile(imageFile);
      final faceDetector = FirebaseVision.instance.faceDetector();
      List<Face> faces = await faceDetector.processImage(image);

      if (mounted) {
        setState(() {
          _imageFile = imageFile;
          _faces = faces;
          _loadImage(imageFile);
        });
      }
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('prefs is : ${prefs.getBool('is_logged_in')}');
    try {
      if (!prefs.getBool('is_logged_in')) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginPage.id, (Route<dynamic> route) => false);
      }
      setState(() {
        _loginName = prefs.getString('login_name');
        _loginEmail = prefs.getString('login_email');
      });
    } catch (e) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          LoginPage.id, (Route<dynamic> route) => false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progressIndicator,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Images'),
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
              title: Text('About US'),
              trailing: Icon(CupertinoIcons.group_solid),
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.id, (Route<dynamic> route) => false);
                });
                setState(() {
                  progressIndicator = false;
                });
              },
            )
          ]),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('No image selected'))
                : Column(
                    children: <Widget>[
                      Center(
                        child: FittedBox(
                          child: SizedBox(
                            width: _image.width.toDouble(),
                            height: _image.height.toDouble(),
                            child: CustomPaint(
                              painter: FacePainter(_image, _faces),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          FacePainter.cropImages(_imageFile);
                        },
                        child: Text('Crop Images'),
                      )
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getImageAndDetectFaces,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  static final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  static cropImages(File img) async {
    Future<Directory> path = getApplicationDocumentsDirectory();
    Images.Image image = Images.decodeImage(img.readAsBytesSync());
    for (int i = 0; i < rects.length; i++) {
      Images.Image result = Images.copyCrop(
          image,
          rects[i].topLeft.dx.toInt(),
          rects[i].topLeft.dy.toInt(),
          rects[i].width.toInt(),
          rects[i].height.toInt());
      try {
        File('$path/face$i.jpg').writeAsBytesSync(Images.encodeJpg(result));
      } catch (e) {
        print(e);
      }
    }
    print('Cropping Successfull.');
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
