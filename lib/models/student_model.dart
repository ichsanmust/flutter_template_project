import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:validators/validators.dart';
//import 'package:validators/sanitizers.dart';

// components
import 'package:flutter_template_project/components/helper.dart';

class Student {
  String key;
  int id;
  String name;
  String address;
  int age;

  static attributes() {
    var attributesData = [
      'id',
      'name',
      'address',
      'age'
    ];
    return attributesData;
  }

  Student(int id, String name, String address, int age) {
    this.key = "keyStudent_$id";
    this.id = id;
    this.name = name;
    this.address = address;
    this.age = age;
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return 'Name Cannot Blank';
    }
    return null;
  }

  String validateAddress(String value) {
    if (value.isEmpty) {
      return 'Adress Cannot Blank';
    }
    return null;
  }

  String validateAge(String value) {
    if (value.isEmpty) {
      return 'Age Cannot Blank';
    }
    if (!isNumeric(value)){
      return 'Age Must Numeric';
    }
    return null;
  }

  static errorMessage(error) {
    var messages = '';
    var attributes = Student.attributes();
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

  Student.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        address = json['address'],
        age = json['age'];

  Map toJson() {
    return {'id': id, 'name': name, 'address': address, 'age': age};
  }

  static Future apiList(authKey, page, filter) async {
//    print(filter);
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/list-student&sort=-id&page=$page&per-page=10&StudentSearch[name]=$filter";
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

  static Future list(authKey, page, filter) async {
    var data = await apiList(authKey, page, filter)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

  static Future apiDelete(authKey,id) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/delete-student&id=$id";
    var response = await http.delete(url, headers: {
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

  static Future delete(authKey, id) async {
    var data = await apiDelete(authKey, id)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

  static Future apiView(authKey,id) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/view-student&id=$id";
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

  static Future view(authKey, id) async {
    var data = await apiView(authKey, id)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

  static Future apiUpdate(authKey,id,name,address,age) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/update-student&id=$id";
    var response = await http.put(url, headers: {
      //"Content-Type": "application/json",
      "app_mobile_token": applicationToken,
      "user_mobile_token": authKey,
    }, body: {
      "name": name,
      "address": address,
      "age": age.toString(),
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

  static Future update(authKey,id,name,address,age) async {
    var data = await apiUpdate(authKey,id,name,address,age)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

  static Future apiCreate(authKey,name,address,age) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/create-student";
    var response = await http.post(url, headers: {
      //"Content-Type": "application/json",
      "app_mobile_token": applicationToken,
      "user_mobile_token": authKey,
    }, body: {
      "name": name,
      "address": address,
      "age": age.toString(),
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

  static Future create(authKey,name,address,age) async {
    var data = await apiCreate(authKey,name,address,age)
        .timeout(Duration(seconds: 30), onTimeout: () {
      print('30 seconds timed out');
    }).catchError(print);
    return data;
  }

}
