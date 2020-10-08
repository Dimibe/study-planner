import 'package:flutter/material.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

class SPDialog extends StatelessWidget {
  final String title;
  final dynamic content;

  SPDialog({@required this.title, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: SPDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (content is List) ? content : content(),
          ),
        ),
      ),
    );
  }
}
