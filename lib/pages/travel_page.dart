import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iron_trip/dao/travel_tabs_dao.dart';
import 'package:iron_trip/model/city_model.dart';
import 'package:iron_trip/model/travel_tabs_model.dart';
import 'package:iron_trip/pages/travel_item_page.dart';
import 'package:scoped_model/scoped_model.dart';

class TravelPage extends StatefulWidget{
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin{
  TabController tabController;
  TravelTabsModel travelTabsModel;
  List<TravelTab> travelModels = [];
  CityModel _cityModel;

  @override
  void initState() {
    tabController = TabController(length: travelModels.length, vsync: this);
    _getTravelTabs();
    super.initState();
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ScopedModelDescendant(builder: (BuildContext context,Widget widget,CityModel cityModel){
        _cityModel = cityModel;
        print("===="+cityModel.toString());
        return Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 30),
              child: TabBar(
                controller: tabController,
                labelColor: Colors.black54,
                isScrollable: true,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff1fcfbb),width: 3),
                  insets: EdgeInsets.only(bottom: 8),
                ),
                tabs: travelModels.map<Tab>((TravelTab travelTab){
                        return Tab(text: travelTab.labelName,);
                      }).toList()
              ),
            ),
            Flexible(child: TabBarView(
              controller: tabController,
              children: travelModels.map((TravelTab travelTab){
                return TravelItemPage(
                    params:travelTabsModel.params,
                    type:travelTab.type,
                    requestUrl:travelTabsModel.url,
                    groupChannelCode:travelTab.groupChannelCode);
              }).toList())
            )
          ],
        );
        })
    );

  }

  void _getTravelTabs() async{
    TravelTabsModel tabsModel = await TravelTabsDao.getTravelTabs();
    tabController = TabController(length: tabsModel.tabs.length, vsync: this);
    setState(() {
      travelTabsModel = tabsModel;
      print("原始parmas："+jsonEncode(travelTabsModel.params));
      if(_cityModel != null && _cityModel.name.isNotEmpty){
        travelTabsModel.params['lat'] = _cityModel.lat;
        travelTabsModel.params['lon'] =  _cityModel.log;
      }
      print("改过parmas："+jsonEncode(travelTabsModel.params));
      travelModels = tabsModel.tabs;
    });
  }
}