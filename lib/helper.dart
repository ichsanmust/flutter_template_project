import 'dart:async';
import 'dart:io';
//import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

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

  // the URL of the Web Server
  // String _urlBase = "https://www.myserver.com";

  // the URI to the Web Server Web API
  // String _serverApi = "/api/mobile/";

  // the mobile device unique identity
  String _deviceIdentity = "";

  /// ----------------------------------------------------------
  /// Method which is only run once to fetch the device identity
  /// ----------------------------------------------------------
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

  /// ----------------------------------------------------------
  /// Method that returns the token from Shared Preferences
  /// ----------------------------------------------------------

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _getMobileToken() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileToken) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------
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
      'token': sessionTokenData,
      'userid': sessionUserIdData
    };
    return session;
  }

  Future<bool>login(String token, userid) async {
    await setSession(token,userid);
    return null;
  }

  Future<bool>logout() async {
    await _setMobileToken('');
    await _setMobileUserId('');
    return null;
  }

}
