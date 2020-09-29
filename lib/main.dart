import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/CWTextField.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Study Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController0 = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawerScrimColor: Theme.of(context).backgroundColor,
      drawer: Drawer(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to study planner!',
              style: Theme.of(context).textTheme.headline2,
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Text(
              'Please type in the following information:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            CWTextField(
              hintText: 'Uni',
              controller: myController0,
            ),
            CWTextField(
              hintText: 'Studiengang',
              controller: myController1,
            ),
            CWTextField(
              hintText: 'Credits Hauptstudium',
              controller: myController2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            CWTextField(
              hintText: 'Credits Auflagen etc.',
              controller: myController3,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            CWTextField(
              hintText: 'Ziel Semesteranzahl',
              controller: myController4,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 16.0)),
            ButtonTheme(
              minWidth: 290,
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () {},
                child: Text(
                  'Weiter',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
