import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter_template_project/components/helper.dart';

import 'package:flutter_template_project/models/student_model.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};
  var authKey = '';
  var student = new List<Student>();

  String message = '';
  bool isLoading = false;
  var firstNumber=1;
  var lastNumber=1;

  void getUsers() async {
    session = await sessionDataSource;
    setState(() {
      session = session;
      authKey = session['auth_key'];
      isLoading = true;
      message = "";
    });


    await Student.list(authKey).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          student = list.map((model) => Student.fromJson(model)).toList();
        }
      }


      setState(() {
        lastNumber = student.length;
        firstNumber = lastNumber;
        student = student;
        message = message;
        isLoading = false;
      });

    });
  }

  Future<Null> _refresh() {
    return  Student.list(authKey).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          student = list.map((model) => Student.fromJson(model)).toList();
          //student.addAll(list.map((model) => Student.fromJson(model)).toList());
        }
      }

      setState(() {
        student = student;
        //student.addAll(list);
        student = student;
      });

    });
  }


  initState() {
    super.initState();
    getUsers();
  }

  dispose() {
    super.dispose();
  }

  Widget _buildBodyWidget() {
    return ListView.builder(
      itemCount: student.length,
      itemBuilder: (context, index) {
        var number = firstNumber + index;
        var key = student[index].key;
        var id = student[index].id;
        var name = student[index].name;
        var address = student[index].address;
        var age = student[index].age;
        return Padding(
          key: Key(key),
          padding: const EdgeInsets.all(5),
          child: ExpansionTile(
            title: Text(
              "$number. $name - $address ($age)",
              style: new TextStyle(fontSize: 20.0),
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround ,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "View",
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.blue,

                    onPressed: (){},
                  ),
                  FlatButton(
                    child: Text(
                      "Edit",
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.green,
                    onPressed: (){},
                  ),
                  FlatButton(
                    child: Text(
                      "Delete",
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    color: Colors.red,
                    onPressed: (){},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student"),
        ),
        body: RefreshIndicator(
          onRefresh: ()  {
           return _refresh();
          },
          child: ModalProgressHUD(
              child: _buildBodyWidget(), inAsyncCall: isLoading),
        ));
  }
}
