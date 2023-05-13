import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static var screenWidth;
  static var screenHeight;
  static var blockSizeHorizontal;
  static var blockSizeVertical;
  static var _safeAreaHorizontal;
  static var _safeAreaVertical;
  static var safeBlockHorizontal;
  static var safeBlockVertical;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth/100;
    blockSizeVertical = screenHeight/100;
    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal)/100;
    safeBlockVertical = (screenHeight - _safeAreaVertical)/100;
  }
}