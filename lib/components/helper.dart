import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

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

  Future<bool> checkSession() async {
    var mobileToken = await _getMobileToken();
    if (mobileToken != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setSession(String token, userid) async {
//    var sessionTokenData = await _setMobileToken(token);
//    var sessionUserIdData = await _setMobileUserId(userid);
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

  static getApplicationToken() {
    return 'asfafasfdsajeej89sadfasjfbwasfsagipPajjqwidbQBiadq';
  }

  static baseUrlApi() {
    var url = "http://10.0.2.2/flutter_template_project_api/web/index.php";
    return url;
  }

  Future<String> getDeviceId() async {
    var deviceId = await _getDeviceIdentity();
    return deviceId;
  }

  Future<String> getApplicationId() async {
    var applicationId = _applicationId;
    return applicationId;
  }

  // flashMessage
  flashMessage(message) {
    if (message != '') {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
          backgroundColor: Style.Default.btnInfo(),
//          textColor: Colors.white,
          fontSize: 12.0);
    }
  }
// flashMessage

}
