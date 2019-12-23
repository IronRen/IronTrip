import 'dart:convert';

import 'package:iron_trip/model/splash_image_model.dart';
import 'package:http/http.dart' as http;

/// Time：2019-12-17 13:11
/// User：IronRen
/// Desc：获取启动页数据（每日一图）

const SPLASH_IMAGE_URL = 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1';

class SplashDao{

  static Future<SplashImageModel> getSplashImage() async{
    var response = await http.get(SPLASH_IMAGE_URL);
    if(response.statusCode == 200){
      Utf8Decoder utf8decoder = new Utf8Decoder();
      var decode = json.decode(utf8decoder.convert(response.bodyBytes));
      var splashImageModel = SplashImageModel.fromJson(decode);
      return splashImageModel;
    } else {
      throw Exception("数据获取失败");
    }
  }
}