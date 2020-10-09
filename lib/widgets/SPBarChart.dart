import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class SPBarChart<T> extends StatelessWidget {
  final String id;
  final String title;
  final List<T> data;
  final num Function(T, int) measureFn;
  final String Function(T, int) domainFn;

  const SPBarChart({
    Key key,
    @required this.id,
    @required this.data,
    @required this.measureFn,
    @required this.domainFn,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 300,
      height: 300,
      child: BarChart(
        _getData(context),
        animate: true,
        defaultInteractions: false,
        behaviors: [ChartTitle(this.title)],
        barRendererDecorator: BarLabelDecorator<String>(),
      ),
    );
  }

  List<Series<dynamic, String>> _getData(context) {
    return [
      Series<T, String>(
        id: this.id,
        data: this.data,
        domainFn: this.domainFn,
        measureFn: this.measureFn,
        labelAccessorFn: (arg1, arg2) => '${this.measureFn(arg1, arg2)}',
        colorFn: (semester, _) {
          var theme = Theme.of(context).accentColor;
          return Color(r: theme.red, g: theme.green, b: theme.blue);
        },
      ),
    ];
  }
}
