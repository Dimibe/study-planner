import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:study_planner/pages/Login.page.dart';
import 'package:study_planner/services/UserService.dart';
import 'package:study_planner/utils/Routes.dart';
import 'package:study_planner/widgets/SPDrawer.dart';
import 'package:study_planner/widgets/SPForm.dart';

final GetIt getIt = GetIt.instance;

/// Base Widget which should be returned by any page widget.
class SPDialog extends StatefulWidget with Routes {
  /// Title of the dialog.
  final String title;

  /// Header of the dialog.
  /// Can be either an array `<Widget>[]` or a function which returns an array
  /// `<Widget>[] Function()`.
  final dynamic header;

  /// Content of the dialog.
  /// Can be either an array `<Widget>[]` or a function which returns an array
  /// `<Widget>[] Function()`.
  final dynamic content;

  SPDialog({
    @required this.content,
    this.title = 'Study Planner!',
    this.header,
  });

  @override
  SPDialogState createState() => SPDialogState();
}

class SPDialogState extends State<SPDialog> {
  bool _loggedIn;
  StreamSubscription _authStateListener;

  @override
  void initState() {
    super.initState();
    _loggedIn = getIt<UserService>().isLoggedIn;
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
    return LayoutBuilder(
      builder: (_, constraints) {
        bool showDrawer = constraints.maxWidth < 1080;
        return Scaffold(
          appBar: AppBar(
            title: Builder(builder: (context) {
              if (_loggedIn && !showDrawer) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.getRoutesForRow(context),
                );
              }
              return Text(this.widget.title);
            }),
            centerTitle: true,
            leadingWidth: showDrawer ? null : 200,
            leading: Builder(
              builder: (BuildContext context) {
                if (_loggedIn) {
                  if (showDrawer) {
                    return IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Menu',
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Center(
                      child: Text(
                        this.widget.title,
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            actions: [getLoginActionWidget(context)],
          ),
          drawerScrimColor: Theme.of(context).backgroundColor,
          drawer: _loggedIn ? SPDrawer() : null,
          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: SPForm(
                child: Column(
                  children: [
                    if (widget.header != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          24.0,
                          16.0,
                          50.0,
                        ),
                        child: Text(
                          widget.header,
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (widget.content is List) ...widget.content,
                    if (widget.content is! List) ...widget.content(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getLoginActionWidget(context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Center(
        child: GetIt.I<UserService>().isLoggedIn
            ? _getLogoutWidget(context)
            : _getLoginWidget(context),
      ),
    );
  }

  Widget _getLoginWidget(context) {
    return FlatButton(
      onPressed: _openLogin,
      child: Text(
        'Log in',
        style: TextStyle(
          color: Theme.of(context).primaryTextTheme.headline6.color,
        ),
      ),
    );
  }

  Widget _getLogoutWidget(context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600)
          Text(
            GetIt.I<UserService>().email,
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: IconButton(
            onPressed: GetIt.I<UserService>().logout,
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).primaryTextTheme.headline6.color,
            ),
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
