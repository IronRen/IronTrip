import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iron_trip/model/index_grid_model.dart';
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao{
  //获取首页数据
  static Future<HomePageModel> getHomePageData() async{
    var response = await http.get(HOME_URL);
    if(response.statusCode == 200){
      Utf8Decoder utf8decoder = Utf8Decoder();//修复返回json中的中文字符串乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomePageModel.fromJson(result);
    }else{
      throw Exception('加载数据失败');
    }
  }
}