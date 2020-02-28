import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_attendance_system/routes/root_page.dart';
import '../utils/util.dart';
import '../utils/face_painter.dart';
import 'package:image/image.dart' as img;
import '../utils/face_cropper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  static final String id = 'HomePageID';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Util util = Util();
  String _loginName = 'name';
  String _loginEmail = 'email';
  bool progressIndicator = false;
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  List<String> _branches = ['CE', 'IT', 'ME', 'EE'];
  String _currentBranch = 'CE';

  List<String> _classes = ['A', 'B', 'C', 'D', 'E', 'F'];
  String _currentClass = 'E';

  List<String> _sems = ['sem-1', 'sem-2', 'sem-3', 'sem-4', 'sem-5', 'sem-6', 'sem-7', 'sem-8'];
  String _currentSem = 'sem-8';

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

  _cropAndUpload() {
    final img.Image image = img.decodeImage(_imageFile.readAsBytesSync());
    final List<Rect> rects = [];
    for (int i = 0; i < _faces.length; i++) {
      rects.add(_faces[i].boundingBox);
    }
    FaceCropper(orgImage: image, rects: rects)
        .cropFacesAndSave()
        .then((onValue) {
      util.uploadImages(onValue, _currentBranch, _currentClass).then((data) {
        setState(() {
          progressIndicator = false;
        });
        print('Result of upload images : $data');
        if (data == 'true') {
          Fluttertoast.showToast(
            msg: 'Faces Uploaded Successfully',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (data == 'noConnection') {
          Fluttertoast.showToast(
            msg: 'No Internet Connection !',
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Some Error Occured !',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      });
    });
  }

  Widget createDropDown({@required List<String> list,@required String initialItem,@required Function onChanged}) {
    return DropdownButton<String>(
      items: list.map((curItem){
        return DropdownMenuItem<String>(
          value: curItem,
          child: Text(curItem),
        );
      }).toList(),
      value: initialItem,
      onChanged: onChanged,
    );
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
  void deactivate() {
    super.deactivate();
//    _imageFile = null;
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
                                      print(value);
                                    });
                                  }),
                                  createDropDown(list: _classes, initialItem: _currentClass, onChanged: (value){
                                    setState(() {
                                      _currentClass = value;
                                      print(value);
                                    });
                                  }),
                                  createDropDown(list: _sems, initialItem: _currentSem, onChanged: (value){
                                    setState(() {
                                      _currentSem = value;
                                      print(value);
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
                                        Navigator.of(context).pushNamed(ResultPageState.id,
                                            arguments: ResultPage(_currentClass,_currentBranch,_currentSem)
                                        );
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
        ),
      ),
    );
  }
}
