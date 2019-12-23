import 'package:azlistview/azlistview.dart';

/// Time：2019-12-05 17:20
/// User：IronRen
/// Desc：城市

class CityInfo extends ISuspensionBean{
  String name;
  String tagIndex;
  String namePinyin;
  String log;
  String lat;

  @override
  String getSuspensionTag() => tagIndex;

  CityInfo({this.name, this.log, this.lat});

  CityInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    log = json['log'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['log'] = this.log;
    data['lat'] = this.lat;
    data['tagIndex'] = this.tagIndex;
    data['namePinyin'] = this.namePinyin;
    data['isShowSuspension'] = this.isShowSuspension;
    return data;
  }

  @override
  String toString() {
    return 'CityInfo{name: $name, tagIndex: $tagIndex, namePinyin: $namePinyin, log: $log, lat: $lat}';
  }

}