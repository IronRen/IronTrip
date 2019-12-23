import 'package:flutter/material.dart';
import 'package:iron_trip/pages/search_page.dart';
import 'package:iron_trip/plugin/asr_manager.dart';

/// Time：2019-09-04 17:47
/// User：IronRen
/// Desc：语音识别

class SpeakPage extends StatefulWidget {
  @override
  SpeakPageState createState() => SpeakPageState();
}

class SpeakPageState extends State<SpeakPage> with SingleTickerProviderStateMixin{
  String speakString = '长按说话';
  String speakRealString = '';
  Animation<double> _animation;
  ///动画控制器
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,
      duration: Duration(milliseconds: 1000),);
    ///初始化动画并在动画结束时候重新执行东环
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn)
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _controller.reverse();///重新开启动画
      }else if(status == AnimationStatus.dismissed){
        _controller.forward();///开始动画
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();///在界面销毁的时候记得把动画管理销毁
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _topView(),
              _bottomView(),
            ],
          ),
        ),
      ),
    );
  }

  _speakStart(){
    print("开始识别===========================");
    _controller.forward();
    setState(() {
      speakString = '识别中~~~';
    });

    AsrManager.start().then((result){
      if(result != null && result.length >0){
        speakRealString = result;
        print("------"+speakRealString);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(keyword: speakRealString,hideLeft: false,)));
      }
    }).catchError((onError){
      print("------"+onError.toString());
    });
  }

  _speakStop(){
    _controller.reset();
    _controller.stop();
    setState(() {
      speakString = '长按说话';
    });
    AsrManager.stop();
  }


  _topView(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text('您可以这样说',
            style: TextStyle(fontSize: 16,
                color: Colors.black54),
          ),
        ),
        Text('东方明珠\n世纪公园\n上海科技馆',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15,color: Colors.black45),
        ),
        Padding(padding: EdgeInsets.all(30),
        child: Text(speakRealString,
          style: TextStyle(color: Colors.blue,fontSize: 15),
        ),
        )
      ],
    );
  }


  _bottomView(){
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e){
              _speakStart();
            },
            onTapUp: (e){
              _speakStop();
            },
            onTapCancel:(){
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(speakString,
                      style: TextStyle(fontSize: 12,color: Colors.blue),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      /// 添加一个占位符 防止长按说话按钮动画改变导致上面文字位置改变
                      Container(
                        width: MIC_SIZE,
                        height: MIC_SIZE,
                      ),
                      Center(
                        child: AnimateMic(
                          animation: _animation,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(right: 0,bottom: 20,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.close,size: 30,color: Colors.grey,),
            ),
          )
        ],
      ),
    );
  }
}





const double MIC_SIZE = 80;

///创建一个语音动画按钮
class AnimateMic extends AnimatedWidget{
  ///补间动画 大小从80到60
  static final _opacityTween = Tween<double>(begin: 1,end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE,end: MIC_SIZE -20);


  AnimateMic({Key key,Animation<double> animation})
      :super(key:key,listenable:animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(MIC_SIZE/2)
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,),
      ),
    );
  }

}