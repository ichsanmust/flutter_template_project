import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// components
import 'package:flutter_template_project/components/helper.dart';

class LogoutModel {


//  static errorMessage(error) {
//    var messages = '';
//    var attributes = LoginModel.attributes();
//    for (var attribute in attributes) {
//      if (error[attribute] != null) {
//        var errors = error[attribute];
//        for (var errorData in errors) {
//          messages = messages + errorData + ', ';
//        }
//      }
//    }
//    return messages;
//  }

  static Future apiLogout(authKey) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() + "?r=api/default/logout";
    var response = await http.post(url, headers: {
      //"Content-Type": "application/json",
      "app_mobile_token":  applicationToken,
      "user_mobile_token": "",
    }, body: {
      "auth_key": authKey,
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

  static Future logout(authKey) async {
    var data = await apiLogout(authKey)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }
}
