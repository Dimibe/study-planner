import 'package:flutter/material.dart';
import 'package:study_planner/utils/Routes.dart';

class SPDrawer extends StatelessWidget with Routes {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      semanticLabel: 'Main Menu',
      child: Builder(
        builder: (context) {
          return ListView(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 80,
                  child: Text(
                    'Main Menu',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              ...getRoutes(),
            ],
          );
        },
      ),
    );
  }
}
