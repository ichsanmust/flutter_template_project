import 'package:flutter/material.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';

// components
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/home_page.dart';
// models
import 'package:flutter_template_project/models/login_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Helper helper = new Helper();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String message = '';
  bool isLoading = false;

  String deviceId = '';
  Future<String> get deviceIdData => helper.getDeviceId();
  void getDevice() async {
    deviceId = await deviceIdData;
    setState(() {
      deviceId = deviceId;
    });
  }

  String applicationId = '';
  Future<String> get applicationIdData => helper.getApplicationId();
  void getApplication() async {
    applicationId = await applicationIdData;
    setState(() {
      applicationId = applicationId;
    });
  }

  // inisiate
  @override
  void initState() {
    super.initState();
    isLoading = false;
    message = "";
    getDevice();
    getApplication();
  }

  // action Post login
  Future<List> _login() async {
    setState(() {
      isLoading = true;
      message = "";
    });

    await LoginModel.login(
            username.text, password.text, deviceId, applicationId)
        .then((data) {
      if (data['status'] == true) {
        var token = data['data']['auth_key'];
        helper.login(token, username.text); // set session
        message = data['message'];
        Navigator.pop(
            context); // untuk menghide screen saat ini // jika diperlukan
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new HomePage(title: 'Home')));
      } else {
        if (data['code'] == 200) {
          //print(data['message']);
          //message = data['message'] + '\n';
          var messagesError = LoginModel.errorMessage(data['data']);
          message += messagesError;
        } else {
          message = data['data']['message'];
        }
      }
    });

    setState(() {
      message = message;
      isLoading = false;
    });

    //return _login();
    return null;
  }
  // end action Post login

  Widget _buildBodyWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: username,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //Icon(Icons.add),
                                new IconTheme(
                                  data: new IconThemeData(color: Colors.white),
                                  child: new Icon(Icons.launch),
                                ),
                                Text('Login',
                                    style:
                                        Style.Default.btnPrimaryText(context)),
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
        Text(message,
            style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // hidde back button
          title: Text(widget.title),
        ),
//        body: ModalProgressHUD(
//            child: _buildBodyWidget(), inAsyncCall: isLoading));
        body: _buildBodyWidget());
  }
}
