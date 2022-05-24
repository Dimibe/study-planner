import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get_it/get_it.dart';

import 'sp_drawer.dart';
import 'sp_form.dart';
import '../main.dart';
import '../pages/login.page.dart';
import '../services/navigator.service.dart';
import '../services/user.service.dart';
import '../utils/routes.dart';
import '../utils/user_routing.dart';

final GetIt getIt = GetIt.instance;

/// Base Widget which should be returned by any page widget.
class SPDialog extends StatefulWidget with Routes, UserRouting {
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
    super.key,
    required this.content,
    this.title = 'app.title',
    this.header,
  });

  @override
  SPDialogState createState() => SPDialogState();
}

class SPDialogState extends State<SPDialog> {
  late bool _loggedIn;
  late final StreamSubscription _authStateListener;

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
    _authStateListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        var showDrawer = constraints.maxWidth < 1080;
        return Scaffold(
          appBar: AppBar(
            title: Builder(builder: (context) {
              if (_loggedIn && !showDrawer) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.getRoutesForRow(context),
                );
              }
              return Text(FlutterI18n.translate(context, widget.title));
            }),
            centerTitle: true,
            leadingWidth: showDrawer ? null : 200,
            leading: Builder(
              builder: (BuildContext context) {
                if (_loggedIn) {
                  if (showDrawer) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
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
                        FlutterI18n.translate(context, widget.title),
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
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
            elevation: 0.0,
          ),
          drawerScrimColor: Theme.of(context).backgroundColor,
          drawer: _loggedIn ? const SPDrawer() : null,
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
                          FlutterI18n.translate(context, widget.header),
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

  Widget getLoginActionWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Center(
        child: GetIt.I<UserService>().isLoggedIn
            ? _getLogoutWidget(context)
            : _getLoginWidget(context),
      ),
    );
  }

  Widget _getLoginWidget(BuildContext context) {
    return TextButton(
      onPressed: _openLogin,
      child: Text(
        'Log in',
        style: TextStyle(
          color: Theme.of(context).primaryTextTheme.headline6!.color,
        ),
      ),
    );
  }

  Widget _getLogoutWidget(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600)
          Text(
            getIt<UserService>().email!,
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6!.color,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: IconButton(
            onPressed: () async {
              await GetIt.I<UserService>().logout();
              if (!mounted) return;
              MyApp.of(context)?.applyUserSettings(context);
              var page = await widget.getNextRoute();
              getIt<NavigatorService>().navigateTo(page);
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).primaryTextTheme.headline6!.color,
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
        return const LoginPage();
      },
    );
  }
}
