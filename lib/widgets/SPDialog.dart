import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

/// Base Widget which should be returned by any page widget.
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
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Center(
        child: GetIt.I<UserService>().isLoggedIn
            ? _getLogoutWidget()
            : _getLoginWidget(),
      ),
    );
  }

  Widget _getLoginWidget() {
    return FlatButton(
      onPressed: _openLogin,
      child: const Text('Log in', style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _getLogoutWidget() {
    return Row(
      children: [
        Text(
          GetIt.I<UserService>().email,
          style: const TextStyle(color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: IconButton(
            onPressed: GetIt.I<UserService>().logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _openLogin() async {
    await showDialog(
      context: context,
      builder: (context) {
        return LoginPage();
      },
    );
  }
}
