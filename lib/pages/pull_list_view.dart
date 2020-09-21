import 'package:flutter/material.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/pages/pet_card.dart';
import 'package:flutter_app/pages/pet_card_load.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/spHelper.dart';

class PullListView extends StatefulWidget {
  const PullListView({Key key}) : super(key: key);

  @override
  _PullListView createState() => _PullListView();
}

class _PullListView extends State<PullListView>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  static int _count = 1;

  ScrollController scrollController = ScrollController();

  List<PetCardViewModel> list = List.from(getNewList(_count));

  bool _isFirstLoad = true;

  Future onRefresh() {
    _isFirstLoad=true;
    setState(() {
      list.addAll(getNewList(_count));
    });
    return Future.delayed(Duration(seconds: 3), () {
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
    return Future.delayed(Duration(seconds: 1), () {
      setState(() {
        this.isLoading = false;
        _count++;
        list.addAll(getNewList(_count));
      });
    });
  }

  Widget renderBottom() {
    if (this.isLoading) {
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
              child: CircularProgressIndicator(strokeWidth: 2 ,valueColor: AlwaysStoppedAnimation(themeColor)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          '上拉加载更多',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF333333),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('卡片',style: TextStyle(
        fontWeight: FontWeight.bold)),
        backgroundColor: themeColor,
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              colors: [Colors.cyan, Colors.blue, Colors.blueAccent],
//            ),
//          ),
//        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: this.onRefresh,
          backgroundColor: Color(0xffffffff),
          color: themeColor,
         child:Scrollbar(

          child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: this.scrollController,
            itemCount: this.list.length + 1,
//      separatorBuilder: (context, index) {
//        return Divider(height: 2.5, color: Color(0xFFDDDDDD));
//      },
            itemBuilder: (context, index) {
              if (index < this.list.length) {
                if (_isFirstLoad) {
                  Future.delayed(Duration(seconds: 3), () {
                    _isFirstLoad = false;
                    list.clear();
                     setState(() {
                      isLoading = false;
                      list.addAll(getNewList(_count));
                    });
                  });
                  return PetCardLoad();
                } else {
                  return PetCard(data: list[index]);
                }
              } else {
                return this.renderBottom();
              }
            },
          ),
         ),
        ),
      ),
    );
  }

  // ignore: missing_return
  static List<PetCardViewModel> getNewList(int count) {
    List<PetCardViewModel> list = new List();
    for (int i = 0; i < 10; i++) {
      PetCardViewModel petCardData = new PetCardViewModel(
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
