import 'package:flutter/material.dart';
import 'package:iron_trip/dao/search_dao.dart';
import 'package:iron_trip/model/search_model.dart';
import 'package:iron_trip/pages/speak_page.dart';
import 'package:iron_trip/widget/status_bar.dart';
import 'package:iron_trip/widget/webview.dart';

const TYPES = [
  'channelplane',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup',
  'channelgroup',
  'channelgs',
  'channeltrain',
  'cruise'
];

class SearchPage extends StatefulWidget{
  final bool hideLeft;//搜索界面是否隐藏返回按钮
  final String searchUrl;//搜索链接
  final String keyword;//搜索关键字
  final String hint;//搜索框提示

  const SearchPage({
    Key key,
    this.hideLeft,
    this.searchUrl,
    this.keyword,
    this.hint})
      : super(key: key);


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  SearchModel _searchModel;
  String _keyWord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffeeeeee)),
        child: Column(
          children: <Widget>[
            _appBar,
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Expanded(
                  flex: 1,
                  child: ListView.builder(itemBuilder: (BuildContext context, int index){
                    return _itemView(context,index);
                  },
                    itemCount: _searchModel?.data?.length??0,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if(widget.keyword != null){
      _onTextChange(widget.keyword);
    }
    super.initState();
  }

  Widget get _appBar{
    return Container(
      height: 88,
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(children: <Widget>[
        Container(
          child: SearchBar(
            onChanged: _onTextChange,
            searchBarType:SearchBarType.normal,
            hideLeft: widget.hideLeft,
            speakButtonClick: _jumpToSpeakPage,
            hintText: "网红打卡地 景点 酒店 美食",
            defaultText: widget.keyword!=null?widget.keyword:"",
            leftButtonClick: (){
              Navigator.pop(context);
            },
          ),),
      ]),
    );
  }

  ///跳转到语音识别界面
  _jumpToSpeakPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SpeakPage())
    );
  }

  ///获取搜索数据
  _onTextChange(String searchText) {
    _keyWord = searchText;
    if(searchText.length == 0){
      setState(() {
        _searchModel = null;
      });
      return;
    }
    SearchDao.getSearchData(searchText).then((SearchModel searchModel){
      if(searchModel.searchWords == _keyWord){
        setState(() {
          _searchModel = searchModel;
        });
      }
    }).catchError((e){
      print(e);
    });
  }

  Widget _itemView(BuildContext context, int index) {
    if(_searchModel == null || _searchModel.data == null
    || _searchModel.data.length == 0){
      return null;
    }
    Data data = _searchModel.data[index];
    return GestureDetector(
      onTap: (){
        //跳转到web view界面
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            WebView(
              url: data.url,
              title: data.word,
            )));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey,width: 0.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Image(
                image: AssetImage(_getImagePath(data.type)),
                width: 30,
                height: 30,),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: _title(data),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(top: 5),
                    child: _secondTitle(data),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getImagePath(String type) {
    if(type == null || type.length == 0){
      return "images/type_travelgroup.png";
    }
    String path = "travelgroup";
    for(var realType in TYPES){
      if(type.contains(realType)){
        path = realType;
      }
    }
    return "images/type_$path.png";
  }

  _title(Data data) {
    if(data == null || data.word == null
        || data.word.length == 0){
      return null;
    }
    List<TextSpan> spans =[];
    spans.addAll(_keyWordSpans(data.word,_searchModel.searchWords));

    return RichText(text: TextSpan(children: spans),maxLines: 2,);
  }

  _keyWordSpans(String word, String searchWords) {
    List<TextSpan> spanList = [];
    if(word == null || word.length == 0){
      return spanList;
    }
    //'sister'.split('s') -> [, i, ter]
    //'sister'.split('sister') -> [,,]
    List<String> splitWords = word.split(searchWords);
    print("word="+word+"  searchWords=$searchWords"+" splitWords="+splitWords.length.toString());
    for (var i = 0; i < splitWords.length; i++) {
      String word = splitWords[i];
      print("word="+word);
      if(i != 0){
        spanList.add(TextSpan(
          text: searchWords,
          style: TextStyle(fontSize: 16,color: Colors.orange),
        ));
      }
      spanList.add(
          TextSpan(
              text: word,
              style: TextStyle(fontSize: 16,color: Colors.black54)
          ));
    }
    return spanList;
  }

  _secondTitle(Data data) {
    return RichText(
      text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: data.price!=null?'价格:'+ data.price:'',
              style: TextStyle(fontSize: 13,color: Colors.orange),
            ),
            TextSpan(
             text: ' '+(data.star ?? ''),
             style: TextStyle(fontSize: 13,color: Colors.grey),
            )
          ]
        ),
      maxLines: 2,
    );
  }
}

