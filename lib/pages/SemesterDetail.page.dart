import 'package:flutter/material.dart';
import 'package:study_planner/widgets/common/CWButton.dart';
import 'package:study_planner/widgets/common/CWDynamicRow.dart';
import 'package:study_planner/widgets/common/CWTextField.dart';

class SemesterDetailPage extends StatefulWidget {
  SemesterDetailPage({Key key}) : super(key: key);

  @override
  _SemesterDetailPageState createState() => _SemesterDetailPageState();
}

class _SemesterDetailPageState extends State<SemesterDetailPage> {
  final myController0 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      content: Container(
        padding: EdgeInsets.all(50.0),
        child: Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CWTextField(
                    labelText: 'Semester',
                    controller: myController0,
                  ),
                ),
                CWDynamicRow(
                  showAddOption: true,
                  showHideOption: true,
                  //contoller: dynamicControllers,
                  children: [
                    CWTextField(
                      labelText: 'Kurs',
                    ),
                    CWTextField(
                      labelText: 'Credits',
                    ),
                    CWTextField(
                      labelText: 'Kategorie',
                    ),
                  ],
                ),
                CWButton(
                  label: 'Speichern',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
