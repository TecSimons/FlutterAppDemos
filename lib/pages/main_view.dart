import 'dart:convert';
import 'dart:math';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Item/news_card.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/const/string_const.dart';
import 'package:flutter_app/data/mock_data.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/pages/city_select_page.dart';
import 'package:flutter_app/pages/delet_list_view.dart';
import 'package:flutter_app/pages/home_view.dart';
import 'package:flutter_app/pages/my_page.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/service_categories.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/navigator_util.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_app/view/carousel.dart';
import 'package:flutter_app/view/marquee_widge.dart';
import 'package:flutter_app/view/recycle_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import '../main.dart';

List<String> _images = [
  'https://gw.alipayobjects.com/zos/rmsportal/iZBVOIhGJiAnhplqjvZW.png',
  'https://gw.alipayobjects.com/zos/rmsportal/uMfMFlvUuceEyPpotzlq.png',
  StringConst.imgUrl,
  'https://gw.alipayobjects.com/zos/rmsportal/uMfMFlvUuceEyPpotzlq.png',
];




class MainView extends StatefulWidget {
  const MainView({Key key}) : super(key: key);

  @override
  _MyMainViewState createState() => _MyMainViewState();
}

class _MyMainViewState extends State<MainView>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {





  List<NewsViewModel> list = List.from(newsList);
  int _currentPage = 1;
//  ScanResult scanResult;
  var _autoPlay = true;

  double _titleBarColorRate = 0.0;

//  var _titleIconColor = titleIconColor;

  var _currentIndex = 3;

  var _inputText = "请输入搜索关键字";

  String _cityName = "深圳市";

  var _isShowDialog=true;

