import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_template_project/components/helper.dart';

const baseUrl = "https://jsonplaceholder.typicode.com";

class Student {
  String key;
  int id;
  String name;
  String address;
  int age;

  Student(int id, String name, String address, int age) {
    this.key = "key_$id";
    this.id = id;
    this.name = name;
    this.address = address;
    this.age = age;
  }

  Student.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        address = json['address'],
        age = json['age'];

  Map toJson() {
    return {'id': id, 'name': name, 'address': address, 'age': age};
  }

  static Future list(authKey) async {
    var applicationToken = Helper.getApplicationToken();
    var url = Helper.baseUrlApi() +
        "?r=api/default/list-student&sort=-id&per-page=false";
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
}
