import 'package:flutter/material.dart';
import 'package:study_planner/models/Semester.dart';

class SPDataTable extends StatelessWidget {
  final Semester semester;

  const SPDataTable({Key key, this.semester}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      constraints: BoxConstraints(maxWidth: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                semester.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Bearbeiten',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ))
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Kurs')),
                DataColumn(label: Text('Credits')),
              ],
              rows: List<DataRow>.generate(
                semester.courses.length,
                (index) {
                  var course = semester.courses[index];
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected))
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
                      return null;
                    }),
                    cells: [
                      DataCell(Text(course.name)),
                      DataCell(Text('${course.credits}')),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
