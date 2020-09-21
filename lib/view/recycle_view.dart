import 'package:flutter/material.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/_const.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/utils/spHelper.dart';

// ignore: must_be_immutable
class RecycleView<T> extends StatefulWidget {
  Function loadMore;
  Function refresh;
  Function listOffset;
  List<T> lists;
  int allCounts;
  Function listBuilder;

  //传入count,则可自行构建不同的listBuilder
  int itemCount;

  RecycleView(
      {Key key,
      @required this.lists,
      @required this.allCounts,
      this.loadMore,
      this.refresh,
      this.listOffset(height),
      @required this.listBuilder,
      @required this.itemCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _Recycle();
}

class _Recycle extends State<RecycleView> {
  //下拉刷新触发距离
//  static const double DISPLACEMENT = 60.0;
  static const double DISPLACEMENT = 60.0;

  //是否显示正在加载
  bool _showLoading = false;

  ScrollController _scrollController = ScrollController();

  bool _showNoMore=false;

  @override
  void didUpdateWidget(RecycleView oldWidget) {
    super.didUpdateWidget(oldWidget);
//    Log.info("info_loadMore22=="+(oldWidget.lists==widget.lists).toString()+"<----->"+widget.lists.isNotEmpty.toString());
    if (oldWidget.lists == widget.lists && oldWidget.lists.isNotEmpty) {
//      _showLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        Log.info("info_loadMore21=="+_showLoading.toString()+"<---->"+widget.lists.isNotEmpty.toString()+"<---->"+widget.lists.length.toString()+"<----->"+widget.allCounts.toString());
        if (!_showLoading &&
            widget.lists.isNotEmpty &&
            widget.lists.length < widget.allCounts) {
          setState(() {
            _showLoading = true;
          });
          _loadMore();
        }
      }
      widget.listOffset(_scrollController.offset);
    });
    _initListener();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      _loadLocale();
    });
  }

  void _loadLocale() {
    String _colorKey = SpHelper.getThemeColor();
    if (themeColorMap[_colorKey] != null) {
      setState(() {
        themeColor = themeColorMap[_colorKey];
      });
    }
  }

  _refresh() {
    if (widget.refresh != null) {
      widget.refresh();
      setState(() {
        _showLoading = false;
      });
    }
  }

  _loadMore() {
    if (widget.loadMore != null) {
      widget.loadMore();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lists == null || widget.lists.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      int _itemCount =
          widget.itemCount > 0 ? widget.itemCount + 1 : widget.lists.length + 1;
      return Scaffold(
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
              backgroundColor: Color(0xffffffff),
              color: themeColor,
              onRefresh: () async {
                return Future.delayed(Duration(seconds: 3), () {
                  _refresh();
                });
              },
              displacement: DISPLACEMENT,
              child: ListView.separated(
                itemCount: _itemCount,
//                shrinkWrap: true,
//                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 0),
                separatorBuilder: (context, index) {
                  return Divider(height: 2.5, color: Color(0xFFDDDDDD));
                },
                itemBuilder: (context, index) {
                  if (index == _itemCount - 1) {
//                Log.info("info_loadMore25=="+_showLoading.toString()+"<---->"+index.toString()+"<---->"+_itemCount.toString());
//                return _showLoading ? _loadingWidget() : _noMoreWidget();
                    return this.renderBottom(index);
                  } else {
                    return widget.listBuilder(context, index);
                  }
                },
                controller: _scrollController,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget renderBottom(int index) {
//    Log.info("info_loadMore25=="+_showLoading.toString()+"<---->"+index.toString()+"<---->"+widget.allCounts.toString());
    if(index>widget.allCounts){
      _showNoMore=true;
    }else{
      _showNoMore=false;
    }
    if (_showLoading && index < widget.allCounts) {
      _showLoading = false;
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '努力加载中...',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(themeColor)),
            ),
          ],
        ),
      );
    } else {

      return  Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: Text(
            _showNoMore? '没有更多啦~':'努力加载中...',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF333333),
            ),
          ),
      );
    }
  }

  Widget _loadingWidget() {
    return Offstage(
        offstage: false,
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Center(
            child: new CircularProgressIndicator(strokeWidth: 3),
          ),
        ));
  }

  Widget _noMoreWidget() {
    return Offstage(
        offstage: false,
        child: Center(
            child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text("没有更多啦~"))));
  }
}
