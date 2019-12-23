import 'dart:convert';

import 'package:iron_trip/model/travel_model.dart';
import 'package:http/http.dart' as http;

/// Time：2019-11-07 14:03
/// User：IronRen
/// Desc：

const TRAVEL_URL ='https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031010211161114530&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelDao {

  static Future<TravelModel> getTravels(String url,String groupChannelCode,int pageIndex,Map params,int type,
      int pageSize) async {
    Map paramsMap = params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    params['groupChannelCode'] = groupChannelCode;
    params['type'] = type;
    print("请求参数："+jsonEncode(params));
    var response = await http.post(url,body:jsonEncode(params));
    if(response.statusCode == 200){
      Utf8Decoder utf8decoder = Utf8Decoder();
      print(utf8decoder.convert(response.bodyBytes));
      var travels = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(travels);
    }else{
      throw Exception("获取当前标签旅行记录错误");
    }
  }
}