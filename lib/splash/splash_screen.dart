library splashscreen;
import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iron_trip/dao/splash_dao.dart';
import 'package:iron_trip/model/splash_image_model.dart';

/// Time：2019-12-03 17:49
/// User：IronRen
/// Desc：

class SplashScreen extends StatefulWidget {
  final int seconds; //每隔多少秒计数一次
  final Text title;
  final dynamic navigateAfterSeconds;
  final dynamic onClick;
  final String imageUrl;
  final Text loadingText;
  final bool isTopStyle;

  SplashScreen({
        @required this.seconds,
        @required this.imageUrl,
        this.isTopStyle = true,
        this.onClick,
        this.navigateAfterSeconds,
        this.title = const Text(''),
        this.loadingText  = const Text(""),
      });


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin{
  String _imageUrl = "";
  int _count = 5; //总共多少秒
  bool hasHandleAfterSeconds = false;
  Timer _timer;
//  var size;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
    getSplashImage();
    _timer = Timer.periodic(Duration(seconds: widget.seconds), (timer) {
      print("_count= $_count");
      if(_count == 0){
        afterSeconds();
        _timer.cancel();
        return;
      }
      _count--;
      setState(() {
        _count;
      });
    });
  }

  @override
  void dispose() {
    if (_timer!= null) {
      _timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    size = MediaQuery.of(context).size;
//    print("========> size.width=${size.width},size.height=${size.height}");
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: widget.isTopStyle ? topStyleWidget():bottomStyleWidget(),
    );
  }


  Widget topStyleWidget() {
    return Stack(
      children: <Widget>[
        ExtendedImage.network(
            _imageUrl,
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            fit: BoxFit.fill,
            cache: true,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  _controller.reset();
                  return Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.fill,
                  );
                case LoadState.completed:
                  _controller.forward();
                  return FadeTransition(
                    opacity: _controller,
                    child: ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      width: ScreenUtil.screenWidth,
                      height: ScreenUtil.screenHeight,
                    ),
                  );
                case LoadState.failed:
                  _controller.reset();
                  state.imageProvider.evict();
                  return GestureDetector(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Text(
                            "load image failed, click to reload",
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      state.reLoadImage();
                    },
                  );
              }
              return Container();
            }),
        Positioned(
            right: 16,
            top: 40,
            child: skipView()
        )
      ],
    );
  }

  Widget bottomStyleWidget() {
      return Column(
        children: <Widget>[
          Expanded(
            child:ExtendedImage.network(
              _imageUrl,
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              fit: BoxFit.fill,
              cache: true,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      _controller.reset();
                      return Image.asset(
                        widget.imageUrl,
                        fit: BoxFit.fill,
                      );
                    case LoadState.completed:
                      _controller.forward();
                      return FadeTransition(
                        opacity: _controller,
                        child: ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          width: ScreenUtil.screenWidth,
                          height: ScreenUtil.screenHeight,
                        ),
                      );
                    case LoadState.failed:
                      _controller.reset();
                      state.imageProvider.evict();
                      return GestureDetector(
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              widget.imageUrl,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Text(
                                "load image failed, click to reload",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                  }
                  return Container();
                })
          ),
          Container(
            height: 100,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
              Positioned(
              right: 16,
              top: 40,
                child: skipView()
              )
            ],
            ),
          )
        ]
      );
    }

  Widget skipView() {
    return Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
              child: GestureDetector(
                onTap: (){
                  afterSeconds();
                },
                child: Text('${_count}s跳过',style: TextStyle(color: Colors.white,fontSize: 14),
                )
              )
            );
  }


  afterSeconds() {
    if(!hasHandleAfterSeconds){
      hasHandleAfterSeconds = true;
      if (widget.navigateAfterSeconds is String) {
        // It's fairly safe to assume this is using the in-built material named route component
        Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
      } else if (widget.navigateAfterSeconds is Widget) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => widget.navigateAfterSeconds));
      } else {
        throw new ArgumentError(
            'widget.navigateAfterSeconds must either be a String or Widget'
        );
      }
    }
  }

  void getSplashImage() async{
    SplashImageModel splashImageModel = await SplashDao.getSplashImage();
    if(splashImageModel != null && splashImageModel.images != null && splashImageModel.images.length>0){
      splashImageModel.images[0].url = "https://cn.bing.com"+splashImageModel.images[0].urlbase+"_720x1280.jpg";
      print("======================"+splashImageModel.images[0].url);
      setState(() {
        _imageUrl = splashImageModel.images[0].url;
        print("======================>");
      });
    }
  }

}