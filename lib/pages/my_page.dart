import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:base_library/base_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/config/Config.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/utils/cache_utils.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'image_preview.dart';
import 'login_page.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> with AutomaticKeepAliveClientMixin {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var cacheSize;
  var _isCureentDate = true;
  String _currentDate = new DateTime.now().toString().substring(0, 19);
  DateTime _curDate;
  var _currentSelectColor;
  Uint8List _thumbData;

  var _isShowDialog = true;

  @override
  void initState() {
    CacheUtils.getInstance().loadCache().then((val) {
      setState(() {
        cacheSize = val;
      });
    });
    _initListener();
    _setThemeColorSelect();

    setState(() {
      String bs64Png = SpHelper.getString(Config.LOCAL_HEAD, defValue: "");
      if (!TextUtil.isEmpty(bs64Png)) {
        _thumbData = base64Decode(bs64Png);
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

  Future _selectDate() async {
//    DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: new DateTime.now(),
//        firstDate: new DateTime(2016),
//        locale: Locale('zh'),
//        lastDate: new DateTime(2050));
//    if (picked != null)
//      setState(() {
//        _currentDate = picked.toString();
//      });

    DatePicker.showDatePicker(context,
        //配置语言
        locale: DateTimePickerLocale.zh_cn,
        //日期样式
        pickerTheme: DateTimePickerTheme(
          confirm: Text(
            "确定",
            style: TextStyle(fontSize: 20),
          ),
          cancel: Text(
            "取消",
            style: TextStyle(fontSize: 20),
          ),
        ),
        //最小日期限制
        minDateTime: DateTime.parse("1965-01-01"),
        //最大日期限制
        maxDateTime: DateTime.parse("2100-01-01"),
        //初试日期
        initialDateTime: _isCureentDate ? DateTime.now() : _curDate,
//          dateFormat: "yyyy-MM-dd EEE,H时:m分",
        dateFormat: "yyyy年M月d日 EEE,H时:m分",
        pickerMode: DateTimePickerMode.datetime,
        //show datetime 配置为datetime格式的时候 dateFormat必须要加上时分的格式
        //在日期发生改变的时候实时更改日期
        onChange: (date, List<int> index) {
      setState(() {
        _currentDate = date.toString().substring(0, 16) + ":00";
      });
    },
        //点击确认后才更改日期
        onConfirm: (date, List<int> index) {
      _curDate = date;
      _isCureentDate = false;
      setState(() {
        _currentDate = date.toString().substring(0, 16) + ":00";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              '我的',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: themeColor,
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: BottomClipper(),
                    child: Container(
                      color: themeColor,
                      height: 120,
                    ),
                  ),
                  Positioned(
                      left: 25,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          loadAssets();
                        },
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: themeColor,
                            borderRadius: BorderRadius.circular(37.0),
                            border: Border.all(
                                color: WHITE,
                                width: 2,
                                style: BorderStyle.solid),
                          ),
                          child: CircleAvatar(
                              radius: 33.0,
                              backgroundColor: themeColor,
                              backgroundImage: _thumbData != null
                                  ? MemoryImage(_thumbData.buffer.asUint8List())
                                  : NetworkImage(
                                      'http://9.onn9.com/2016/10/85c76e5623b1b443bcdb7afe2a951cd5.jpg')),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 110, top: 18),
                    child: GestureDetector(
                      onTap: () {
                        _thumbData != null
                            ? _showHeads(_thumbData)
                            : _showHead(
                                'http://9.onn9.com/2016/10/85c76e5623b1b443bcdb7afe2a951cd5.jpg');
                      },
                      child: Text(
                        'Shaly',
                        style: TextStyle(
                          color: WHITE,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: ListTile(
                  selected: true,
                  leading: Icon(Icons.settings, color: themeColor),
                  trailing: Text(
                    _currentDate,
                    style: TextStyle(
//                  fontSize: ScreenUtil().setSp(36),
                      fontSize: 16,
                      color: TEXT_BLACK1,
                    ),
                  ),
//                  Icon(Icons.keyboard_arrow_right, color: DARK_COLOR),
                  title: Text(
                    '设置',
                    style: TextStyle(color: TEXT_BLACK1),
                  ),
                  onTap: () {
//                Routes.navigateTo(context, '/sliverHeader');
//                DatePickerPage
                    _selectDate();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 1,
                  indent: 4.0,
                  endIndent: 4.0,
                  color: Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: ListTile(
                  leading: Icon(Icons.layers_clear, color: themeColor),
                  title: Text('清除缓存',
                      style: TextStyle(
                        color: TEXT_BLACK1,
                      )),
                  trailing: Text(
                    cacheSize ?? '0.0',
                    style: TextStyle(
//                  fontSize: ScreenUtil().setSp(36),
                      fontSize: 16,
                      color: TEXT_BLACK1,
                    ),
                  ),
                  onTap: () {
                      showDialog(
                      context: context,
                      builder: (context) =>
                          _buildCupertinoAlertDialog(context));
                  }
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 1,
                  indent: 4.0,
                  endIndent: 4.0,
                  color: Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: ListTile(
                  selected: true,
                  leading: Icon(Icons.person, color: themeColor),
                  trailing: Icon(Icons.keyboard_arrow_right, color: DARK_COLOR),
                  title: Text(
                    '退出登录',
                    style: TextStyle(color: TEXT_BLACK1),
                  ),
                  onTap: () {
                    _exitLogin(context);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 1,
                  indent: 4.0,
                  endIndent: 4.0,
                  color: Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: new ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.color_lens,
                        color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 32, right: 25),
                        child: Text(
                          "主题",
                          style: TextStyle(color: TEXT_BLACK1),
                        ),
                      )
                    ],
                  ),
                  children: <Widget>[
                    new Wrap(
                      children: themeColorMap.keys.map((String key) {
                        Color value = themeColorMap[key];
                        return new InkWell(
                          onTap: () {
                            SpHelper.putString(Config.KEY_THEME_COLOR, key);
                            bloc.sendAppEvent(Config.TYPE_SYS_UPDATE);
                            _setThemeColorSelect();
                          },
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: value,
                                ),
                                margin: EdgeInsets.all(5.0),
                                width: 36.0,
                                height: 36.0,
                              ),
                              Positioned(
                                left: 20,
                                top: 20,
                                child: Offstage(
                                  offstage: _currentSelectColor != value
                                      ? true
                                      : false,
                                  child: Container(
                                    child: Icon(
                                      CupertinoIcons.check_mark,
                                      color: WHITE,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Offstage(
            offstage: _isShowDialog,
            child: Container(
              color: TRANSPRENT_HALF,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loading(
                      indicator: BallSpinFadeLoaderIndicator(),
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
              )),
            ))
      ],
    );
  }

  Widget _buildCupertinoAlertDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: _buildTitle(context),
        content: _buildContent(context),
        actions: <Widget>[
          CupertinoButton(
              child: Text('Yes!'),
              onPressed: () {

                CacheUtils.getInstance().clearCache();
                Routes.pop(context);
                setState(() {
                  _isShowDialog = false;
                });
                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    _isShowDialog = true;
                    ToastUtil.showToast("清除成功");
                  });

                  CacheUtils.getInstance().loadCache().then((val) {
                    setState(() {
                      cacheSize = val;
                    });
                  });

                });
              }),
          CupertinoButton(
              child: Text('No!'), onPressed: () => Routes.pop(context)),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
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
            Text(
              '清理缓存',
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
        Text('是否确定要清除缓存文件?'),
      ]),
    );
  }

  _showHead(dynamic data) {
    List<dynamic> imgList = List();
    imgList.add(data);
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
  }

  _showHeads(Uint8List _thumbData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImagePreview(datas: _thumbData)),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _setThemeColorSelect() {
    String _colorKey = SpHelper.getThemeColor();
    if (themeColorMap[_colorKey] != null) {
      setState(() {
        _currentSelectColor = themeColorMap[_colorKey];
      });
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    images.clear();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          autoCloseOnSelectionLimit: true,
          startInAllView: true,
          statusBarColor: getColor(),
          actionBarColor: getColor(),
          actionBarTitle: "选择图片",
          allViewTitle: "请选单张图片",
          textOnNothingSelected: "没有选中图片",
          selectionLimitReachedText: "只可选一张图片！！！",
          useDetailsView: false,
          selectCircleStrokeColor: getColor(),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    _loadThumb(resultList);
  }

  void _loadThumb(List<Asset> resultList) async {
    ByteData thumbData = await resultList[0].getByteData(
      quality: 100,
    );
    if (this.mounted) {
      setState(() {
        _thumbData = thumbData.buffer.asUint8List();
        images = resultList;
      });
      SpHelper.putString(Config.LOCAL_HEAD, base64Encode(_thumbData));
    }
  }

  String getColor() {
    return "#" + themeColor.value.toRadixString(16);
  }
}

void _exitLogin(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确定退出登录？"),
          actions: [
            FlatButton(
              child: Text("取消"),
              textColor: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                ToastUtil.showToast("登出成功");
                SpHelper.putBool(Config.KEY_IS_LOGIN, false);

                Navigator.pushAndRemoveUntil(
                  context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()),
                  (route) => route == null,
                );
              },
            )
          ],
        );
      });
}

class BottomClipper extends CustomClipper<Path> {
  var height = kToolbarHeight + MediaQueryData.fromWindow(window).padding.top;

  @override
  Path getClip(Size size) {
    var path = Path();
    //单曲线切割路径
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height -50);
    // var firstControlPoint = Offset(size.width / 2, size.height);
    // var firstEndpoint = Offset(size.width, size.height -50);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndpoint.dx, firstEndpoint.dy);
    // path.lineTo(size.width, size.height-50);
    // path.lineTo(size.width, 0);

    //波浪线路径
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height); //第一段曲线控制点
    var firstEndpoint = Offset(size.width / 2.25, size.height - 30); //第一段曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy); //形成曲线

    var secondControlPoint =
        Offset(size.width * 3 / 4, size.height - 90); //第二段曲线控制点
    var secondEndPoint = Offset(size.width, size.height - 40); //第二段曲线结束点
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
