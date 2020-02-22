import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class FaceCropper {
  FaceCropper({this.orgImage,this.rects});
  final img.Image orgImage;
  final List<Rect> rects;
  final List<File> croppedImages = [];
  
  cropFacesAndSave() async {
    for(int i=0; i<rects.length; i++){
      img.Image croppedImage = img.copyCrop(orgImage, rects[i].topLeft.dx.toInt(),
          rects[i].topLeft.dy.toInt(), rects[i].width.toInt(), rects[i].height.toInt());

      //If wonted to save cropped faces in local storage
      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path;
      File file = File('$path/face$i.jpg');
      file.writeAsBytesSync(img.encodeJpg(croppedImage));

    }
    return croppedImages;
  }
}