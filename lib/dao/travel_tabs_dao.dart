import 'dart:convert';

import 'package:iron_trip/model/travel_tabs_model.dart';
import 'package:http/http.dart' as http;

/// Time：2019-11-07 00:19
/// User：IronRen
/// Desc：

const TRAVEL_TABS = 'https://apk-1256738511.file.myqcloud.com/FlutterTrip/data/travel_page.json';

class TravelTabsDao {

  static Future<TravelTabsModel> getTravelTabs() async {
    var response = await http.get(TRAVEL_TABS);
    if(response.statusCode == 200){
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      TravelTabsModel travelTabsModel = TravelTabsModel.fromJson(result);
      return travelTabsModel;
    }else{
      throw Exception("数据获取失败");
    }
  }
}