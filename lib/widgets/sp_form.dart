import 'package:flutter/material.dart';

class SPForm extends StatefulWidget {
  final Widget child;

  const SPForm({super.key, required this.child});

  @override
  SPFormState createState() => SPFormState();

  static SPFormState of(BuildContext context) {
    return context.findAncestorStateOfType<SPFormState>()!;
  }
}

class SPFormState extends State<SPForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: widget.child,
    );
  }
}
