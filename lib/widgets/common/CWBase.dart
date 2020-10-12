import 'package:flutter/material.dart';

mixin CWBase<T> {
  T copy(controller);
  dynamic createController();
  get id;
}
