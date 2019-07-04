import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

// component
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
//views
import 'package:flutter_template_project/views/login_page.dart';
import 'package:flutter_template_project/views/about_page.dart';
import 'package:flutter_template_project/views/skeleton.dart';
// models
import 'package:flutter_template_project/models/logout_model.dart';

class LeftMenu extends StatefulWidget {
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  var username = '';
  var imageUser =
      'https://yt3.ggpht.com/-lT_W_kI0_FI/AAAAAAAAAAI/AAAAAAAABFY/-6jXTYtQ-rQ/s88-mo-c-c0xffffffff-rj-k-no/photo.jpg';
  String message = '';
  bool isLoading = false;

  void getSession() async {
    session = await sessionDataSource;
    //print(session);
    //print(session['token']);
    setState(() {
      session = session;
      username = session['userid'];
    });
  }

  // inisiate
  @override
  void initState() {
    super.initState();
    getSession();
  }

  // logout action
  Future<List> _logout() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    await LogoutModel.logout(session['auth_key']).then((data) {
      //print(data);
      if (data != null) {
        if (data['status'] == true) {
          message = data['message'];
          helper.logout();
          Navigator.pop(
              context); // untuk menghide screen saat ini // jika diperlukan
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(
                        title: 'Login',
                        flashMessage: message,
                      )));
        } else {
          if (data['code'] == 200) {
            message = data['message'];
          } else {
            message = data['data']['message'];
          }
          //print(message);
          helper.flashMessage(message, type: Style.Default.btnDanger());
        }
      } else {
        message = 'system error (timeout)';
        helper.flashMessage(message, type: Style.Default.btnDanger());
      }
    });

    setState(() {
      message = message;
      isLoading = false;
    });

    //return _logout();
    return null;
  }
  // logout action

  Widget _buildBodyWidget() {
    return ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text(username),
          accountEmail: new Text('User Application'),
          currentAccountPicture: new CircleAvatar(
            backgroundImage: new NetworkImage(imageUser),
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.info_outline),
          title: new Text(
            'About',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new AboutPage()));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.calendar_today),
          title: new Text(
            'Data',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new Skeleton()));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.exit_to_app),
          title: new Text(
            'Logout',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            this._logout();
          },
        ),
//        new Divider(),
//        new ListTile(
//          //contentPadding: EdgeInsets.all(20.0),
//          title: Row(
//            //mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new IconTheme(
//                data: new IconThemeData(color: Colors.black),
//                child: new Icon(Icons.tab),
//              ),
//              new Text('Tab Layout Page'),
//            ],
//          ),
//          //subtitle: Text('f'),
//          //contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
////          onTap: () {
////            Navigator.of(context).pop();
////            Navigator.push(
////                context,
////                new MaterialPageRoute(
////                    builder: (BuildContext context) => new TabLayoutDemo()));
////          },
//        ),
//        new ListTile(
//          leading: new Icon(Icons.home),
//          title: new Text(
//            'Home',
//            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
//          ),
//          //selected: i == _selectedIndex,
//          //onTap: () => _onSelectItem(i),
//        ),
//        new ListTile(
//          leading: new Icon(Icons.ac_unit),
//          title: new Text(
//            'Skeleton',
//            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
//          ),
//          onTap: () {
//            Navigator.of(context).pop();
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (BuildContext context) => new Skeleton()));
//          },
//        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(child: _buildBodyWidget(), inAsyncCall: isLoading);
  }
}