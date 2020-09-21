import 'package:flutter/material.dart';
import 'package:flutter_app/Item/net_gridview_entity.dart';
import 'package:flutter_app/Item/net_gridview_item.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/data/base_bean_entity.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/utils/HttpUtils.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

class NetGridPage extends StatefulWidget {
  @override
  _NetGridPageState createState() => _NetGridPageState();
}

class _NetGridPageState extends State<NetGridPage>
    with AutomaticKeepAliveClientMixin {
  var _scrollController = new ScrollController(initialScrollOffset: 0);
  var _imageList = [];
  var _load = 0;
  int _page = 4;

  var _isShowDialog= true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var px = _scrollController.position.pixels;
      if (px == _scrollController.position.maxScrollExtent) {
        Log.info("加载更多！");
        _onLoadMore();
      }
    });
    _isShowDialog=false;
    _initData(_page);
  }

  Future<void> _initData(int page) async {
    var map = Map();
    map["size"] = 10;
    map["page"] = page;
    var res = await HttpUtils.get("/data/福利/:size/:page", map);
    var newList = BaseBeanEntity.fromJsonList(res).getList<NetGridViewEntity>();
    setState(() {
      _isShowDialog=true;
      if (page == 1) {
        _imageList.clear();
      }
      _imageList.addAll(newList); //results为数组
      if (newList == null || newList.length == 0) {
        _load = 3;
      } else {
        _load = 0;
      }
      _page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  backgroundColor: Color(0xffffffff),
                  color: themeColor,
                  child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8),
                    crossAxisCount: 4,
                    itemCount: _imageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      NetGridViewEntity item = _imageList[index];
                      return NetGridViewItem(item);
                    },
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index == 0 ? 1.5 : 2),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                ),
              ),
              Offstage(
                offstage: _load != 2,
                child: Center(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2 ,valueColor: AlwaysStoppedAnimation(themeColor)
                              ),
                              width: 14,
                              height: 14,
                            ),
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 10),
                          ),
                        ),
                        Expanded(
                          child: Text("加载更多..."),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                ),
              )
            ],
          ),
        ), Offstage(
            offstage: _isShowDialog,
            child: Container(
              color: WHITE,
              child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(indicator: BallSpinFadeLoaderIndicator(),
                          size: 30.0,
                          color: themeColor),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        '正在清除缓存.....',
                        style: TextStyle(
                          fontSize: 13,
                          color: themeColor,
                        ),
                      ),
                    ],
                  )
              ),
            )),
      ],
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
      _load = 1;
    });
    await _initData(_page);
    print("_onRefresh");
  }

  Future<void> _onLoadMore() async {
    if (_load == 3) return;
    setState(() {
      _load = 2;
    });
    await _initData(_page);
    print("_onLoadMore");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
