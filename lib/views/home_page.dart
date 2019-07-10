import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

// component
import 'package:flutter_template_project/components/helper.dart';
// style
// import 'package:flutter_template_project/css/style.dart' as Style;
// views
import 'package:flutter_template_project/views/left_menu.dart';
// import 'package:flutter_template_project/views/login_page.dart';

enum ListPopupMenu { action1, other }

class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
      this.title,
      this.flashMessage = '',
      this.typeMessage = Colors.green})
      : super(key: key);
  final String title;
  final String flashMessage;
  final Color typeMessage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Helper helper = new Helper();
  Future<Map> get sessionDataSource => helper.getSession();
  var session = {};

  void getSession() async {
    session = await sessionDataSource;
    setState(() {
      session = session;
    });
  }

  String message = '';
  bool isLoading = false;
  DateTime currentBackPressTime;

  // inisiate
  @override
  void initState() {
    super.initState();
    helper.flashMessage(widget.flashMessage, type: widget.typeMessage);
    getSession();
  }

  // on back button
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Tap 2x to exit Apps",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
//          timeInSecForIos: 1,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
          fontSize: 12.0);
      return Future.value(false);
    }
    //return Future.value(true);
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return Future.value(false);
  }
  // on back button

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: () async => false, // disable back button
      onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            //automaticallyImplyLeading: false, // hide back button
            title: Text(widget.title),
            actions: <Widget>[
              PopupMenuButton<ListPopupMenu>(
                onSelected: (ListPopupMenu result) {
                  if (result == ListPopupMenu.action1) {
                    //this._logout();
                    print("action 1");
                  } else if (result == ListPopupMenu.other) {
                    print("other");
                  } else {
                    // none
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ListPopupMenu>>[
                      const PopupMenuItem<ListPopupMenu>(
                        value: ListPopupMenu.action1,
                        child: Text('Action 1'),
                      ),
                      const PopupMenuItem<ListPopupMenu>(
                        value: ListPopupMenu.other,
                        child: Text('Other'),
                      ),
                    ],
              )
            ],
          ),
          drawer: new Drawer(
            child: LeftMenu(),
          ),
          body: ModalProgressHUD(
              child: _buildBodyWidget(context), inAsyncCall: isLoading)),
    );
  }

  Widget _buildBodyWidget(context) {
    return Center(
      child: Text('Home'),
    );
  }

}
