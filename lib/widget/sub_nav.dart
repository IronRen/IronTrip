import 'package:flutter/material.dart';
import 'package:iron_trip/model/index_grid_model.dart';
import 'package:iron_trip/widget/webview.dart';

class SubNav extends StatelessWidget{
  final List<SubNavList> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: _getItems(context),
      )
    );
  }

  _getItems(BuildContext context) {
    if(subNavList == null){
      return null;
    }
    int countPerLine = (subNavList.length/2 +0.5).toInt();
    List<SubNavList> firstList = subNavList.sublist(0,countPerLine);
    List<SubNavList> secondList = subNavList.sublist(countPerLine,subNavList.length);

    return Column(
      children: <Widget>[
        _getRowWidget(context, firstList),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: _getRowWidget(context, secondList),
        )
      ],
    );
  }


  _getRowWidget(BuildContext context,List<SubNavList> list){
    List<Widget> rowWidgets = [];
    list.forEach((subNav){
      rowWidgets.add(_getItem(context, subNav));
    });
    return Row(
      children: rowWidgets,
    );
  }


  _getItem(BuildContext context,SubNavList item){
    return Expanded(
      flex: 1,
      child: GestureDetector(
      onTap: (){
        //跳转到web view界面
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            WebView(
              url: item.url,
              title: item.title,
              hideAppBar: item.hideAppBar,
            )
        ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(item.icon,width: 20,height: 20,fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              item.title,
              style: TextStyle(color: Colors.black54,fontSize: 12),
            ),
          )
        ],
      ),
    ),
    );
  }

}