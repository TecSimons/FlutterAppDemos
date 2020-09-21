import 'package:flutter/material.dart';
import 'package:flutter_app/Item/grid_card.dart';
import 'package:flutter_app/Item/grid_card_load.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/spHelper.dart';

class PullGridView extends StatefulWidget {
  const PullGridView({Key key}) : super(key: key);

  @override
  _PullGridView createState() => _PullGridView();
}

class _PullGridView extends State<PullGridView>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  static int _count = 1;

  ScrollController scrollController = ScrollController();

  List<GridCardViewModel> list = List.from(getNewList(_count));

  bool _isFirstLoad = true;

  var _load = 0;

  Future onRefresh() {
    _isFirstLoad = true;
    setState(() {
      list.addAll(getNewList(_count));
    });
    return Future.delayed(Duration(milliseconds: 1500), () {
      ToastUtil.showToast('当前已是最新数据');
      list.clear();
      _count = 1;
      setState(() {
        isLoading = false;
        list.addAll(getNewList(_count));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initListener();
    this.scrollController.addListener(() {
      if (!this.isLoading &&
          this.scrollController.position.pixels >=
              this.scrollController.position.maxScrollExtent) {
        setState(() {
          this.isLoading = true;
          this.loadMoreData();
        });
      }
    });
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

  @override
  void dispose() {
    super.dispose();
    this.scrollController.dispose();
  }

  Future loadMoreData() {
    setState(() {
      _load = 2;
    });
    return Future.delayed(Duration(seconds: 2), () {
      setState(() {
        this.isLoading = false;
        _count++;
        _load = 0;
        list.addAll(getNewList(_count));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RefreshIndicator(
              onRefresh: this.onRefresh,
              backgroundColor: Color(0xffffffff),
              color: themeColor,
              child: Scrollbar(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 2,
                      //纵轴间距
//                mainAxisSpacing: 10.0,
//                //横轴间距
//                crossAxisSpacing: 0,
                      //子组件宽高长度比例
                      childAspectRatio: 0.85),
                  scrollDirection: Axis.vertical,
                  controller: this.scrollController,
                  itemCount: this.list.length,
                  itemBuilder: (context, index) {
                    if (_isFirstLoad) {
                      Future.delayed(Duration(milliseconds: 1500), () {
                        _isFirstLoad = false;
                        list.clear();
                        setState(() {
                          isLoading = false;
                          list.addAll(getNewList(_count));
                        });
                      });
                      return GridCardLoad();
                    } else {
                      return GridCard(data: list[index]);
                    }
                  },
                ),
              ),
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
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(themeColor),
                        ),
                        width: 14,
                        height: 14,
                      ),
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 10),
                    ),
                  ),
                  Expanded(
                    child: Text("努力加载中..."),
                  )
                ],
              ),
              padding: EdgeInsets.all(15),
            ),
          ),
        )
      ]),
    );
  }

  // ignore: missing_return
  static List<GridCardViewModel> getNewList(int count) {
    List<GridCardViewModel> list = new List();
    for (int i = 0; i < 10; i++) {
      GridCardViewModel petCardData = new GridCardViewModel(
          coverUrl:
              'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1425538345,901220022&fm=26&gp=0.jpg',
          userImgUrl:
              'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1699287406,228622974&fm=26&gp=0.jpg',
          userName: '大米要煮小米粥',
          description: '小米 | 我家的小仓鼠',
          publishTime: '12:59',
          topic: '萌宠小屋',
          publishContent: '今天带着小VIVI去了爪子生活体验馆，好多好玩的小东西都想带回家！',
          replies: 356,
          likes: (count - 1) * 10 + i,
          shares: 126);
      list.add(petCardData);
    }
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
