import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// component
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/login_page.dart';
import 'package:flutter_template_project/views/student/student_page_update.dart';
import 'package:flutter_template_project/views/student/student_page_create.dart';
// models
import 'package:flutter_template_project/models/student_model.dart';

enum ListPopupMenu { delete, update }

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};

  Future<Map> get checkSessionData => helper.checkSession();
  var _isAuthenticated = {};

  var authKey = '';
  var model = new List<Student>();
  var modelDataRefreshed = new List<Student>();
  var page = 1;
  var countPage = 1;
  var totalItem = 0;
  var number = 1;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool isLoading = false;
  String message = '';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _searchController = new TextEditingController();
  int selectedList;

// inisiate get user
  void getStudentList() async {
    _isAuthenticated = await checkSessionData;
    if (_isAuthenticated['status'] == false) {
      // check session, jika sudah habis redirect ke login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  title: 'Login',
                  flashMessage: Helper.getTextSessionOver(),
                  typeMessage: Style.Default.btnDanger(),
                )),
        (Route<dynamic> route) => false,
      );
    }
    session = await sessionDataSource;
    setState(() {
      session = session;
      authKey = session['auth_key'];
      isLoading = true;
      message = "";
      page = 1;
    });

    await Student.list(authKey, page, _searchController.text).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          model = list.map((model) => Student.fromJson(model)).toList();
          totalItem = data['data']['total_item'];
          countPage = data['data']['count_page'];
          page++;
        } else {
          if (data['code'] == 200) {
            message = data['message'];
          } else if (data['code'] == 403) {
            // jika gagal token
            message = data['data']['message'];
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                      title: 'Login',
                      flashMessage: Helper.getTextSessionOver(),
                      typeMessage: Style.Default.btnDanger())),
              (Route<dynamic> route) => false,
            );
          } else {
            message = data['data']['message'];
          }
          //print(message);
          helper.flashMessage(message, type: Style.Default.btnDanger());
        }
      } else {
        message = 'system error (timeout)';
        helper.flashMessage(message, type: Style.Default.btnDanger());
      }
    });

    setState(() {
      model = model;
      totalItem = totalItem;
      countPage = countPage;
      page = page;
      message = message;
      isLoading = false;
    });
  }

  _callApi(type) {
    if (type == 'search') {
      setState(() {
        if (!isLoading) {
          isLoading = true;
        }
        message = "";
        page = 1;
      });
    }

    return Student.list(authKey, page, _searchController.text).then((data) {
      if (data != null) {
        if (data['status'] == true) {
          Iterable list = data['data']['data'];
          if (type == 'refresh' || type == 'search') {
            model = list.map((model) => Student.fromJson(model)).toList();
          } else {
            modelDataRefreshed =
                list.map((model) => Student.fromJson(model)).toList();
          }
          totalItem = data['data']['total_item'];
          countPage = data['data']['count_page'];
          page++;
        } else {
          if (data['code'] == 200) {
            message = data['message'];
          } else if (data['code'] == 403) {
            // jika gagal token
            message = data['data']['message'];
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                      title: 'Login',
                      flashMessage: Helper.getTextSessionOver(),
                      typeMessage: Style.Default.btnDanger())),
              (Route<dynamic> route) => false,
            );
          } else {
            message = data['data']['message'];
          }
          //print(message);
          helper.flashMessage(message, type: Style.Default.btnDanger());
        }
      } else {
        message = 'system error (timeout)';
        print(message);
        helper.flashMessage(message, type: Style.Default.btnDanger());
      }

      setState(() {
        model = model;
        modelDataRefreshed = modelDataRefreshed;
        totalItem = totalItem;
        countPage = countPage;
        page = page;
        message = message;
        isLoading = false;
      });
    });
  }

// refresh get user
  Future<dynamic> _refresh() {
    setState(() {
      page = 1;
    });
    return _callApi('refresh');
  }
// refresh get user

//  get more data
  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      await _callApi('more_data');
      if (modelDataRefreshed.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        if (message != 'system error (timeout)') {
          helper.flashMessage('No more data');
        } else {
          helper.flashMessage(message, type: Style.Default.btnDanger());
        }
      }
      setState(() {
        message = 'success load more data';
        model.addAll(modelDataRefreshed);
        isPerformingRequest = false;
      });
    }
  }
//  get more data

//  search data
  onSearchTextChanged(String text) async {
    model.clear();
    _callApi('search');
  }
