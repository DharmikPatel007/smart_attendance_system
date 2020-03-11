import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static final String id = 'AboutPageID';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About US'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'This is about page.'
          ),
        ),
      ),
    );
  }
}
