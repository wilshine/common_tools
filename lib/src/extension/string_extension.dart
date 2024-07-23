import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/issues/18761
extension StringExt on String {

  String get overflow => Characters(this).replaceAll(Characters(''), Characters('\u{200B}')).toString();


  String args([List<String> args = const []]) {
    String key = this;
    if (args.isNotEmpty) {
      for (final arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }

}