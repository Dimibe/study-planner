import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

final GetIt getIt = GetIt.instance;

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

  SPDialog({
    @required this.content,
    this.title = 'Study Planner!',
  });

  @override
  _SPDialogState createState() => _SPDialogState();
}

class _SPDialogState extends State<SPDialog> {
  bool _loggedIn = false;
  StreamSubscription _authStateListener;

  @override
  void initState() {
    super.initState();
    _authStateListener = getIt<UserService>().addAuthStateListener((user) {
      setState(() {
        _loggedIn = user != null;
      });
    });
  }

  @override
  void dispose() {
    _authStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
        leading: Builder(
          builder: (BuildContext context) {
            if (_loggedIn) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'Menu',
              );
            }
            return Container();
          },
        ),
        actions: [getLoginActionWidget()],
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: _loggedIn ? SPDrawer() : null,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                (widget.content is List) ? widget.content : widget.content(),
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
    var content = <Widget>[];
    if (MediaQuery.of(context).size.width > 600) {
      content.add(
        Text(
          GetIt.I<UserService>().email,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    content.add(
      Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: IconButton(
          onPressed: GetIt.I<UserService>().logout,
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ),
    );

    return Row(
      children: content,
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
