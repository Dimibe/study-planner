import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class SPBarChart<T> extends StatelessWidget {
  final String id;
  final String title;
  final List<T> data;
  final num Function(T, int) measureFn;
  final String Function(T, int) domainFn;
  final String Function(T, int) labelFn;
  final num average;

  const SPBarChart({
    Key key,
    @required this.id,
    @required this.data,
    @required this.measureFn,
    @required this.domainFn,
    this.labelFn,
    this.title,
    this.average,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var annotations = <LineAnnotationSegment>[];
    if (average != null) {
      annotations.add(
        LineAnnotationSegment(
          average,
          RangeAnnotationAxisType.measure,
          middleLabel: 'Ø',
          labelPosition: AnnotationLabelPosition.margin,
          color: MaterialPalette.gray.shade400,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      width: 400,
      height: 300,
      child: BarChart(
        _getData(context),
        animate: true,
        defaultInteractions: false,
        behaviors: [
          ChartTitle(this.title,
              subTitle:
                  average == null ? null : 'Ø ${average.toStringAsFixed(2)}'),
          RangeAnnotation(annotations),
        ],
        barRendererDecorator: BarLabelDecorator<String>(),
      ),
    );
  }

  List<Series<dynamic, String>> _getData(context) {
    return [
      Series<T, String>(
        id: id,
        data: data,
        domainFn: domainFn,
        measureFn: measureFn,
        labelAccessorFn: (arg1, arg2) =>
            labelFn != null ? labelFn(arg1, arg2) : '${measureFn(arg1, arg2)}',
        colorFn: (semester, _) {
          var theme = Theme.of(context).accentColor;
          return Color(r: theme.red, g: theme.green, b: theme.blue);
        },
      ),
    ];
  }
}
