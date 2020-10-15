// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/widgets.dart';

abstract class CWState<T extends StatefulWidget> extends State<T> {
  MutationObserver _mutationObserver;

  @override
  initState() {
    _mutationObserver = MutationObserver(
        (List<dynamic> mutations, MutationObserver observer) =>
            _translateHack());

    WidgetsBinding.instance.addPostFrameCallback((_) => _translateHack());

    super.initState();
  }

  void _translateHack() async {
    List<Node> nodes = window.document.getElementsByTagName("*");

    for (Node node in nodes) {
      _mutationObserver.observe(node, childList: true);
      html.Element el = node as html.Element;
      if (el.style.transform.isEmpty) continue;
      if (!el.style.transform.contains("\.")) continue;
      el.style.transform = _normalizeTranslate(el.style.transform);
    }
  }

  String _normalizeTranslate(String value) {
    if (value.length > 12) {
      if (value.substring(0, 10) == "translate(") {
        String p = value
            .replaceFirst("translate(", "")
            .replaceFirst(")", "")
            .replaceAll("px", "");
        List<String> m = p.split(", ");
        return "translate(" +
            (double.parse(m[0]).toInt()).toString() +
            "px, " +
            (double.parse(m[1]).toInt()).toString() +
            "px)";
      } else if (value.substring(0, 12) == "translate3d(") {
        String p = value
            .replaceFirst("translate3d(", "")
            .replaceFirst(")", "")
            .replaceAll("px", "");
        List<String> m = p.split(", ");
        return "translate3d(" +
            (double.parse(m[0]).toInt()).toString() +
            "px, " +
            (double.parse(m[1]).toInt()).toString() +
            "px, " +
            double.parse(m[2]).toInt().toString() +
            "px)";
      }
    }
    return value;
  }
}
