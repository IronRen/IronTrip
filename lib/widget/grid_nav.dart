
import 'package:flutter/material.dart';
import 'package:iron_trip/model/index_grid_model.dart';
import 'package:iron_trip/widget/webview.dart';

class GridNav extends StatelessWidget{
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return PhysicalModel(//整体设置背景样式等，此处如果使用Container则不会起作用，
      // 因为子view的背景将装饰器的背景盖住了 可以理解成视图层不一样
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.antiAlias, //裁切并且抗锯齿，不设圆角无法显示
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _getItems(context),
      ),
    );
  }

  //获取一行Widget的集合
  List<Widget> _getItems(BuildContext context) {
    List<Widget> items = [];
    if(gridNavModel == null){
      return items;
    }
    if(gridNavModel.hotel != null){
      items.add(_getItem(context, gridNavModel.hotel, true));
    }
    if(gridNavModel.flight != null){
      items.add(_getItem(context, gridNavModel.flight, false));
    }
    if(gridNavModel.travel != null){
      items.add(_getItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  //获取每一行的Widget集合
  _getItem(BuildContext context,GridNavItem gridNavItem,bool isFirst){
    List<Widget> items = [];
    items.add(Expanded(child: _getMainItem(context,gridNavItem.mainItem),flex: 1,));
    items.add(Expanded(child:_getDoubleItem(context, gridNavItem.item1, gridNavItem.item2, true),flex: 1,));
    items.add(Expanded(child:_getDoubleItem(context, gridNavItem.item3, gridNavItem.item4, false),flex: 1,));
    Color startColor = Color(int.parse('0xff'+gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff'+gridNavItem.endColor));

    return Container(
      height: 100,
      margin: isFirst?null:EdgeInsets.only(top: 3),
      decoration: BoxDecoration(//对整行设置渐变色
        gradient: LinearGradient(colors: [startColor,endColor]),
      ),
      child: Row(
        children: items,
      ),
    );
  }

  _getMainItem(BuildContext context,Item item){
    return GestureDetector(
      onTap: (){
        //跳转到web view界面
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            WebView(url: item.url,
              title: item.title,
              statusBarColor: item.statusBarColor,
              hideAppBar: item.hideAppBar,)
        ));
      },
      child: Stack(
        children: <Widget>[
          Image.network(
            item.icon,
            fit: BoxFit.fitWidth,
            height: 100,
            alignment: AlignmentDirectional.bottomCenter,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            child: Text(
              item.title,
              style: TextStyle(color: Colors.white,fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  //两个叠加的Widget
  _getDoubleItem(BuildContext context,Item topItem,Item bottomItem,bool isCenterItem){
    return Column(
      children: <Widget>[
        Expanded(child: _item(context,topItem,isCenterItem,true),flex: 1,),
        Expanded(child: _item(context,bottomItem,isCenterItem,false),flex: 1,),
      ],
    );
  }

  _item(BuildContext context,Item item,bool isCenterItem,bool isTop){
    BorderSide borderSide = BorderSide(color: Colors.white,width: 0.5);
    return _ItemGesture(context,item,
      FractionallySizedBox(//作用是撑满整个父布局
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: isTop?borderSide:BorderSide.none,
            ),
          ),
          child: Center(
            child: Text(
            item.title,
            textAlign: TextAlign.center,//文字居中
            style: TextStyle(
                color: Colors.white,
                fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  _ItemGesture(BuildContext context,Item item,Widget widget){
    return GestureDetector(
      onTap: (){
        //跳转到web view界面
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            WebView(url: item.url,
              title: item.title,
              statusBarColor: item.statusBarColor,
              hideAppBar: item.hideAppBar,
            )
        ));
      },
      child: widget,
    );
  }
}