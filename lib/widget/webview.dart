import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS =['m.ctrip.com/html5/','m.ctrip.com/webapp/you/'];

class WebView extends StatefulWidget{
  final String title; //头部标题
  final String url;//加载链接
  final String statusBarColor;//状态栏颜色
  final bool hideAppBar;//是否隐藏AppBar
  final bool canNotBack;// 禁止返回

  const WebView({
    Key key,
    this.title,
    @required this.url,
    this.statusBarColor,
    this.hideAppBar,
    this.canNotBack = false})
      :super(key:key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView>{
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onChangeUrl;
  StreamSubscription<WebViewStateChanged> _onSateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false; //web view是否正在退出



  @override
  void initState() {
    super.initState();
    //防止页面重新打开，初始化关闭webview
    webViewReference.close();
    //监听页面 加载url改变的时候,此处返回的是一个 订阅流 所以要对返回做处理，防止内存泄露
    _onChangeUrl = webViewReference.onUrlChanged.listen((String url){

    });
    //监听页面状态的变化
    _onSateChanged = webViewReference.onStateChanged.listen((WebViewStateChanged state){
      switch(state.type){
        case WebViewState.startLoad:
          print("state.url=${state.url}");
          if(_isDestroyWebView(state.url) && !exiting){
            if(widget.canNotBack){
              webViewReference.launch(widget.url);
            }else{
              Navigator.pop(context);//返回上一页
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    //对页面加载错误进行监听
    _onHttpError = webViewReference.onHttpError.listen((WebViewHttpError error){

    });
  }

  //判断当前链接是不是携程的链接 此处只是做一个拦截
  _isDestroyWebView(String url){
    bool containCtrip = false;
    for(final value in CATCH_URLS){
      if(url?.endsWith(value)??false){ //如果url为null,则给整个bool表达式赋值false
        containCtrip = true;
        break;
      }
    }
    return containCtrip;
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColor = widget.statusBarColor??"ffffff";
    Color backButtonColor;
    if(statusBarColor == "ffffff"){
      backButtonColor = Colors.black;
    }else{
      backButtonColor = Colors.white;
    }
    return Scaffold(body: Column(
      children: <Widget>[
        _appBar(Color(int.parse('0xff'+statusBarColor)),backButtonColor),

        Expanded(//撑满剩余的屏幕
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,//是否可以缩放
              hidden: true,//默认是否隐藏
              withLocalStorage: true,//是否使用本地缓存
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text("正在加载中...",style: TextStyle(color: Colors.green),),
                ),
              ),
            )
        ),
      ],
    ),);
  }

  @override
  void dispose() {
    //把之前事件监听的订阅流取消掉
    _onChangeUrl.cancel();
    _onSateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  //自定义appBar
  Widget _appBar(Color backgroundColor, Color backButtonColor) {
    if(widget.hideAppBar??false){
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox( //作用是撑满整个父布局
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),//只设置一个方向的边距
                child: Icon(
                  Icons.close,
                  size: 26,
                  color: backButtonColor,
                ),
              ),
              onTap:(){
                Navigator.pop(context);
              },
            ),
            Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                      widget.title??'',
                      style: TextStyle(color: backButtonColor,fontSize: 20),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

}