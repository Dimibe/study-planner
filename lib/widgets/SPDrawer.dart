import 'package:flutter/material.dart';

class SPDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      semanticLabel: 'Main Menu',
      child: ListView(
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
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => null),
              );
            },
          ),
        ],
      ),
    );
  }
}
