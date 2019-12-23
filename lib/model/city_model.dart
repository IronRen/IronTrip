import 'package:scoped_model/scoped_model.dart';

/// Time：2019-12-11 15:13
/// User：IronRen
/// Desc：

class CityModel extends Model {
  String _sName;
  double _dLog;
  double _dLat;

  CityModel({String sName, double dLog, double dLat}) {
    this._sName = sName;
    this._dLog = dLog;
    this._dLat = dLat;
  }

  String get name => _sName;
  set sName(String sName) => _sName = sName;
  double get log => _dLog;
  set dLog(double dLog) => _dLog = dLog;
  double get lat => _dLat;
  set dLat(double dLat) => _dLat = dLat;

  CityModel.fromJson(Map<String, dynamic> json) {
    _sName = json['_name'];
    _dLog = json['_log'];
    _dLat = json['_lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_name'] = this._sName;
    data['_log'] = this._dLog;
    data['_lat'] = this._dLat;
    return data;
  }

  void refreshCity(String name, double log, double lat){
    _dLog = log;
    _dLat = lat;
    _sName = name;
    notifyListeners();
  }
  @override
  String toString() {
    return 'CityModel{_name: $_sName, _log: $_dLog, _lat: $_dLat}';
  }
}