import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iron_trip/model/search_model.dart';
const SEARCH_URL = "https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=";

class SearchDao{
  //获取首页数据
  static Future<SearchModel> getSearchData(String searchWords) async{
    var response = await http.get(SEARCH_URL+searchWords);
    if(response.statusCode == 200){
      Utf8Decoder utf8decoder = Utf8Decoder();//修复返回json中的中文字符串乱码
      print("response = "+utf8decoder.convert(response.bodyBytes));
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      SearchModel searchModel = SearchModel.fromJson(result);
      searchModel.searchWords = searchWords;
      print("result.toString()="+result.toString());
      return searchModel;
    }else{
      throw Exception('加载数据失败');
    }
  }
}