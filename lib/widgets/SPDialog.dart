import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

class SPDialog extends StatefulWidget {
  /// Title of the dialog.
  final String title;

  /// Content of the dialog.
  /// Can be either an array `<Widget>[]` or a function which returns an array
  /// `<Widget>[] Function()`.
  ///
  /// If [dependsOn] is specified it must be `<Widget>[] Function(dynamic)`
  /// where the passed value is the resolved future value. The method is only
  /// called when the value is present so there is no need for a null check.
  final dynamic content;

  /// Can be used when the dialog content depends on a Future<dynamic> which
  /// needs to be resolved. The resolved value will be directly passed to the
  /// content function.
  final Future<dynamic> dependsOn;

  SPDialog({
    @required this.content,
    this.dependsOn,
    this.title = 'Study Planner!',
  });

  @override
  _SPDialogState createState() => _SPDialogState();
}

class _SPDialogState extends State<SPDialog> {
  dynamic _value;

  @override
  void initState() {
    super.initState();
    widget.dependsOn?.then((value) => setState(() => _value = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu',
            );
          },
        ),
        actions: [getLoginActionWidget()],
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (widget.content is List)
                ? widget.content
                : (widget.dependsOn != null
                    ? (_value != null ? widget.content(_value) : [])
                    : widget.content()),
          ),
        ),
      ),
    );
  }

  Widget getLoginActionWidget() {
    Widget child = const Icon(Icons.person_pin);
    var func;
    UserService userService = GetIt.I<UserService>();
    if (!userService.isLoggedIn) {
      child = const Text('Log in', style: TextStyle(color: Colors.white));
      func = _openLogin;
    }

    return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Center(
          child: FlatButton(
            onPressed: func,
            child: child,
          ),
        ));
  }

  void _openLogin() async {
    var res = await showDialog(
        context: context,
        builder: (context) {
          return LoginPage();
        });
    if (res) {
      // login
    }
  }
}
