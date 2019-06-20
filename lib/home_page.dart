import 'package:flutter/material.dart';

import 'package:flutter_template_project/helper.dart';

import 'package:flutter_template_project/about_page.dart';
import 'package:flutter_template_project/login_page.dart';

enum ListPopupMenu { logout }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // hidde back button
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<ListPopupMenu>(
            onSelected: (ListPopupMenu result) {
              if (result == ListPopupMenu.logout) {
                //print(result);
                helper.setSession('');
                Navigator.pop(context); // untuk menghide screen saat ini // jika diperlukan
                //Navigator.of(context).pop(); // untuk menghide screen saat ini // jika diperlukan
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new LoginPage(title: 'Login')));
              } else {
                //print("wowo");
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ListPopupMenu>>[
                  const PopupMenuItem<ListPopupMenu>(
                    value: ListPopupMenu.logout,
                    child: Text('Logout'),
                  ),
                ],
          )
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            //Navigator.pop(context); // untuk menghide screen saat ini // jika diperlukan
            //Navigator.of(context).pop(); // untuk menghide screen saat ini // jika diperlukan
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new AboutPage()));
          },
          child: Text('To About Page'),
        ),
      ),
    );
  }
}
