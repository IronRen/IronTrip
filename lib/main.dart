import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_trip/model/city_model.dart';
import 'package:iron_trip/navigator/main_tab_navigators.dart';
import 'package:iron_trip/plugin/location_manager.dart';
import 'package:iron_trip/splash/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final CityModel cityModel = new CityModel();

  @override
  _MyAppState createState() =>_MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    //ScopedModel必须在顶层
    return ScopedModel<CityModel>(
        model: widget.cityModel,
        child: MaterialApp(
          title: '仿携程',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(
              seconds: 1,
              isTopStyle:true,
              navigateAfterSeconds: new AfterSplash(),
              imageUrl: 'images/bg_splash.png',
              onClick: ()=>print("我点击了"),
          ),
        ));
  }

  @override
  void initState() {
    ///设置百度Ak
    LocationManager.setAk("GvHIlLwcOd5ZTSNZLQxTH7Mmef3dbtWG");
    loadLocation(widget.cityModel);
    super.initState();
  }

  Future<BaiduLocation> loadLocation(CityModel cityModel) async {
    BaiduLocation location = await LocationManager.getLocation();
    cityModel.refreshCity(location.city??"北京市",
        (location != null && location.city != null && location.city.isNotEmpty)?location.longitude:116.46,
        (location != null && location.city != null && location.city.isNotEmpty)?location.latitude:39.92);
    print("定位="+cityModel.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cityLocation', jsonEncode(cityModel.toJson()));
    return location;
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainNavigator();
  }
}