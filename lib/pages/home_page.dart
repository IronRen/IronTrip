
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iron_trip/dao/home_dao.dart';
import 'package:iron_trip/model/city_info.dart';
import 'package:iron_trip/model/index_grid_model.dart';
import 'package:iron_trip/pages/city_select_page.dart';
import 'package:iron_trip/pages/search_page.dart';
import 'package:iron_trip/pages/speak_page.dart';
import 'package:iron_trip/utils/utils.dart';
import 'package:iron_trip/widget/grid_nav.dart';
import 'package:iron_trip/widget/loading_container.dart';
import 'package:iron_trip/widget/local_nav.dart';
import 'package:iron_trip/widget/sales_box.dart';
import 'package:iron_trip/widget/status_bar.dart';
import 'package:iron_trip/widget/sub_nav.dart';
import 'package:iron_trip/widget/webview.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:iron_trip/model/city_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appBarScrollOffset = 160;//界面滚动超过160时候 顶部appBar就会隐藏

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  List<LocalNavList> mLocalList = [];//五个按钮
  List<BannerList> mBannerList = [];//banner
  GridNavModel mGridNav;//宫格 酒店机票旅行
  List<SubNavList> mSubNavList = [];//两行 话费 签证 旅游卡等
  SalesBoxModel mSalesBox;// 底部热门活动模块
  bool isLoading = true; //网络是否加载
  double _appBarOpacity = 0; //appBar 的不透明度
  String _locationCity;
  CityModel _cityModel;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: isLoading,
        cover: false,
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    NotificationListener(
                        onNotification:(scrollNotification){
                          if(scrollNotification is ScrollUpdateNotification
                              && scrollNotification.depth == 0){
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                          return false;
                        } ,//对当前Widget事件中的滚动事件进行监听，scrollNotification.depth == 0
                        // 做了这个判断是指只对Widget本身的事件进行处理 不处理子Widget的事件
                        child: _listView
                    ),
                    _appBar,
                  ],
                ),
                onRefresh: loadHomeData)
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadHomeData();
    loadLocation();
  }

  //获取首页数据
  Future<Null> loadHomeData() async {
    try{
      HomePageModel homePageData = await HomeDao.getHomePageData();
      setState(() {
        mLocalList = homePageData.localNavList;
        mBannerList = homePageData.bannerList;
        mGridNav = homePageData.gridNav;
        mSubNavList = homePageData.subNavList;
        mSalesBox = homePageData.salesBox;
        isLoading = false;
      });
    }catch(e){
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  //根据滑动距离来计算appBar透明度的展示
  _onScroll(double scrollPx){
    double opacity = scrollPx / appBarScrollOffset;
    if(opacity < 0){
      opacity  = 0;
    }else if(opacity > 1){
      opacity = 1;
    }
    setState(() {
      _appBarOpacity = opacity;
    });
  }

  Widget get _listView{
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(6, 6, 6, 6), //当前view设置距离父布局的距离 即margin
          child: LocalNav(finalList: mLocalList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: GridNav(gridNavModel: mGridNav),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: SubNav(subNavList:mSubNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: SalesBox(salesBox:mSalesBox),
        ),
      ],
    );
  }

  Widget get _banner{
    return Container(
        height: 180,
        child:Swiper(
          itemCount: mBannerList.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){//跳转到web view界面
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    WebView(url: mBannerList[index].url,hideAppBar: false,)
                ));},
              child: Image.network(
                mBannerList[index].icon,
                fit: BoxFit.fill,
              ),
            );
          },
          pagination: SwiperPagination(),//指示器
        )
    );
  }

  Widget get _appBar{
    return new ScopedModelDescendant<CityModel>(
        builder: (BuildContext context, Widget child, CityModel cityModel){
          if(cityModel != null){
            _cityModel = cityModel;
            _locationCity = _cityModel.name;
          }
          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  //整个appbar背景色与界面滑动距离相关 颜色渐变
                  gradient: LinearGradient(
                      colors: [Color(0x66000000),Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Color.fromARGB((_appBarOpacity * 255).toInt(), 255, 255, 255)
                  ),
                  child:SearchBar(
                    searchBarType: _appBarOpacity > 0.2
                        ?SearchBarType.homeLight
                        :SearchBarType.home,
                    inputButtonClick: _jumpToSearchPage,
                    speakButtonClick: _jumpToSpeakPage,
                    defaultText: "上海攻略·游记·精选酒店",
                    leftButtonClick: (){
                      jumpToCitySelect();
                    },
                    locationCity: _locationCity??"北京市",
                  ),
                ),
              ),

              Container(
                height: _appBarOpacity>0.2 ? 0.5 : 0,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]
                ),
              )
            ],
          );
        }
    );
  }

  jumpToCitySelect() async{
    CityInfo jumpToPage = await Utils.jumpToPage(context, CitySelect());
    setState(() {
      _cityModel.refreshCity(jumpToPage.name, double.parse(jumpToPage.log), double.parse(jumpToPage.lat));
      print(_cityModel.toString());
      _locationCity = jumpToPage.name;
    });
  }


  _jumpToSearchPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchPage(hideLeft: false,)));
  }

  _jumpToSpeakPage() {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => SpeakPage())
    );
  }

  Future loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cityLocation = prefs.get('cityLocation');
    if(cityLocation != null && cityLocation.isNotEmpty){
      CityModel cityModel = CityModel.fromJson(jsonDecode(cityLocation));
      print('cityModel.name=${cityModel.name}');
      if(cityModel != null){
        _cityModel = cityModel;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}