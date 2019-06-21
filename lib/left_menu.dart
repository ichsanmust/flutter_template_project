import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:convert';

import 'package:flutter_template_project/helper.dart';

class LeftMenu extends StatefulWidget {
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  var userid = '';

  void getSession() async {
    session = await sessionDataSource;
    //print(session);
    //print(session['token']);
    setState(() {
      userid = session['userid'];
    });
  }

  // inisiate
  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text(userid),
          accountEmail: new Text('user'),
          currentAccountPicture: new CircleAvatar(
            backgroundImage: new NetworkImage(
                'https://yt3.ggpht.com/-lT_W_kI0_FI/AAAAAAAAAAI/AAAAAAAABFY/-6jXTYtQ-rQ/s88-mo-c-c0xffffffff-rj-k-no/photo.jpg'),
          ),
        ),
        new ListTile(
          title: new Text('About Page'),
          //contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//          onTap: () {
//            Navigator.of(context).pop();
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (BuildContext context) => new AboutPage()));
//          },
        ),
        new Divider(),
        new ListTile(
          //contentPadding: EdgeInsets.all(20.0),
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconTheme(
                data: new IconThemeData(color: Colors.black),
                child: new Icon(Icons.tab),
              ),
              new Text('Tab Layout Page'),
            ],
          ),
          //subtitle: Text('f'),
          //contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//          onTap: () {
//            Navigator.of(context).pop();
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (BuildContext context) => new TabLayoutDemo()));
//          },
        ),
      ],
    );
  }
}
