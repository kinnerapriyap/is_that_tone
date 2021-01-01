import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.green,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
);

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndex<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }

  void forEachIndex(void f(E e, int i)) {
    var i = 0;
    this.forEach((e) => f(e, i++));
  }
}
