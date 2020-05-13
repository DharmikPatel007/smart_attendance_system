import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'attendance_result.dart';
import '../../utils/face_cropper.dart';
import '../../utils/util.dart';
import '../../utils/face_painter.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class AttendancePage extends StatefulWidget {
  static final String id = 'AttendancePageID';
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  Util util = Util();

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

  List<String> _lectures = ['1', '2', '3', '4', '5', '6'];
  String _currentLec = '5';

  Future<void> _getImageAndDetectFaces(ImageSource source) async {
    final pickedImage = await ImagePicker.pickImage(source: source);
    final compressedImage = await FlutterImageCompress.compressWithFile(pickedImage.path,quality: 60);
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    final compressedFile = await File('$path/compressed').writeAsBytes(compressedImage);
    if (compressedFile != null) {
      setState(() {
        isLoading = true;
      });
      final image = FirebaseVisionImage.fromFile(compressedFile);
      final faceDetector = FirebaseVision.instance.faceDetector();
      List<Face> faces = await faceDetector.processImage(image);

      if (mounted) {
        setState(() {
          _imageFile = compressedFile;
          _faces = faces;
          _loadImage(compressedFile);
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

  Widget createDropDown({@required List<String> list,
    @required String initialItem,@required Function onChanged}) {
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
  void deactivate() {
    super.deactivate();
//    if you want to reset the state of application than make _imageFile to null.
//    _imageFile = null;
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progressIndicator,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Take Attendance'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('Select Image from Gallery or Take Photo',style: TextStyle(fontSize: 15)))
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
                                  createDropDown(list: _lectures, initialItem: _currentLec, onChanged: (value){
                                    setState(() {
                                      _currentLec = value;
                                    });
                                  })
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
                                        Navigator.of(context).pushNamed(ResultPage.id,
                                            arguments: Result(_currentClass,_currentBranch,_currentSem,_currentLec)
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
        floatingActionButton: FabCircularMenu(
          key: fabKey,
          ringColor: Colors.black38,
          animationDuration: Duration(milliseconds: 300),
          children: <Widget>[
            IconButton(
              icon:Icon(Icons.camera_alt,semanticLabel: 'Camera',),
              onPressed: (){
                _getImageAndDetectFaces(ImageSource.camera);
                if(fabKey.currentState.isOpen){
                  fabKey.currentState.close();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: (){
                _getImageAndDetectFaces(ImageSource.gallery);
                if(fabKey.currentState.isOpen){
                  fabKey.currentState.close();
                }
              }
            )
          ],
        )
      ),
    );
  }
}
