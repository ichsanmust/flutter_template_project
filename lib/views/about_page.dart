import 'package:flutter/material.dart';

// views
import 'package:flutter_template_project/views/home_page.dart';
import 'package:flutter_template_project/views/left_menu.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      drawer: new Drawer(
        child: LeftMenu(),
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
          child: Text('Back to Home'),
        ),
      ),
    );
  }
}