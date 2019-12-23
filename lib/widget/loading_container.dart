import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget{
  final Widget child; //不在loading状态下界面展示的内容
  final bool isLoading; //是否在加载中
  final bool cover; // 当前loading view是否展示在loading之上

  const LoadingContainer({Key key,
    @required this.isLoading,
    this.cover = false,
    @required this.child}
    ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //多层三级表达式是最前的？和最后的：对应
    return !cover ? !isLoading ? child : _loadingView :
      Stack(
        children: <Widget>[
          child,
          isLoading?_loadingView:Container(),
        ],
      );
  }

  Widget get _loadingView{
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}