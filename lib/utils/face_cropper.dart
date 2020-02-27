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
  
  Future<List<File>> cropFacesAndSave() async {
    for(int i=0; i<rects.length; i++){
      img.Image croppedImage = img.copyCrop(orgImage, rects[i].topLeft.dx.toInt(),
          rects[i].topLeft.dy.toInt(), rects[i].width.toInt(), rects[i].height.toInt());

      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path;
    //  print('path is : $path');
      File file = File('$path/face$i.jpg');
      croppedImages.add(await file.writeAsBytes(img.encodeJpg(croppedImage)));
    }
    return croppedImages;
  }
}