import 'package:flutter/material.dart';

class Shared {
  static late Shared instance;
  late final context;

  Shared.init(context) {
    this.context = context;
    instance = this;
  }

  Size getSize() {
    return MediaQuery.of(this.context).size;
  }

  ThemeData getTheme() {
    return Theme.of(this.context);
  }
}
