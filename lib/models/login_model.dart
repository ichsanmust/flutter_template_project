import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// components
import 'package:flutter_template_project/components/helper.dart';

class LoginModel {
  static attributes() {
    var attributesData = [
      'username',
      'password',
      'device_mobile_id',
      'application_id'
    ];
    return attributesData;
  }

  static errorMessage(error) {
    var messages = '';
    var attributes = LoginModel.attributes();
    for (var attribute in attributes) {
      if (error[attribute] != null) {
        var errors = error[attribute];
        for (var errorData in errors) {
          messages = messages + errorData + '\n';
        }
      }
    }
    return messages;
  }

  static Future login(email, password, deviceId, applicationId) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() + "?r=api/default/login";
    var response = await http.post(url, headers: {
      //"Content-Type": "application/json",
      "app_mobile_token":  applicationToken,
      "user_mobile_token": "",
    }, body: {
      "username": email,
      "password": password,
      "device_mobile_id": deviceId,
      "application_id": applicationId,
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
}
