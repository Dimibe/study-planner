import 'package:flutter/material.dart';
import 'package:study_planner/models/Semester.dart';

import 'common/CWText.dart';

class SPDataTable extends StatelessWidget {
  final Semester semester;
  final void Function() onEdit;

  const SPDataTable({Key key, this.semester, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var sidePadding = constraints.maxWidth < 450 ? 16.0 : 24.0;
        var topBottomPadding = constraints.maxWidth < 450 ? 8.0 : 32.0;
        return Container(
          padding: EdgeInsets.fromLTRB(
              sidePadding, topBottomPadding, sidePadding, topBottomPadding),
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        semester.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(padding: EdgeInsets.only(right: 8.0)),
                      if (semester.completed) Icon(Icons.check),
                    ],
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    onPressed: onEdit,
                    child: CWText(
                      'button.label.edit',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 10.0,
                  columns: [
                    DataColumn(label: CWText('label.course')),
                    DataColumn(label: CWText('label.credits')),
                    DataColumn(label: CWText('label.grade')),
                    DataColumn(label: CWText('label.studyField')),
                  ],
                  rows: List<DataRow>.generate(
                    semester.courses.length,
                    (index) {
                      var course = semester.courses[index];
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.08);
                          }
                          if (index % 2 == 0) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null;
                        }),
                        cells: [
                          DataCell(Text(course.name)),
                          DataCell(Text('${course.credits}')),
                          DataCell(Text('${course.grade ?? "-"}')),
                          DataCell(Text('${course.studyField ?? "-"}')),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
