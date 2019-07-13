import 'package:flutter/material.dart';

// components
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/login_page.dart';
import 'package:flutter_template_project/views/home_page.dart';

// check session user
var _isAuthenticated = {};
Helper helper = new Helper();
Future<Map> get checkSessionData => helper.checkSession();
// end check session user

void main() async {
  _isAuthenticated = await checkSessionData;
//  print("isLogin : ${_isAuthenticated}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Project App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _homePageApp(_isAuthenticated, context),
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget _homePageApp(_isAuthenticated, context) {
  if (_isAuthenticated['status'] == true) {
    return HomePage(
      title: 'Home',
    );
  } else {
    if (_isAuthenticated['auth_key'] != '') {
      return LoginPage(
          title: 'Flutter Template Project - Login',
          flashMessage: Helper.getTextSessionOver(),
          typeMessage: Style.Default.btnDanger());
    } else {
      return LoginPage(
        title: 'Login',
      );
    }
  }
}
