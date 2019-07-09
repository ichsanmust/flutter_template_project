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
  var studentDataRefreshed = new List<Student>();
  var page = 1;
  var countPage = 1;
  var totalItem = 0;
  var number = 1;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool isLoading = false;
  String message = '';

// insiate get user
  void getUsers() async {
    session = await sessionDataSource;
    setState(() {
      session = session;
      authKey = session['auth_key'];
      isLoading = true;
      message = "";
      page = 1;
    });

    await Student.list(authKey, page).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          student = list.map((model) => Student.fromJson(model)).toList();
          totalItem = data['data']['total_item'];
          countPage = data['data']['count_page'];
          page++;
        }
      }

      setState(() {
        student = student;
        totalItem = totalItem;
        countPage = countPage;
        page = page;
        message = message;
        isLoading = false;
      });
    });
  }

// refresh get user
  Future<Null> _refresh() {
    setState(() {
      page = 1;
    });

    return Student.list(authKey, page).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          student = list.map((model) => Student.fromJson(model)).toList();
          totalItem = data['data']['total_item'];
          countPage = data['data']['count_page'];
          page++;
        }
      }

      setState(() {
        page = page;
        student = student;
        totalItem = totalItem;
        student = student;
        student = student;
      });
    });
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      await Student.list(authKey, page).then((data) {
        if (data != null) {
          if (data['status'] == true) {
            Iterable list = data['data']['data'];
            studentDataRefreshed =
                list.map((model) => Student.fromJson(model)).toList();
            totalItem = data['data']['total_item'];
            countPage = data['data']['count_page'];
            page++;
          }
        }
      });
      if (studentDataRefreshed.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        helper.flashMessage('No more data');
      }
      setState(() {
        student.addAll(studentDataRefreshed);
        isPerformingRequest = false;
      });
    }
  }

  initState() {
    super.initState();
    getUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
        //print('get more');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student"),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return _refresh();
          },
          child: ModalProgressHUD(
              child: _buildBodyWidget(), inAsyncCall: isLoading, opacity: 0),
        ));
  }

  Widget _buildBodyWidget() {
    return ListView.builder(
      itemCount: student.length + 1,
      itemBuilder: (context, index) {
        if (index == student.length) {
          return _buildProgressIndicator();
        } else {
          return _buildItemView(index);
        }
      },
      controller: _scrollController,
    );
  }

  Widget _buildItemView(index) {
    var no = number + index;
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
          "$no. $name - $address ($age)",
          style: new TextStyle(fontSize: 20.0),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "View",
                  style: new TextStyle(fontSize: 16.0),
                ),
                color: Colors.blue,
                onPressed: () {},
              ),
              FlatButton(
                child: Text(
                  "Edit",
                  style: new TextStyle(fontSize: 16.0),
                ),
                color: Colors.green,
                onPressed: () {},
              ),
              FlatButton(
                child: Text(
                  "Delete",
                  style: new TextStyle(fontSize: 16.0),
                ),
                color: Colors.red,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