//  search data

  // add data
  void addStudent(context) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new StudentPageCreate(
                  title: 'Add Student',
                )));
    _refresh();
    setState(() {
      selectedList = 0;
    });
    Future.delayed(const Duration(milliseconds: 3500), () {
      setState(() {
        selectedList = null;
      });
    });
  }
  // add data

  // update data
  void updateStudent(context, id, index) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new StudentPageUpdate(
                  title: 'Update Student',
                  id: id,
                  index: index,
                )));

    if (result != null) {
      var updateData = await json.decode(result);

      //print(updateData);
      // update data list
      model[index].name = updateData['name'];
      model[index].address = updateData['address'];
      model[index].age = updateData['age'];
      setState(() {
        selectedList = index;
        model = model;
      });

      Future.delayed(const Duration(milliseconds: 3500), () {
        setState(() {
          selectedList = null;
        });
      });
      // update data list

//    Scaffold.of(context)
//      ..removeCurrentSnackBar()
//      ..showSnackBar(SnackBar(content: Text("$updateData")));
    }
  }
  // update data

  // delete data
  void deleteStudent(id, index) async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation"),
          content: new Text("Are you sure to delete data ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  isLoading = true;
                  message = "";
                });

                await Student.delete(authKey, id).then((data) {
                  //print(data);
                  if (data != null) {
                    if (data['status'] == true) {
                      model.removeWhere((item) => item.id == id);
                      message = data['message'];
                      helper.flashMessage(message,
                          type: Style.Default.btnInfo());
                    } else {
                      if (data['code'] == 200) {
                        message = data['message'];
                      } else if (data['code'] == 403) {
                        // jika gagal token
                        message = data['data']['message'];
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                  title: 'Login',
                                  flashMessage: Helper.getTextSessionOver(),
                                  typeMessage: Style.Default.btnDanger())),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        message = data['data']['message'];
                      }
                      //print(message);
                      helper.flashMessage(message,
                          type: Style.Default.btnDanger());
                    }
                  } else {
                    message = 'system error (timeout)';
                    print(message);
                    helper.flashMessage(message,
                        type: Style.Default.btnDanger());
                  }

                  setState(() {
                    model = model;
                    message = message;
                    isLoading = false;
                  });
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // delete data

  initState() {
    super.initState();
    getStudentList();
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
        key: _refreshIndicatorKey,
        onRefresh: () {
          return _refresh();
        },
        child: ModalProgressHUD(
            child: _buildBodyWidget(context), inAsyncCall: isLoading),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStudent(context);
        },
        tooltip: 'Add Student',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyWidget(context) {
    return Column(
      children: <Widget>[
        new Container(
          color: Theme.of(context).primaryColor,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: _searchController,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: (text) {
                    //Future.delayed(const Duration(milliseconds: 1000), () {
                    onSearchTextChanged(text);
                    //});
                  },
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    _searchController.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: model.length + 1,
            itemBuilder: (context, index) {
              if (index == model.length) {
                return _buildProgressIndicator(context);
              } else {
                return _buildItemView(index, context);
              }
            },
            controller: _scrollController,
          ),
        ),
      ],
    );
  }

  Widget _buildItemView(index, context) {
    var no = number + index;
    var key = model[index].key;
    var id = model[index].id;
    var name = model[index].name;
    var address = model[index].address;
    var age = model[index].age;
    Color colorSelected;
    if (selectedList == index) {
      colorSelected = Style.Default.btnPrimary();
    } else {
      colorSelected = Colors.white;
    }
    return Padding(
      key: Key(key),
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: colorSelected, width: 2.0),
            borderRadius: BorderRadius.circular(5.0)),
        //color: Colors.blue[100],

        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "$no. $name - $address ($age)",
                style: new TextStyle(fontSize: 20.0),
              ),
              PopupMenuButton<ListPopupMenu>(
                onSelected: (ListPopupMenu result) {
                  if (result == ListPopupMenu.delete) {
                    deleteStudent(id, index);
                  } else if (result == ListPopupMenu.update) {
                    updateStudent(context, id, index);
                  } else {
                    // none
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ListPopupMenu>>[
                      const PopupMenuItem<ListPopupMenu>(
                        value: ListPopupMenu.update,
                        child: Text('Update'),
                      ),
                      const PopupMenuItem<ListPopupMenu>(
                        value: ListPopupMenu.delete,
                        child: Text('Delete'),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(context) {
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
