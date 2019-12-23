import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_trip/model/city_info.dart';
import 'package:iron_trip/model/city_model.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:scoped_model/scoped_model.dart';

/// Time：2019-12-05 16:27
/// User：IronRen
/// Desc：城市选择

class CitySelect extends StatefulWidget {

  @override
  _CitySelectState createState() => _CitySelectState();
}

class _CitySelectState extends State<StatefulWidget>{
  List<CityInfo> _cityList = List();


  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text("城市选择"),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              title: Text("定位城市"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.location_on,size: 24,),
                  new ScopedModelDescendant(builder: (BuildContext context, Widget child, CityModel cityModel){
                    return Text(cityModel.name??"北京市");
                  }),
                ],
              ),
            ),
            Divider(height: 1,),
            Expanded(
              flex: 1,
              child: AzListView(
                data: _cityList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                header: AzListViewHeader(
                    tag: "★",
                    height: 140,
                    builder: (context) {
                      return _buildHeader();
                    }),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child: Text(hint,
                        style: TextStyle(color: Colors.white, fontSize: 30.0)),
                  );}
                  )
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadAllCities();
  }

  void loadAllCities() async{
    try{
      var cityData = await rootBundle.loadString('assets/cities.json');
      List cityList = json.decode(cityData);
      cityList.forEach((city){
        _cityList.add(CityInfo(name: city['name'],log:city['log'],lat: city['lat']));
      });
      List<CityInfo> cities = sortCityList(_cityList);
      setState(() {
        _cityList = cities;
      });
      print("cities.length="+(cities.length.toString()));
    }catch (e){
      print(e.toString());
    }
  }

  ///将城市根据第一个汉字转换成拼音 按照26字母排序
  List<CityInfo> sortCityList(List<CityInfo> cityList) {
    List<CityInfo> sortList = [];
    if(cityList == null || cityList.length == 0){
      return sortList;
    }
    for (var i = 0; i < cityList.length; ++i) {
      var city = cityList[i];
      String firstWordPinyin = PinyinHelper.getFirstWordPinyin(city.name);
      String tag = firstWordPinyin.substring(0,1).toUpperCase();
      city.namePinyin = firstWordPinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        city.tagIndex = tag;
      } else {
        city.tagIndex = "#";
      }
      sortList.add(city);
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(sortList);
    return sortList;
  }

  _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              print("OnItemClick: $model");
              Navigator.pop(context, model);
            },
          ),
        )
      ],
    );
  }

  _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "热门城市" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }


  void _onSusTagChanged(String value) {
    setState(() {
      _suspensionTag = value;
    });
  }

  Widget _buildHeader() {
    List<CityInfo> hotCityList = List();
    hotCityList.addAll([
      CityInfo(name: "北京市",log: "116.46",lat: "39.92"),
      CityInfo(name: "上海市",log: "121.48",lat: "31.22"),
      CityInfo(name: "广州市",log: "113.23",lat: "23.16"),
      CityInfo(name: "深圳市",log: "114.07",lat: "22.62"),
      CityInfo(name: "杭州市",log: "120.19",lat: "30.26"),
      CityInfo(name: "成都市",log: "104.06",lat: "30.67"),
    ]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 10.0,
        children: hotCityList.map((model) {
          return OutlineButton(
            borderSide: BorderSide(color: Colors.grey[300], width: .5),
            child: Text(model.name),
            onPressed: () {
              print("OnItemClick: $model");
              Navigator.pop(context, model);
            },
          );
        }).toList(),
      ),
    );
  }
}

