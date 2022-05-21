import 'package:flutter/material.dart';

import './common/cw_text.dart';
import '../utils/routes.dart';

class SPDrawer extends StatelessWidget with Routes {
  const SPDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      semanticLabel: 'MainMenu',
      child: Builder(
        builder: (context) {
          return ListView(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 80,
                  child: CWText(
                    'text.mainMenu',
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
