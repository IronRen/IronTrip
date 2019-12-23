
import 'package:flutter/services.dart';

/// Time：2019-09-03 23:01
/// User：IronRen
/// Desc：dart端对原生的接口调用

class AsrManager {
  static const MethodChannel _channel = const
      MethodChannel('asr_plugin');

  ///开始录音
  static Future<String> start({Map params}) async{
    return await _channel.invokeMethod('start',params??{});
  }

  ///停止录音
  static Future<String> stop({Map params}) async{
    return await _channel.invokeMethod('stop');
  }

  ///取消录音
  static Future<String> cancel({Map params}) async{
    return await _channel.invokeMethod('cancel');
  }

}