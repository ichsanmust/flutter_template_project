import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// style
import 'package:flutter_template_project/css/style.dart' as Style;

class Helper {
  static Helper _instance;
  factory Helper() => _instance ??= new Helper._();
  Helper._();

  // the unique ID of the application
  String _applicationId = "template_flutter_1_0";

  // the storage key for the token
  String _storageKeyMobileToken = "flutter_token_1_0";

  // the storage key for the user id
  String _storageKeyMobileUserId = "flutter_user_id_1_0";

  // the mobile device unique identity
  String _deviceIdentity = "";

  final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();
  Future<String> _getDeviceIdentity() async {
    if (_deviceIdentity == '') {
      try {
        if (Platform.isAndroid) {
          AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
          _deviceIdentity = "${info.device}-${info.id}";
        } else if (Platform.isIOS) {
          IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
          _deviceIdentity = "${info.model}-${info.identifierForVendor}";
        }
      } on PlatformException {
        _deviceIdentity = "unknown";
      }
    }

    return _deviceIdentity;
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _getMobileToken() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileToken) ?? '';
  }

  Future<bool> _setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileToken, token);
  }

  Future<String> _getMobileUserId() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileUserId) ?? '';
  }

  Future<bool> _setMobileUserId(String userid) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileUserId, userid);
  }

  Future<String> getDeviceId() async {
    var deviceId = await _getDeviceIdentity();
    return deviceId;
  }

  Future<String> getApplicationId() async {
    var applicationId = _applicationId;
    return applicationId;
  }

  static Future apiCheckSession(authKey) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() + "?r=api/default/check-session";
    var response = await http.get(url, headers: {
      //"Content-Type": "application/json",
      "app_mobile_token": applicationToken,
      "user_mobile_token": authKey,
    });
    try {
      return json.decode(response.body);
    } catch (e) {
      print('error caught: $e');
      return {
        'status': false,
        'message': e,
        'code': 500,
        'data': {'message': 'system error'},
      };
    }
  }

  static Future actionCheckSession(authKey) async {
    var data = await apiCheckSession(authKey).timeout(Duration(seconds: 30),
        onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

  Future<Map<String, dynamic>> checkSession() async {
    var authKey = await _getMobileToken();
    var status = false;
    if (authKey != '') {
      await Helper.actionCheckSession(authKey).then((data) {
        if (data != null) {
          if (data['status'] == true) {
            status = true;
          } else {
            status = false;
          }
        } else {
          status = false;
        }
      });
    } else {
      status = false;
    }

    var session = {
      'status': status,
      'auth_key': authKey,
    };
    return session;
  }

  Future<bool> setSession(String token, userid) async {
    await _setMobileToken(token);
    await _setMobileUserId(userid);
    return null;
  }

  Future<Map<String, dynamic>> getSession() async {
    var sessionTokenData = await _getMobileToken();
    var sessionUserIdData = await _getMobileUserId();
    var deviceId = await _getDeviceIdentity();
    var session = {
      'application_id': _applicationId,
      'device_id': deviceId,
      'auth_key': sessionTokenData,
      'userid': sessionUserIdData
    };
    return session;
  }

  Future<bool> login(String token, userid) async {
    await setSession(token, userid);
    return null;
  }

  Future<bool> logout() async {
    await _setMobileToken('');
    await _setMobileUserId('');
    return null;
  }

  static getTextSessionOver() {
    return 'session has over, please login.';
  }

  static baseUrlApi() {
    var url = "http://10.0.2.2/flutter_template_project_api/web/index.php";
    return url;
  }

  static getApplicationToken() {
    return 'asfafasfdsajeej89sadfasjfbwasfsagipPajjqwidbQBiadq';
  }

  // flashMessage
  flashMessage(message, {type = ''}) {
    var typeMessage;
    if (type == '') {
      typeMessage = Style.Default.btnInfo();
    } else {
      typeMessage = type;
    }
    if (message != '') {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIos: 1,
          backgroundColor: typeMessage,
          // textColor: Colors.white,
          fontSize: 12.0);
    }
  }
// flashMessage

}
