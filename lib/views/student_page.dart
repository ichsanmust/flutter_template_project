import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// component
import 'package:flutter_template_project/components/helper.dart';
// style
import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/login_page.dart';
// models
import 'package:flutter_template_project/models/student_model.dart';

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
  var studentDataRefreshed = new List<Student>();
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

// insiate get user
  void getUsers() async {
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
                      title: 'Home',
                      flashMessage: message,
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
      //model.add(new Student(0,'-','-',0));
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
            studentDataRefreshed =
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
                      title: 'Home',
                      flashMessage: message,
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
        studentDataRefreshed = studentDataRefreshed;
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
        if (message != 'system error (timeout)') {
          helper.flashMessage('No more data');
        } else {
          helper.flashMessage(message, type: Style.Default.btnDanger());
        }
      }
      setState(() {
        message = 'success load more data';
        model.addAll(studentDataRefreshed);
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
          key: _refreshIndicatorKey,
          onRefresh: () {
            return _refresh();
          },
          child: ModalProgressHUD(
              child: _buildBodyWidget(), inAsyncCall: isLoading, opacity: 0),
        ));
  }

  Widget _buildBodyWidget() {
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
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      onSearchTextChanged(text);
                    });
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
                return _buildProgressIndicator();
              } else {
                return _buildItemView(index);
              }
            },
            controller: _scrollController,
          ),
        ),
      ],
    );
  }

  Widget _buildItemView(index) {
    var no = number + index;
    var key = model[index].key;
    var id = model[index].id;
    var name = model[index].name;
    var address = model[index].address;
    var age = model[index].age;
    return Padding(
      key: Key(key),
      padding: const EdgeInsets.all(5),
      child: Card(
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
