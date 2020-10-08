import 'package:flutter/material.dart';
import 'package:study_planner/widgets/SPDrawer.dart';

class SPDialog extends StatelessWidget {
  final String title;
  final dynamic content;

  SPDialog({@required this.content, this.title = 'Study Planner!'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
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
