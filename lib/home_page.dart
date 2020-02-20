import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_attendance_system/root_page.dart';
import 'auth.dart';
import 'face_painter.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePageID';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Auth auth = Auth();
  String _loginName = 'name';
  String _loginEmail = 'email';
  bool progressIndicator = false;
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
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
    super.initState();
    auth.getNameAndEmail().then((onValue){
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
                  Navigator.of(context).pushReplacementNamed(RootPage.id);
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
                              painter: FacePainter(_image, _faces, _imageFile),
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          // FacePainter.cropFaces(_imageFile);
                        },
                        child: Text('Crop Faces'),
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