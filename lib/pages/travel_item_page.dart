
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iron_trip/dao/travel_dao.dart';
import 'package:iron_trip/model/travel_model.dart';
import 'package:iron_trip/widget/loading_container.dart';
import 'package:iron_trip/widget/webview.dart';

/// Time：2019-11-07 16:51
/// User：IronRen
/// Desc：旅拍模块tab对应的页面

const TRAVEL_URL = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031010211161114530&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE = 10;

class TravelItemPage extends StatefulWidget{
  final Map params;
  final int type;
  final String requestUrl;
  final String groupChannelCode;

  const TravelItemPage({Key key, this.params, this.type, this.requestUrl, this.groupChannelCode})
      :super(key: key);


  @override
  State<StatefulWidget> createState() => _TravelItemPageState();
}

/// AutomaticKeepAliveClientMixin 设置成true 是保留缓存 不再重新创建当前page
class _TravelItemPageState extends State<TravelItemPage> with AutomaticKeepAliveClientMixin{
  int pageIndex = 1;
  List<ResultList> pages = [];
  bool _isLoading = true;
  int maxCount = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadData();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(maxCount != 0 && maxCount > pages.length){
          _loadData(loadMore: true);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //脚手架 根节点
    return Scaffold(
        body: LoadingContainer( ///页面加载进度
            isLoading: _isLoading,
            child: RefreshIndicator( ///下拉刷新
                child: MediaQuery.removePadding( ///去除系统默认的顶部padding
                  context: context,
                  removeTop: true,
                  child: new StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: 4,//每一行分成几列，宽几等分
                    itemCount: pages?.length??0,//总条数
                    itemBuilder: (BuildContext context, int index) =>
                    new _TravelItem(index: index,item: pages[index],),
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.fit(2),//每一个item占据几列，占宽几等分的多少份
                    //        mainAxisSpacing: 4.0,
                    //        crossAxisSpacing: 4.0,
                  ),
                ),
                onRefresh: loadRefreshData ///下拉刷新的回调
            )
        )
    );
  }

  ///刷新数据
  Future<Null> loadRefreshData() async {
    _loadData();
    return null;
  }

  void _loadData({loadMore = false}) {
    if(loadMore){
      pageIndex++;
    }else{
      pageIndex = 1;
    }
    print("widget.requestUrl="+widget.requestUrl+" widget.groupChannelCode="+widget.groupChannelCode);
    TravelDao.getTravels(widget.requestUrl??TRAVEL_URL,
        widget.groupChannelCode, pageIndex, widget.params, widget.type, PAGE_SIZE)
        .then((value){
        setState(() {
              _isLoading = false;
              maxCount = value.totalCount;
              List<ResultList> filterList = filter(value.resultList);
              if(pages== null || pages.length == 0){
                pages = filterList;
              }else{
                pages.addAll(filterList);
              }
              print("pages.length=${pages.length}");
            });
    }).catchError((e){
      print(e);
      _isLoading = false;
    });
  }

  /// 过滤掉不合法数据
  List<ResultList> filter(List<ResultList> resultList) {
    if(resultList == null){
      return [];
    }
    List<ResultList> list = [];
    resultList.forEach((ResultList resultItem){
      if(resultItem.article != null){
        list.add(resultItem);
      }
    });
    return list;
  }

  @override
  bool get wantKeepAlive => true;
}

class _TravelItem extends StatelessWidget{
  final int index;
  final ResultList item;

  const _TravelItem({Key key, this.index, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.article.urls != null && item.article.urls.length > 0){
          Navigator.push(context, MaterialPageRoute(builder:(context) =>
              WebView(url: item.article.urls[0].h5Url,title: '详情')));
        }
      },
      child: Card(
        //添加一个物理模型
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),///列表图片和标签
              Container(
                padding: EdgeInsets.all(4),
                child: Text(item.article.articleTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black87,fontSize: 14),
                ),
              ),
              _itemUser(),
            ],
          ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0].dynamicUrl),
        Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3,),
                    child: Icon(Icons.location_on,color: Colors.white,size: 12,),
                  ),
                  LimitedBox(
                    maxWidth: 128,
                    child: Text(_locationTextItem(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white,fontSize: 12,),
                    )
                  ) ///限制宽度的组件
                ],
              ),
            )
        )
      ],
    );
  }

  String _locationTextItem() {
    if(item.article.pois != null && item.article.pois.length > 0 && item.article.pois[0].poiName != null){
      return item.article.pois[0].poiName;
    }else{
      return "未知位置";
    }
  }

  _itemUser() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl,width: 24,height: 24,),
              ),
              Container(
                width: 80,
                padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: Text(item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12,color: Colors.black54),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
              Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(item.article?.likeCount.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black54,fontSize: 12),))
            ],
          )
        ],
      ),
    );
  }
}