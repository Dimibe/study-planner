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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CWTextField(
              labelText: 'Semester',
              controller: myController0,
            ),
            CWDynamicRow(
              showAddOption: true,
              showHideOption: true,
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              //contoller: dynamicControllers,
              children: [
                CWTextField(
                  labelText: 'Kurs',
                  helperText: 'Name',
                  maxWidth: 150,
                ),
                CWTextField(
                  labelText: 'Credits',
                  helperText: 'Anzahl',
                  maxWidth: 150,
                ),
                CWTextField(
                  labelText: 'Kategorie',
                  helperText: 'Comming soon..',
                  maxWidth: 150,
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
    );
  }
}