  Color _setSearchColor() {
    Color colors = themeColor.withOpacity(0.12);
    return colors;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initListener();
    initNotification();
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
        _setSearchColor();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
//        print("76543210");

        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
//        print("01234567");

        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _loadData(int currentPage) async {
    if (currentPage == 1) {
      ToastUtil.showToast("刷新完成");
      list.clear();
      setState(() {
        list.addAll(getNewList(currentPage));
      });
    } else {
      setState(() {
        _isShowDialog=false;
      });

      return Future.delayed(Duration(seconds: 1), () {
        setState(() {
          list.addAll(getNewList(currentPage));
          _isShowDialog=true;
        });
      });
    }
  }



    Future _scan() async {
//      String barcode = await scanner.scan();
//      if (barcode == null) {
//        print('nothing return.');
//      } else {
//        ToastUtil.showToast(barcode);
//      }
    }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
//      appBar: PreferredSize(
//        child: Offstage(
//          offstage: _currentIndex == 3 ? true : false,
//          child: AppBar(
////            automaticallyImplyLeading: false,
//            centerTitle: true,
//            title: Text('卡片'),
//            leading: IconButton(
//              icon: Icon(Icons.arrow_back, color: _titleIconColor),
//              onPressed: () {},
//            ),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.share, color: _titleIconColor),
//                onPressed: () {},
//              ),
//            ],
//            backgroundColor: _titleBarColor,
//            elevation: 0,
//          ),
//        ),
//        preferredSize: Size.fromHeight(40),
//      ),
      body: Stack(
        children: <Widget>[
          RecycleView<NewsViewModel>(
            lists: list,
            allCounts: 50,
            loadMore: () {
              _currentPage++;
              _loadData(_currentPage);
            },
            refresh: () {
              _currentPage = 1;
              _loadData(_currentPage);
            },
            listOffset: (height) {
              showHead(height);
            },
            itemCount: list.length + 1,
            listBuilder: _createBuilder,
          ),
          Offstage(
              offstage: _currentIndex == 3 ? true : false,
              child: Opacity(
                  opacity: _titleBarColorRate,
                  child: Container(
                      padding: EdgeInsets.only(top: 30, left: 5, right: 5),
                      height: 80,
                      width: double.infinity,
                      color: themeColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          locationIcon(WHITE),
                          cityName(WHITE),
                          searchWidget(0,CenterColor,WHITE,WHITE),
                          notifyIcon(WHITE),
                        ],
                      )))),

          Offstage(
              offstage: _isShowDialog ,
              child: Container(
                color: TRANSPRENT_HALF,
                child: Center(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Loading(indicator: BallSpinFadeLoaderIndicator(), size: 30.0, color: themeColor),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          '正在加载数据.....',
                          style: TextStyle(
                            fontSize: 13,
                            color: themeColor,
                          ),
                        ),
                      ],
                    )
                ),
              ))
        ],
      ),
    );
  }

  void showHead(height) {

    double rate = height / 220;
    if (rate >= 1.0) {
      rate = 1.0;
    }
    if (height >= 220) {
      setState(() {
        _titleBarColorRate = 1.0;
        _currentIndex = 2;
      });
    } else {
      if (height == 0) {
        setState(() {
          _titleBarColorRate = 0.0;
          _currentIndex = 3;
        });
      } else {
        setState(() {
          _titleBarColorRate = rate;
          _currentIndex = 2;
        });
      }
    }
  }

  Widget _createBuilder(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            new Container(
                height: 220.0,
                child: Stack(
                  children: <Widget>[
                    SyCarousel(
                      autoPlay: _autoPlay,
                      dotSize: 10.0,
                      showIndicators: true,
                      listImg: _images,
                      children: _images.map((item) {
                        return Image.network(
                          item,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ),
                    Offstage(
                        offstage: _currentIndex == 3 ? false : true,
                        child: Container(
                            padding:
                                EdgeInsets.only(top: 30, left: 5, right: 5),
                            height: 80,
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                locationIcon(themeColor),
                                cityName(TEXT_BLACK1),
                                searchWidget(1,DARK_COLOR,themeColor,TEXT_BLACK2),
                                notifyIcon(themeColor),
                              ],
                            )))
                  ],
                )),
            new Container(
              height: 160,
              child: ServiceCategories(),
            )
          ],
        ),
      );
    } else {
      NewsViewModel data = list[_getRealIndex(index)];
      return GestureDetector(
        onTap: (){
          _itemClicked(index);
        },
        child:Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Row(
                        children: <Widget>[
                          Text(
                            '${data.source}  ${data.comments}评论',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                GestureDetector(
                  onTap: () => _itemPic(index),
                  child: Image.network(
                    data.coverImgUrl,
                    width: 100,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
        ),
      );
    }
  }

  _showClick(BuildContext context) {
//    ToastUtil.showToast(data.title);
//    Routes.navigateTo(context, '/sliverHeader');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteListView()),
    );
  }


//  InkWell buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
//      GestureTapCallback tap) {
//
//    return InkWell(
//      onTap: tap,
//      child: Container(
//        alignment: Alignment.center,
//        width: 80,
//        color: color,
//        child: Text(text,
//            style: TextStyle(
//              color: Colors.white,
//            )),
//      ),
//    );
//  }

  _itemClicked(int index) {
    if(index==1){
      _showNotification();
    }else {
//      ToastUtil.showSnackBar(context, index.toString());
//      ToastUtil.showToast(index.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeleteListView()),
      );
    }
  }

  int _getRealIndex(int index) {
    return index - 1;
  }

  // ignore: missing_return
  static List<NewsViewModel> getNewList(int currentPage) {
    List<NewsViewModel> list = new List();
    list.addAll(newsList);
    return list;
  }

  _itemPic(int index) {
    List<String> imgList = List();
    imgList.add(list[index - 1].coverImgUrl);
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _clickLocation(BuildContext context) {
    Navigator.push<CityInfo>(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new CitySelectPage("选择城市");
    })).then((CityInfo result) {
      setState(() {
        _cityName = result.name;
      });
    });
  }

  void _clickNotify(BuildContext context) {


//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => PKCardSkeleton()),
//    );
    NavigatorUtil.pushWeb(context,
                  title: "flutter讨论社区", url: "https://flutter.cn/");

  }

  void initNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }


  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }


  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }



  Future _showNotification() async {
    //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '13234', '消息通知', '消息通知',
        importance: Importance.Max, priority: Priority.High);// Priority.High
    //IOS的通知配置
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //显示通知，其中 0 代表通知的 id，用于区分通知。
    await flutterLocalNotificationsPlugin.show(
        0, 'flutter_app', '123test123', platformChannelSpecifics,
        payload: 'complete');
  }



  void _clickSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

 Widget cityName(Color textColor) {
  return GestureDetector(
       onTap: () {
         _clickLocation(context);
       },
       child: SizedBox(
         width: 50.0,
         child: MarqueeWidget(
           direction: Axis.horizontal,
           child: Text(
             _cityName,
             softWrap: true,
             overflow: TextOverflow.ellipsis,
             maxLines: 1,
             style: TextStyle(
                 color: textColor,
                 fontSize: 15,
                 fontWeight: FontWeight.bold
             ),
           ),
         ),
       ));
 }

  Widget locationIcon(Color colors) {
   return IconButton(
      icon: (Icon(Icons.location_on, color: colors)),
     onPressed: _scan,
//      onPressed: () {
//        _clickLocation(context);
//      },
    );
  }

 Widget searchWidget(int type,Color border,Color iconColor,Color textColor) {
   return   Expanded(
     child: GestureDetector(
       onTap: () {
         _clickSearch(context);
       },
       child: Container(
         margin: EdgeInsets.only(left: 15),
         height: 34.0,
         decoration: BoxDecoration(
             shape: BoxShape.rectangle,
             color: type==1?_setSearchColor():CenterColor,
             borderRadius:
             BorderRadius.circular(20.0),
             border: Border.all(
                 color: border,
                 width: 1.2,
                 style: BorderStyle.solid)),
         child: Row(
           mainAxisAlignment:
           MainAxisAlignment.start,
           children: <Widget>[
             Padding(
                 padding:
                 EdgeInsets.only(left: 10)),
             Icon(
               Icons.search,
               color: iconColor,
               size: 25,
             ),
             Padding(
                 padding:
                 EdgeInsets.only(left: 5)),
             Text(
//               scanResult==null?_inputText:scanResult.rawContent,
               _inputText,
               style: TextStyle(
                 color: textColor,
                 //字体颜色
                 fontSize: 13.0,
                 //字体大小，注意flutter里面是double类型
                 fontWeight:
                 FontWeight.normal, //字体粗细
               ),
             ),
           ],
         ),
       ),
     ),
   );

 }

  Widget notifyIcon(Color colors) {
    return   IconButton(
      icon: (Icon(Icons.notifications, color: colors)),
      onPressed: () {
        _clickNotify(context);
      },
    );
  }
}

class TestNotification extends Notification {
  TestNotification({
    @required this.count,
  });

  final int count;
}
