import 'package:flutter/material.dart';

import 'package:flutter_template_project/helper.dart';

import 'package:flutter_template_project/login_page.dart';
import 'package:flutter_template_project/home_page.dart';

// check session user
bool _isAuthenticated = false;
Helper helper = new Helper();
Future<bool> get checkSessionData => helper.checkSession();
// end check session user

void main() async {
  _isAuthenticated = await checkSessionData;
  //print("isLogin : ${_isAuthenticated}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isAuthenticated
          ? HomePage(title: 'Home')
          : LoginPage(title: 'Login'),
//      routes: {
//         When navigating to the "/" route, build the FirstScreen widget.
//        '/': (context) => LoginPage(),
//         When navigating to the "/second" route, build the SecondScreen widget.
//        '/home': (context) => HomePage(title: 'Home'),
//      },

//      initialRoute: '/',
//      onGenerateRoute: (RouteSettings settings) {
//        switch (settings.name) {
//          case '/':
//            return MaterialPageRoute(builder: (_) {
//              return _isAuthenticated ? AboutPage() : LoginPage(title: 'Login');
//            });
//          case '/login':
//            return MaterialPageRoute(builder: (_) => LoginScreen());
//          case '/browse':
//            return MaterialPageRoute(builder: (_) => BrowseScreen());
//        }
//      },
      debugShowCheckedModeBanner: false,
    );
  }
}
