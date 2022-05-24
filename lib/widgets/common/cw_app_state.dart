import 'package:flutter/widgets.dart';

/// This class only exists because of some render issues in flutter for web.
/// In some cases widgets get blurred when using floating point pixel values.
/// This class prevents this effect by going through the dom tree and parsing
/// floating point pixel values too ints.
///
/// Remove this code if bug is fixed in flutter.
abstract class CWState<T extends StatefulWidget> extends State<T> {}
