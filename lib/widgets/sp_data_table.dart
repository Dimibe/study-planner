import 'package:flutter/material.dart';

import 'common/cw_text.dart';
import '../models/semester.dart';

class SPDataTable extends StatelessWidget {
  final Semester semester;
  final void Function() onEdit;

  const SPDataTable({super.key, required this.semester, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var sidePadding = constraints.maxWidth < 450 ? 16.0 : 24.0;
        var topBottomPadding = constraints.maxWidth < 450 ? 8.0 : 32.0;
        return Container(
          padding: EdgeInsets.fromLTRB(
              sidePadding, topBottomPadding, sidePadding, topBottomPadding),
          constraints: const BoxConstraints(maxWidth: 500),
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
                      const Padding(padding: EdgeInsets.only(right: 8.0)),
                      if (semester.completed) const Icon(Icons.check),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                    onPressed: onEdit,
                    child: CWText(
                      'button.label.edit',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 10.0,
                  columns: const [
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
                        color: MaterialStateProperty.resolveWith<Color?>(
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
