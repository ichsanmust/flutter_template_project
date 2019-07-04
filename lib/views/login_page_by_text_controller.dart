import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

// components
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/home_page.dart';
// models
import 'package:flutter_template_project/models/login_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.flashMessage = ''}) : super(key: key);
  final String title;
  final String flashMessage;

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

  DateTime currentBackPressTime;

  // inisiate
  @override
  void initState() {
    super.initState();
    helper.flashMessage(widget.flashMessage);
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
      //print(data);
      if (data != null) {
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
                      new HomePage(title: 'Home', flashMessage: 'Successfully Login',)));
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
      } else {
        message = 'system error (timeout)';
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
                      child: RaisedButton(
                        onPressed: () {
                          _login();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            //Icon(Icons.add),
                            new IconTheme(
                              data: new IconThemeData(color: Colors.white),
                              child: new Icon(Icons.lock),
                            ),
                            Text('Login',
                                style: Style.Default.btnPrimaryText(context)),
                          ],
                        ),
                        color: Style.Default.btnPrimary(),
                      )
//                    child: !isLoading
//                        ? RaisedButton(
//                            onPressed: () {
//                              _login();
//                            },
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                              children: <Widget>[
//                                //Icon(Icons.add),
//                                new IconTheme(
//                                  data: new IconThemeData(color: Colors.white),
//                                  child: new Icon(Icons.launch),
//                                ),
//                                Text('Login',
//                                    style:
//                                        Style.Default.btnPrimaryText(context)),
//                              ],
//                            ),
//                            color: Style.Default.btnPrimary(),
//                          )
//                        : const Center(
//                            child: const CircularProgressIndicator()),
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
    return WillPopScope(
      //onWillPop: () async => false, // disable back button
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // hidde back button
            title: Text(widget.title),
          ),
          body: ModalProgressHUD(
              child: _buildBodyWidget(), inAsyncCall: isLoading)),
    );
//        body: _buildBodyWidget());
  }
}
