import 'package:flutter/material.dart';
import 'package:flutter_template_project/views/student_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

// component
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
//views
import 'package:flutter_template_project/views/login_page.dart';
import 'package:flutter_template_project/views/about_page.dart';
import 'package:flutter_template_project/views/shimmer_page.dart';
import 'package:flutter_template_project/views/infinite_scroll.dart';
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

  Future<Map> get checkSessionData => helper.checkSession();
  var _isAuthenticated = {};

  var username = '';
  var imageUser =
      'https://yt3.ggpht.com/-lT_W_kI0_FI/AAAAAAAAAAI/AAAAAAAABFY/-6jXTYtQ-rQ/s88-mo-c-c0xffffffff-rj-k-no/photo.jpg';
  String message = '';
  bool isLoading = false;

  void getSession() async {
    _isAuthenticated = await checkSessionData;
    if (_isAuthenticated['status'] == false) { // check session, jika sudah habis redirect ke login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  title: 'Login',
                  flashMessage: Helper.getTextSessionOver(),
                  typeMessage: Style.Default.btnDanger(),
                )),
        (Route<dynamic> route) => false,
      );
    }
    session = await sessionDataSource;
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

  void dispose() {
    super.dispose();
  }

  // logout action
  Future<List> _logout() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    await LogoutModel.logout(session['auth_key']).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          message = data['message'];
          helper.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      title: 'Login',
                      flashMessage: message,
                    )),
            (Route<dynamic> route) => false,
          );
        } else {
          if (data['code'] == 200) {
            message = data['message'];
          } else if (data['code'] == 403) {
            // jika gagal token
            message = data['data']['message'];
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                      title: 'Home',
                      flashMessage: message,
                      typeMessage: Style.Default.btnDanger())),
              (Route<dynamic> route) => false,
            );
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
            'Infinite Scroll',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new InfiniteScroll()));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.calendar_today),
          title: new Text(
            'Shimmer',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new ShimmerPage()));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.calendar_today),
          title: new Text(
            'Student Data',
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new StudentPage()));
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
