import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter_template_project/helper.dart';

import 'package:flutter_template_project/css/style.dart' as Style;
import 'package:flutter_template_project/home_page.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Helper helper = new Helper();

//  Future<bool> get setSessionData => helper.setSession(token);
//  var checkSession ;
//  getSession() async {
//    checkSession = await setSession;
//    print(checkSession);
//  }

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String message = '';
  bool isLoading = false;

  // inisiate
  @override
  void initState() {
    super.initState();
    isLoading = false;
    message = "";
  }

  // action Post login
  Future<List> _login() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    final response = await http.post("https://reqres.in/api/login", body: {
      "email": email.text,
      "password": password.text,
    });
    //print(response.body);
    Map<String, dynamic> user = jsonDecode(response.body);
    //print (jsonDecode(response.body));
    if (response.statusCode == 200) { // jika success login
      var token = user['token'];
      //message = token;
      message = "login success";
      helper.login(token,email.text); // set session
      Navigator.pop(context); // untuk menghide screen saat ini // jika diperlukan
      //Navigator.of(context).pop(); // untuk menghide screen saat ini // jika diperlukan
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new HomePage(title: 'Home')));
      //Navigator.pushReplacementNamed(context, "/home");
    } else {
      message = "${user['error']}";
    }
    setState(() {
      isLoading = false;
    });

    //return _login();
    return null;
  }
  // end action Post login


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // hidde back button
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7, // 70%
                      // child: Container(color: Colors.red),
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 3, // 20%
                      //child: Container(color: Colors.blue),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: !isLoading
                            ? RaisedButton(
                                onPressed: () {
                                  _login();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    //Icon(Icons.add),
                                    new IconTheme(
                                      data: new IconThemeData(
                                          color: Colors.white),
                                      child: new Icon(Icons.launch),
                                    ),
                                    Text('Login',
                                        style: Style.Default.btnPrimaryText(
                                            context)),
                                  ],
                                ),
                                color: Style.Default.btnPrimary(),
                              )
                            : const Center(
                                child: const CircularProgressIndicator()),
                      ),
                    )
                  ],
                )),
            Text(
              message,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ));
  }
}
