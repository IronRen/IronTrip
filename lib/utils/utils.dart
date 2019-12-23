import 'package:flutter/material.dart';

/// Time：2019-12-09 15:29
/// User：IronRen
/// Desc：

class Utils {

  static jumpToPage(BuildContext context,Widget page) async{
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    return result;
  }
}