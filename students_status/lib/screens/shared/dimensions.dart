import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class Dimensions {
  // final double _screenHeight = Get.context!.height;
  // final double _screenWidth = Get.context!.width;

  final BuildContext context;
  double _screenWidth = 0;
  double _screenHeight = 0;

  Dimensions(this.context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  double height(double x) {
    return _screenHeight / (812 / x);
  }

  double width(double x) {
    return _screenWidth / (375 / x);
  }

  double vertical(double x) {
    return _screenHeight / (812 / x);
  }

  double horizontal(double x) {
    return _screenWidth / (375 / x);
  }

  double fontSize(double x) {
    return _screenHeight / (812 / x);
  }
}
