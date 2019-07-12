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

class StudentPageUpdate extends StatefulWidget {
  StudentPageUpdate({Key key, this.title, this.id, this.index})
      : super(key: key);
  final String title;
  final int id;
  final int index;

  @override
  _StudentPageUpdateState createState() => _StudentPageUpdateState();
}

class _StudentPageUpdateState extends State<StudentPageUpdate> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};

  Future<Map> get checkSessionData => helper.checkSession();
  var _isAuthenticated = {};
  var authKey = '';
  bool isLoading = true; // karena saat pertama kali load page, meload data
  String message = '';

  Student model;
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _addressController =
      TextEditingController();
  static final TextEditingController _ageController = TextEditingController();

  clearModel(){
    setState(() {
      _nameController.text = '';
      _addressController.text = '';
      _ageController.text = '';
      // _formKey.currentState.reset();
    });
  }

  // insiate get user
  void getStudent() async {
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
    });

    await Student.view(authKey, widget.id).then((data) {
      //print(data);
      if (data != null) {
        if (data['status'] == true) {
          var viewData = data['data'];
          model = new Student(viewData['id'], viewData['name'],
              viewData['address'], viewData['age']);

          setState(() {
            _nameController.text = viewData['name'];
            _addressController.text = viewData['address'];
            _ageController.text = viewData['age'].toString();
          });

          //message = 'success view data';
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

      setState(() {
        model = model;
        message = message;
        isLoading = false;
      });
    });
  }

  initState() {
    super.initState();
    clearModel();
    getStudent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // action save
  Future<List> _save(context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      setState(() {
        isLoading = true;
        message = "";
      });

      var id = model.id;
      var name = model.name;
      var address = model.address;
      var age = model.age;
      await Student.update(authKey, id, name, address, age).then((data) {
        if (data != null) {
          if (data['status'] == true) {
            //message = data['message'];
            helper.flashMessage(data['message'], type: Style.Default.btnInfo());
            Navigator.pop(context,
                '{"id": $id , "name" : "$name", "address" : "$address", "age": $age}');
          } else {
            if (data['code'] == 200) {
              //message = data['message'];
              var messagesError = Student.errorMessage(data['data']);
              message += messagesError;
            } else if (data['code'] == 403) {
              // jika gagal token
              // message = data['data']['message'];
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
        message = message;
        isLoading = false;
      });
    }
    //return _save();
    return null;
  }
  // end action save

  @override
  Widget build(BuildContext context) {
    return _form(context);
  }

  Widget _form(context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // hidde back button
          title: Text(widget.title),
        ),
        body: ModalProgressHUD(
            child: _buildBodyWidget(screenSize, context),
            inAsyncCall: isLoading));
  }

  // body
  Widget _buildBodyWidget(screenSize, context) {
    return Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: this._formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                  controller: _nameController,
                  decoration: new InputDecoration(
                    hintText: 'Name',
                    labelText: 'Enter Name',
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    return model.validateName(value);
                  },
                  onSaved: (String value) {
                    model.name = value;
                  }),
              new TextFormField(
                  controller: _addressController,
                  decoration: new InputDecoration(
                    hintText: 'Address',
                    labelText: 'Enter Address',
                    //icon: Icon(Icons.person),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    return model.validateAddress(value);
                  },
                  onSaved: (String value) {
                    model.address = value;
                  }),
              new TextFormField(
                keyboardType: TextInputType.number,
                controller: _ageController,
                decoration: new InputDecoration(
                  hintText: 'Age',
                  labelText: 'Enter Age',
                  //icon: Icon(Icons.person),
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  return model.validateAge(value);
                },
                onSaved: (String value) {
                  model.age = int.parse(value);
                },
              ),
              new Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Save',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _save(context);
                  },
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(top: 20.0),
              ),
              Text(message,
                  style: Style.Default.errorText(context),
                  textAlign: TextAlign.center),
            ],
          ),
        ));
  }
// body

}
