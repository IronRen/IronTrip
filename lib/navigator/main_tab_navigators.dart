import 'package:flutter/material.dart';
import 'package:iron_trip/pages/home_page.dart';
import 'package:iron_trip/pages/my_page.dart';
import 'package:iron_trip/pages/search_page.dart';
import 'package:iron_trip/pages/travel_page.dart';
import 'package:iron_trip/plugin/location_manager.dart';

class MainNavigator extends StatefulWidget{
  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}


// 一般表示内部类用 _开始命名
class _MainNavigatorState extends State<MainNavigator> with AutomaticKeepAliveClientMixin{
   final PageController _controller = PageController(
     initialPage: 0,
   );
   final _defaultColor = Colors.grey;
   final _activeColor = Colors.blue;
   var _currentActivePosition = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    Scaffold 可以作为根节点
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[ //显示的页面
          HomePage(),
          SearchPage(hideLeft: true,),
          TravelPage(),
          MyPage(),
        ],
        physics: NeverScrollableScrollPhysics(),//不允许手动滑动pagerView 防止和旅拍页面滑动冲突
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentActivePosition,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,color: _defaultColor,),
              activeIcon: Icon(Icons.home,color: _activeColor,),
              title: Text('首页',style: TextStyle(
                color: _currentActivePosition != 0 ? _defaultColor:_activeColor,
                ),
              )
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,color: _defaultColor,),
                activeIcon: Icon(Icons.search,color: _activeColor,),
                title: Text('搜索',style: TextStyle(
                  color: _currentActivePosition != 1 ? _defaultColor:_activeColor,
                ),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt,color: _defaultColor,),
                activeIcon: Icon(Icons.camera_alt,color: _activeColor,),
                title: Text('旅拍',style: TextStyle(
                  color: _currentActivePosition != 2?_defaultColor:_activeColor,
                ),
                )
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle,color: _defaultColor,),
                activeIcon: Icon(Icons.account_circle,color: _activeColor,),
                title: Text('我的',style: TextStyle(
                  color: _currentActivePosition != 3 ? _defaultColor:_activeColor,
                ),
                )
            ),
          ],
          onTap: (position){
            _controller.jumpToPage(position);
            setState(() {
              _currentActivePosition = position;
            });
          },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }
}