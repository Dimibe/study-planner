import 'package:flutter/widgets.dart';

/// This interface must be implemented by widgets which should be used
/// in [CWDynamicContainer] widget.
///
/// The returned controller in `createController()` must have a `text` property.
abstract class CWBaseWidget<T> extends StatefulWidget {
  final String id;

  const CWBaseWidget(this.id, {super.key});

  T copy(covariant dynamic controller);

  dynamic createController();
}
