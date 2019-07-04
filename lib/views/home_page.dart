import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

// component
import 'package:flutter_template_project/components/helper.dart';
// views
import 'package:flutter_template_project/views/login_page.dart';
import 'package:flutter_template_project/left_menu.dart';
import 'package:flutter_template_project/about_page.dart';

// models
import 'package:flutter_template_project/models/logout_model.dart';

enum ListPopupMenu { logout }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.flashMessage = ''}) : super(key: key);
  final String title;
  final String flashMessage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Helper helper = new Helper();

  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  void getSession() async {
    session = await sessionDataSource;
    setState(() {
      session = session;
    });
  }

  String message = '';
  bool isLoading = false;
  DateTime currentBackPressTime;

  // inisiate
  @override
  void initState() {
    super.initState();
    helper.flashMessage(widget.flashMessage);
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
      if (data['status'] == true) {
        message = data['message'];
        helper.logout();
        Navigator.pop(
            context); // untuk menghide screen saat ini // jika diperlukan
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new LoginPage(title: 'Login', flashMessage: 'Thanks for using the Apps',)));
      } else {
        if (data['code'] == 200) {
          message = data['message'];
        } else {
          message = data['data']['message'];
        }
        //print(message);
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

  // on back button
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Tap 2x to exit Apps",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
          fontSize: 12.0);
      return Future.value(false);
    }
    return Future.value(true);
  }
  // on back button

  Widget _buildBodyWidget() {
    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: () async => false, // disable back button
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            //automaticallyImplyLeading: false, // hide back button
            title: Text(widget.title),
            actions: <Widget>[
              PopupMenuButton<ListPopupMenu>(
                onSelected: (ListPopupMenu result) {
                  if (result == ListPopupMenu.logout) {
                    _logout();
                  } else {
                    //print("not");
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
          drawer: new Drawer(
            child: LeftMenu(),
          ),
          body: ModalProgressHUD(
              child: _buildBodyWidget(), inAsyncCall: isLoading)),
    );
  }
}
