import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class FaceCropper {
  FaceCropper({this.orgImage,this.rects});
  final img.Image orgImage;
  final List<Rect> rects;
  
  cropFacesAndSave() async {
    for(int i=0; i<rects.length; i++){      // TODO : make for loop start from last cropped face and save cropped face count
      img.Image croppedImage = img.copyCrop(orgImage, rects[i].topLeft.dx.toInt(),
          rects[i].topLeft.dy.toInt(), rects[i].width.toInt(), rects[i].height.toInt());

      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path;
      print('path is : $path');
      File file = File('$path/face$i.jpg');
      file.writeAsBytesSync(img.encodeJpg(croppedImage));
    }
  }
}