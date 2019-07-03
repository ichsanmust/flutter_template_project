import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

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
      if (data['status'] == true) {
        message = data['message'];
        helper.logout();
        Navigator.pop(
            context); // untuk menghide screen saat ini // jika diperlukan
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new LoginPage(title: 'Login')));
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
      onWillPop: () async => false, // disable back button
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
        body: ModalProgressHUD(child: _buildBodyWidget(), inAsyncCall: isLoading)
      ),
    );
  }
}
