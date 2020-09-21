import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Event/biz_eventbus.dart';
import 'package:flutter_app/Event/normal_events.dart';
import 'package:flutter_app/Item/delet_card.dart';
import 'package:flutter_app/Item/delet_card_load.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/pages/home_view.dart';
import 'package:flutter_app/pages/pet_card.dart';
import 'package:flutter_app/pages/pet_card_load.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_app/view/slide_widget.dart';

class DeleteListView extends StatefulWidget {
  const DeleteListView({Key key}) : super(key: key);

  @override
  _DeleteListView createState() => _DeleteListView();

}

class _DeleteListView extends State<DeleteListView>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  static int _count = 1;

  ScrollController scrollController = ScrollController();

  List<DeleteCardViewModel> list = List.from(getNewList(_count));

  bool _isFirstLoad = true;

  bool _hasOpenedCell = false;
  int _openedCellIndex = -1;

  bool gestureResign = false;
  int tapNumber = 0;

  Future onRefresh() {
    _isFirstLoad = true;
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
              child: CircularProgressIndicator(strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(themeColor)),
            ),
          ],
        ),
      );
    } else {
      if(list.length>7) {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset("assets/images/back.png", width: 24, height: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: false,
          title: Text('侧滑删除', style: TextStyle(
              fontWeight: FontWeight.bold)),
          backgroundColor: themeColor,
          centerTitle: true,
          elevation: 0,
        ),

        body: NotificationListener<ScrollNotification>(
          onNotification: _scrollKeepCellClose,
          child: Listener(
            onPointerDown: (_) {
              tapNumber += 1;
              _setCellDragStatus();
            },
            onPointerUp: (_) {
              tapNumber -= 1;
              _setCellDragStatus();
            },

            child: _listViewBuild(context),
          ),
        )

    );
  }

  void _setCellDragStatus() {
    setState(() {
      tapNumber = tapNumber;
      gestureResign = gestureResign;
    });
  }

  _cellAction(int index) {
    // ignore: unnecessary_statements
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );

  }


  void fireCloseCellEvent() {
    EventBusInstance().bus.fire(CloseOpenedCellEvent(closeIndex: _openedCellIndex));
    _hasOpenedCell = false;
    _openedCellIndex = -1;
  }

  bool _scrollKeepCellClose(ScrollNotification notification) {
    if (_hasOpenedCell) {
      fireCloseCellEvent();
    }
    return true;
  }


  // ignore: missing_return
  static List<DeleteCardViewModel> getNewList(int count) {
    List<DeleteCardViewModel> list = new List();
    for (int i = 0; i < 10; i++) {
      DeleteCardViewModel petCardData = new DeleteCardViewModel(
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

  Widget _listViewBuild(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: this.onRefresh,
        backgroundColor: Color(0xffffffff),
        color: themeColor,
        child: Scrollbar(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            controller: this.scrollController,
            itemCount: this.list.length + 1,
            separatorBuilder: (context, index) {
              return Divider(height: 2.5, color: Color(0xFFDDDDDD));
            },
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
                  return DeleteCardLoad();
                } else {
//                  return DeleteCard(data: list[index]);
                  return _slideItems(context,index);
                }
              } else {
                return this.renderBottom();
              }
            },
          ),
        ),
      ),
    );
  }





  ///cell 手势   IgnorePointer
  Widget _slideItems(BuildContext context,int index) {
    return
      SlideButton (
        canDragNumber: tapNumber,
        index: index,
        singleButtonWidth: 100,
        onSlideStarted:() {
        },
        onSlideCompleted:(){
          if(_openedCellIndex != index) {
            _hasOpenedCell = true;
            _openedCellIndex = index;
          }
        },
        onSlideCanceled: () {
          _openedCellIndex = -1;
          _hasOpenedCell = false;
        },
        child: _itemViewdelete(index),
        buttons: <Widget>[
          GestureDetector(
            onTap:(){
              _deleteItem(context,index);
            },
            child: Container(
              width: 120,
              color: Colors.red,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20),
              child:Center (
                child:Text("删除",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
          ),
//          GestureDetector(
//            onTap:(){
//              _deleteItem(context,index);
//            },
//            child: Container(
//              width: 120,
//              color: Colors.yellow,
//              alignment: Alignment.center,
//              child:Center (
//                child:Text("置顶",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 16.0,
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//              ),
//            ),
//            behavior: HitTestBehavior.opaque,
//          )
        ],
      );
  }


  ///cell
  Widget _itemViewdelete(int index) {
    return GestureDetector (
      onTap:() {
        if (!gestureResign) {
          print("$index cell pop  ! ");
          _cellAction(index);
        }
      },
      onPanDown:(_) {
        returnPreState();
      },
      child:DeleteCard(data: list[index])
    );
  }

  void _deleteItem(BuildContext context,int index) {
    showDialog(
        context: context,
        builder: (context) =>
            _buildCupertinoAlertDialog(context,index));

  }


  Widget _buildCupertinoAlertDialog(BuildContext context,int index) {
    return Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: _buildTitle(context,index),
        content: _buildContent(context),
        actions: <Widget>[
          CupertinoButton(
              child: Text('Yes!'),
              onPressed: () {
                Routes.pop(context);

                list.removeAt(index);
                setState(() {
                  returnPreState();
                });

                ToastUtil.showToast("删除成功");
              }),
          CupertinoButton(
              child: Text('No!'), onPressed: () {
            setState(() {
              returnPreState();
            });
                Routes.pop(context);}),
        ],
      ),
    );
  }

  void returnPreState() {
       if (_hasOpenedCell ) {
      fireCloseCellEvent();
      gestureResign = true;
    } else {
      gestureResign = false;
    }
  }


  Widget _buildTitle(BuildContext context,int index) {
    return Container(
        child: Stack(
          children: <Widget>[
            Icon(
              CupertinoIcons.delete_solid,
              color: Colors.red,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("删除"+list[index].likes.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Column(children: <Widget>[
        Text('是否确定要清除?'),
      ]),
    );
  }


}
