import 'dart:ui';
import 'package:flutter/widgets.dart';

extension SizeContextExtention on BuildContext {
  static const double figmaHeight = 812;
  static const double figmaWidth = 375;

  double h(num height) => height * MediaQuery.of(this).size.height / figmaHeight;
  double w(num width) => width * MediaQuery.of(this).size.width / figmaWidth;
  double r(num radius) => radius * MediaQuery.of(this).size.width / figmaWidth;
  double sp(num fontSize) => fontSize * MediaQuery.of(this).size.width / figmaWidth;
}

extension SizeNumExtention on num {
  static double get _screenWidth {
    try {
      return MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.width;
    } catch (_) {
      return SizeContextExtention.figmaWidth;
    }
  }

  static double get _screenHeight {
    try {
      return MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.height;
    } catch (_) {
      return SizeContextExtention.figmaHeight;
    }
  }

  double get h => this * (_screenHeight <= 0 ? SizeContextExtention.figmaHeight : _screenHeight) / SizeContextExtention.figmaHeight;
  double get w => this * (_screenWidth <= 0 ? SizeContextExtention.figmaWidth : _screenWidth) / SizeContextExtention.figmaWidth;
  double get r => this * (_screenWidth <= 0 ? SizeContextExtention.figmaWidth : _screenWidth) / SizeContextExtention.figmaWidth;
  double get sp => this * (_screenWidth <= 0 ? SizeContextExtention.figmaWidth : _screenWidth) / SizeContextExtention.figmaWidth;

  double get sh => this * (_screenHeight <= 0 ? SizeContextExtention.figmaHeight : _screenHeight);
  double get sw => this * (_screenWidth <= 0 ? SizeContextExtention.figmaWidth : _screenWidth);
}
