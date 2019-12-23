import 'package:flutter/material.dart';
import 'package:iron_trip/model/index_grid_model.dart';
import 'package:iron_trip/widget/webview.dart';

class SalesBox extends StatelessWidget{
  final SalesBoxModel salesBox;

  const SalesBox({Key key, @required this.salesBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: _getItems(context),
    );
  }

  _getItems(BuildContext context) {
    if(salesBox == null){
      return null;
    }
    List<Widget> mlist = [];
    mlist.add(_getMoreWelfare(context,salesBox.icon,salesBox.moreUrl));
    mlist.add(_getDoubleWelfare(context,salesBox.bigCard1,salesBox.bigCard2,true));
    mlist.add(_getDoubleWelfare(context,salesBox.smallCard1,salesBox.smallCard2,false));
    mlist.add(_getDoubleWelfare(context,salesBox.smallCard3,salesBox.smallCard4,false));
    return Column(children: mlist,);
  }

  _getMoreWelfare(BuildContext context,String iconUrl,String url) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(iconUrl,
            width: 72,
            height: 20,
            fit: BoxFit.fill,
          ),
          GestureDetector(
            onTap: (){
              //跳转到web view界面
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  WebView(
                    url: url,
                    title: "更多福利",
                    statusBarColor: 'ffffff',
                    hideAppBar: false,
                  )
              ));
            },
            child:Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient
                    (colors: [Color(0xffef3b39),Color(0xFFFF8A80)]
                  )
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
                child: Text("获取更多福利 >",
                  textAlign: TextAlign.center,//文字居中
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                ) ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDoubleWelfare(BuildContext context, WelfareCard leftCard,
      WelfareCard rightCard, bool isBigCard) {
    return Row(
      children: <Widget>[
        _getSingleWelfare(context,leftCard,true),
        _getSingleWelfare(context,rightCard,false),
      ],
    );
  }

  _getSingleWelfare(BuildContext context, WelfareCard welfareCard,bool isLeftCard) {
    BorderSide borderSide = BorderSide(color: Color(0xffe5e5e5),width: 1) ;
    return Expanded(
      flex: 1,
      child: GestureDetector(
          onTap: (){
            //跳转到web view界面
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                WebView(
                  url: welfareCard.url,
                  title: welfareCard.title,
                  statusBarColor: 'ffffff',
                  hideAppBar: false,
                )
            ));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: borderSide,
                    right: isLeftCard?borderSide:BorderSide.none)
            ),
            child:Image.network(welfareCard.icon,fit: BoxFit.fill,),
          )
      ),
    );
  }

}