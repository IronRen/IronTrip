import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///自定义状态栏 本项目主要由三种状态栏
///normal 是搜索tab 顶部搜索框 home和homeLight是首页顶部搜索框
enum SearchBarType{home,normal,homeLight}

class SearchBar extends StatefulWidget{
  final bool enabled;//状态栏是否可以点击
  final bool hideLeft;//左边的地址定位是否隐藏
  final SearchBarType searchBarType;//搜索状态栏的样式分为三种
  final String hintText;//提示文字
  final String defaultText;//默认文字
  final String locationCity;//城市定位，左边文字
  final void Function() leftButtonClick;//左边按钮点击事件
  final void Function() rightButtonClick;//右边按钮点击事件
  final void Function() speakButtonClick; //点击语音按钮事件
  final void Function() inputButtonClick;//输入框点击事件
  final ValueChanged<String> onChanged;

  const SearchBar({Key key,
    this.enabled = true,
    this.hideLeft,
    this.searchBarType = SearchBarType.normal,
    this.hintText,
    this.defaultText,
    this.leftButtonClick,
    this.rightButtonClick,
    this.speakButtonClick,
    this.inputButtonClick,
    this.locationCity,
    this.onChanged}
    ) : super(key: key);


  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar>{
  ///是否显示清空按钮
  bool showClearButton = false;
  ///文本输入框事件监听
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if(widget.defaultText != null){
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.searchBarType=${widget.searchBarType}");
    return widget.searchBarType == SearchBarType.normal
        ? _normalSearchBar()
        : _homeSearchBar();
  }

  //正常搜索页面的搜索弹窗
  Widget _normalSearchBar() {
    return Row(
      children: <Widget>[
        _singleTapWidget(widget.leftButtonClick, Container(
          padding: EdgeInsets.all(10),
          child: widget.hideLeft ?? false
              ? null
              : Icon(
            Icons.arrow_back_ios,
            size: 20,color: Colors.grey,
          ),
        )),
        Expanded(child: _inputBox(),flex: 1,),
        _singleTapWidget(widget.rightButtonClick,
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
                child: Text("搜索", style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16),
              )
            )
        )
      ],
    );
  }

  Widget _homeSearchBar() {
    return Row(
      children: <Widget>[
        _singleTapWidget(
            widget.leftButtonClick,
            Container(
              padding: EdgeInsets.all(10),
              child: widget.hideLeft ?? false
                  ? null
                  : Row(children: <Widget>[
                Text(widget.locationCity??"上海",
                  style: TextStyle(
                      color: _showColor(),
                      fontSize: 14),
                ),
                Icon(Icons.expand_more,size: 20,color: _showColor(),)
              ],
              ),
            )),
        Expanded(child: _inputBox(),flex: 1,),
        _singleTapWidget(widget.rightButtonClick,
            Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.message,color: _showColor(),),
            )),
      ],
    );
  }


  ///单个点击事件的Widget
  Widget _singleTapWidget(Function function,Widget child) {
    return GestureDetector(
      onTap: (){
        if(function != null){
          function();
        }
      },
      child: child,
    );
  }

  ///输入框组件
  Widget _inputBox() {
    Color inputBoxColor;
    if(widget.searchBarType == SearchBarType.home){
      inputBoxColor = Colors.white;
    }else{
      inputBoxColor = Color(int.parse('0xFFEDEDED'));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
      height: 30,
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
          widget.searchBarType == SearchBarType.normal ? 5 : 15
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search,color: Colors.lightBlue,size: 20,),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
              ? TextField(
              controller: _controller,
              onChanged: _onChanged,
              autofocus: false,//是否直接获取焦点
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w300,//字体粗细
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                border: InputBorder.none,
                hintText: widget.hintText??'',
                hintStyle: TextStyle(fontSize: 15),
              ),
            ) //输入文本框
                : _singleTapWidget(
                widget.inputButtonClick,
                Text(widget.defaultText,
                  style: TextStyle(fontSize: 14,
                      color: Colors.grey),
                )
            ),
          ),
          showClearButton ? _singleTapWidget((){
                setState(() {
                  _controller.clear();
                  _onChanged("");
                });
                },
              Icon(Icons.close,size: 20,color: Colors.grey,))
              : _singleTapWidget(widget.speakButtonClick,
              Icon(Icons.mic,size: 20,color: Colors.grey,)),
        ],
      ),
    );
  }
  
  
  _showColor(){
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }

  _onChanged(String text) {
    if(text.length > 0){
      setState(() {
        showClearButton = true;
      });
    }else{
      setState(() {
        showClearButton = false;
      });
    }
    if(widget.onChanged != null){
      widget.onChanged(text);
    }
  }
}