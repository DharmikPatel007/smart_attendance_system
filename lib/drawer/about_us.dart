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
        child: Column(
          children: <Widget>[
            PersonDetails(
              name: 'Dharmik Patel',
              about: 'Team Leader',
              direction: TextDirection.ltr,
              description: 'Hello there ! Welcome to Smart Attendance App,'
                  'Frontend UI from Login to Logout of '
                  'this app is created by me Using Dart and Flutter !'
                  'Also created methods for sending required data to server.',
              photoPath: 'images/about/dharmik.jpg',
            ),
            Divider(),
            PersonDetails(
              name: 'Jatin Parate',
              about: 'Team Member',
              direction: TextDirection.rtl,
              description: 'Hi Guys ! Server Side Programming of this App '
                  'is Created by me using Python.Also Designed and '
                  'Developed APIs for the client server Communication.',
              photoPath: 'images/about/jatin.jpg',
            ),
            Divider(),
            PersonDetails(
              name: 'Anant Patel',
              about: 'Team Member',
              direction: TextDirection.ltr,
              description: 'Whoohoo ! Documentation Work of this project is created me ! '
                  'We are using Google\'s FireBase Vision as '
                  'frontend Engine for Better Face Recognisation.',
              photoPath: '',
            ),
            Divider(),
            PersonDetails(
              name: 'Divya Patel',
              about: 'Team Member',
              direction: TextDirection.rtl,
              description: 'Greetings ! Application Icon and Splash Screen is Designed by me ! '
                  'We are using OpenCV as backend Engine for Accurate Face recognisation results.',
              photoPath: '',
            ),
            Divider(),
            Expanded(
              child: Center(
                child: Text(
                    '©copyright GTU Final Year Project® 2020',
                style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}

class PersonDetails extends StatelessWidget {
  final String name;
  final String about;
  final String description;
  final String photoPath;
  final TextDirection direction;

  PersonDetails({@required this.name,@required this.about,
    @required this.description,@required this.photoPath,@required this.direction});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            textDirection: direction,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(photoPath),
                      maxRadius: 45,
                      minRadius: 25,
                    ),
                    Divider(),
                    Text(name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(about,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 10,
              ),
              Expanded(
                flex: 2,
                  child: Text(
                      description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.1,
                      fontSize: 15,
                    ),
                  )
              ),
            ],
          ),
        )
      ],
    );
  }
}
