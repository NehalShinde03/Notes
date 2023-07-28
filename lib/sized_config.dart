//this file is calculate mobile width and height

import 'package:flutter/material.dart';

class Sized_Config{

  static late double _width;
  static late double _height;

  static double _vertical=0;
  static double _horizontal=0;

  static late double txtAdjust;
  static late double imgAdjust;
  static late double heightAdjust;
  static late double widthAdjust;

  void init(BoxConstraints constraints, Orientation orientation){

    if(orientation==Orientation.portrait){
      _width=constraints.maxWidth;
      _height=constraints.maxHeight;
    }
    else{
      _width=constraints.maxHeight;
      _height=constraints.maxWidth;
    }

    _vertical=_height/100;
    _horizontal=_width/100;

    txtAdjust=_vertical;
    imgAdjust=_horizontal;
    heightAdjust=_vertical;
    widthAdjust=_horizontal;
  }

}