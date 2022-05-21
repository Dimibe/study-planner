import 'package:flutter/material.dart';

import 'cw_text.dart';

class CWCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subTitle;
  final String trailingTitle;
  final EdgeInsetsGeometry margin;
  final double width;
  final double height;
  final void Function()? onTap;
  final List<String> info;
  final List<String> subInfo;

  const CWCard({
    super.key,
    this.onTap,
    required this.title,
    this.subTitle = '',
    this.trailingTitle = '',
    this.color = Colors.blue,
    this.info = const [],
    this.subInfo = const [],
    this.margin = const EdgeInsets.all(8.0),
    this.width = 300,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: color.withAlpha(220),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(400.0),
                  bottomLeft: Radius.circular(400.0),
                  bottomRight: Radius.elliptical(2000.0, 8500.0),
                ),
                child: Container(
                  width: width / 2 + 20,
                  decoration: BoxDecoration(color: color),
                ),
              ),
            ),
            Positioned(
              top: 15.0,
              left: 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CWText(
                    title,
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF).withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  CWText(
                    subTitle,
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF).withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                      fontSize: 19.0,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 15.0,
              right: 20.0,
              child: CWText(
                trailingTitle,
                style: TextStyle(
                  color: const Color(0xFFFFFFFF).withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 14.0,
              right: 14.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    height: 10,
                    color: const Color(0xFFFFFFFF).withOpacity(0.8),
                  ),
                  for (var text in info)
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CWText(
                        text,
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF).withOpacity(0.8),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  for (var text in subInfo)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 6.0, 4),
                      child: CWText(
                        text,
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF).withOpacity(0.8),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
