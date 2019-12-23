import 'package:flutter/material.dart';
import 'package:iron_trip/widget/webview.dart';

class MyPage extends StatefulWidget{
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebView(url: "https://m.ctrip.com/webapp/myctrip",
          statusBarColor: "4c5bca",
          hideAppBar: true,
          canNotBack: true,
        ),
      ),
    );
  }
}