
import 'package:flutter/material.dart';
import 'package:iron_trip/model/index_grid_model.dart';
import 'package:iron_trip/widget/webview.dart';

///五个图标
class LocalNav extends StatelessWidget{
  final List<LocalNavList> finalList;

  const LocalNav({Key key, @required this.finalList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //装饰器在此处 处理背景是往装饰器里面塞Widget 视图层包含所有子view，和GridNav中设置背景不一样
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),//整体圆角
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child:_items(context),//所有子控件 5个
      ),
    );
  }

  //构建5个按钮
  _items(BuildContext context) {
    if(finalList == null) return null;
    List<Widget> items = [];
    //5个按钮
    finalList.forEach((model){items.add(_item(context,model));});
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, LocalNavList model) {
    return GestureDetector(
      onTap: (){//点击事件的处理
        //跳转到web view界面
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            WebView(
              url: model.url,
              title: model.title,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
            )
        ));
      },
      child: Column(
        children: <Widget>[
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child:Text(model.title,style: TextStyle(fontSize: 12),)
        ),],
      ),
    );
  }

}