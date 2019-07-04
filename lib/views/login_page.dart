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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final Helper helper = new Helper();
  LoginModel model = new LoginModel();
  String message = '';
  bool isLoading = false;
  DateTime currentBackPressTime;

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
    helper.flashMessage(widget.flashMessage);
    isLoading = false;
    message = "";
    getDevice();
    getApplication();
  }

//  void submit() {
//    // First validate form.
//    if (this._formKey.currentState.validate()) {
//      _formKey.currentState.save(); // Save our form now.
//
//      print('Printing the login data.');
//      print('Email: ${model.username}');
//      print('Password: ${model.password}');
//    }
//  }

  // action Post login
  Future<List> _login() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      setState(() {
        isLoading = true;
        message = "";
      });

      await LoginModel.login(
              model.username, model.password, deviceId, applicationId)
          .then((data) {
        //print(data);
        if (data != null) {
          if (data['status'] == true) {
            var token = data['data']['auth_key'];
            helper.login(token, model.username); // set session
            //message = data['message']; // di hide saja
            Navigator.pop(
                context); // untuk menghide screen saat ini // jika diperlukan
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new HomePage(
                          title: 'Home',
                          flashMessage: data['message'],
                        )));
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
    }
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

  // body
  Widget _buildBodyWidget(screenSize) {
    return Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this._formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Use email input type for emails.
                  decoration: new InputDecoration(
                    hintText: 'Username',
                    labelText: 'Enter your username',
                    icon: Icon(Icons.person),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    return model.validateUsername(value);
                  },
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return 'Enter some text';
//                    }
//                    return null;
//                  },
                  onSaved: (String value) {
                    this.model.username = value;
                  }),
              new TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: new InputDecoration(
                    hintText: 'Password',
                    labelText: 'Enter your password',
                    icon: Icon(Icons.lock),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    return model.validatePassword(value);
                  },
                  onSaved: (String value) {
                    this.model.password = value;
                  }),
              new Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _login();
                  },
//                  onPressed: this.submit,
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(top: 20.0),
              ),
              Text(message,
                  style: Style.Default.errorText(context),
                  textAlign: TextAlign.center),
            ],
          ),
        ));
  }
  // body

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      //onWillPop: () async => false, // disable back button
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // hidde back button
            title: Text(widget.title),
          ),
          body: ModalProgressHUD(
              child: _buildBodyWidget(screenSize), inAsyncCall: isLoading)),
    );
//        body: _buildBodyWidget());
  }
}
