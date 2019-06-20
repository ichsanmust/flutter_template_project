import 'package:flutter/material.dart';

import 'package:flutter_template_project/home_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Page'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            //Navigator.pop(context); // untuk menghide screen saat ini // jika diperlukan
            //Navigator.of(context).pop(); // untuk menghide screen saat ini // jika diperlukan
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new HomePage(title: 'Home')));
          },
          child: Text('to Home'),
        ),
      ),
    );
  }
}