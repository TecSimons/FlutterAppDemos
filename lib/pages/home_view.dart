import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/const/size_const.dart';
import 'package:flutter_app/const/string_const.dart';
import 'package:flutter_app/entity/message_data_entity.dart';
import 'package:flutter_app/entity/search_data_entity_entity.dart';
import 'package:flutter_app/pages/pet_view.dart';
import 'package:flutter_app/utils/GradientUtil.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/view/AboutMeTitle.dart';
import 'package:flutter_app/view/NetLoadingDialog.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../YColors.dart';
import 'pull_list_view.dart';

class HomeView extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
//  final String title;

  @override
  _MyHomeView createState() => _MyHomeView();
}

class _MyHomeView extends State<HomeView> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  String imageurl = "assets/images/scroll1.png";
  String titTag = "哈哈";
  var textColor = TOAST_BG;
  double textSize = 18;
  String _inputText = "12345679";
  String _inputLabel = "this is dialog";
  bool isTrue = false;
  MaterialButton dialog;

  bool mSelectNetData=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void _incrementCounter() {
    _showLoadding(context);

//    requestData();
  }

  void requestData() {
    Map<String, String> headers = new Map<String, String>();
    headers['Authorization'] =
        "665E6FA1883E8E62B957EDD740BFE81CEFAA554ACAFE8D5F577C5EE3E8AF8B3F8635032066AE4BA3D5";
    //      String jsonStr = json.encode(SearchEntity.getData("黄桥乡7号"));
    String jsonStr = SearchDataEntityEntity.getData("黄桥乡7号");
    print("jsonStr==" + jsonStr);

    http
        .post(
            'http://agric.v2.winoble.cn/api/NoticeMsg/Search?p.retrieveTotalCount=true&p.pageSize=1&p.PageIndex=1',
            body: jsonStr,
            encoding: Utf8Codec(),
            headers: headers)
        .then((http.Response response) {
      setState(() {
        Map dataEntity = json.decode(response.body);
        MessageDataEntity data = new MessageDataEntity().fromJson(dataEntity);

        print("success==" + data.paper.pageCount.toString());
        setState(() {
          _inputText = data.data[0].msg;
        });
        //        print("successo11=="+response.body);
        //        _showDialog(data.data[0].label, _inputText);
      });
    }).catchError((error) {
      ToastUtil.showToast("网络错误");
    });
  }

  void _showDialog(String titile, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titile),
            content: Text(content),
            actions: [
              FlatButton(
                child: Text("取消"),
                textColor: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _haveNewVersion(String titles) {
    showModalBottomSheet(
        context: context,
        // 关键代码
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (stateContext, state) {
            return GestureDetector(
              onTap: clickPopHead,
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 350,
                    minHeight: 150,
                  ),
                  decoration: BoxDecoration(
                      gradient: GradientUtil.yellowGreen(),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _header(),
                      Expanded(
                        child: Container(
                          child: _menuList(titles),
                        ),
                      ),
                      AboutMeTitle(),
                    ],
                  ),
                ),
              ),
              // 关键代码
              onVerticalDragUpdate: (e) => false,
            );
          });
        });
  }

  void _clickMenu(context, String titles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: clickPopHead,
        child: Container(
          constraints: BoxConstraints(maxHeight: 370, minHeight: 150),
          child: Material(
            color: YColors.GREEN,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _header(),
                Expanded(
                  child: Container(
                    child: _menuList(titles),
                  ),
                ),
                AboutMeTitle(),
              ],
            ),
          ),
        ),
        onVerticalDragUpdate: (e) => false,
      ),
    );
  }

  Widget _menuList(String titles) {
    return ListView.builder(
      itemBuilder: (context, index) {
//        return _menuItem(context, "56454");
        return _menuItem(context, titles);
      },
      itemCount: 10,
    );
  }

  Widget _menuItem(context, titles) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.only(bottom: 1.0),
        decoration: BoxDecoration(gradient: GradientUtil.greenPurple()),
        constraints: BoxConstraints.expand(height: 60.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                titles,
                style: TextStyle(
                    color: TEXT_BLACK_LIGHT,
                    fontSize: TEXT_NORMAL_SIZE,
                    fontWeight: FontWeight.w700),
              ),
            ]
//            Divider(
//              height: 1.0,
//              color: Colors.white,
//            )
//          ],
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        ToastUtil.showToast(titles);
      },
    );
  }

  Widget _header() {
    return Ink(
      child: GestureDetector(
        onTap: () {
          clickPopHead();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            gradient: GradientUtil.yellowGreen(),
          ),
          constraints: BoxConstraints.expand(height: 60.0),
          child: Center(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: AssetImage("assets/images/ic_launcher.png"),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  StringConst.CREATE_BY,
                  style: TextStyle(
                      color: TEXT_BLACK_LIGHT, fontSize: TEXT_NORMAL_SIZE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDoubleClick() {
    setState(() {
      if (!isTrue) {
        imageurl = "assets/images/scroll3.png";
        titTag = "43455";
        textColor = TOAST_BG;
        textSize = 12;
      } else {
        imageurl = "assets/images/scroll1.png";
        titTag = "哈哈";
        textColor = TEXT_BLACK_LIGHT;
        textSize = 18;
      }
      isTrue = !isTrue;
      print("successo12==" + _inputText);
    });

    http
        .get('http://wthrcdn.etouch.cn/weather_mini?city=%E8%A5%BF%E5%8D%8E')
        .then((http.Response response) {
      print("success==" + response.body);
    }).catchError((error) {
      print('$error错误');
    });
  }

  void _jumpSecondView() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SecondScreen()),
//    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetView()),
    );
  }

  void clickPopHead() {
    ToastUtil.showToast("SUCCESS");
    Navigator.pop(context);
  }

  void _jumpListView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PullListView()),
    );
  }

  void _showLoadding(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new NetLoadingDialog(
            dismissDialog: _disMissCallBack,
            outsideDismiss: true,
          );
        });
  }

  _disMissCallBack(Function func) {
    Map<String, String> headers = new Map<String, String>();
    headers['Authorization'] =
        "665E6FA1883E8E62B957EDD740BFE81CEFAA554ACAFE8D5F577C5EE3E8AF8B3F8635032066AE4BA3D5";
    //      String jsonStr = json.encode(SearchEntity.getData("黄桥乡7号"));
    String jsonStr = SearchDataEntityEntity.getData("黄桥乡7号");
    print("jsonStr==" + jsonStr);

    http.post(
            'http://agric.v2.winoble.cn/api/NoticeMsg/Search?p.retrieveTotalCount=true&p.pageSize=1&p.PageIndex=1',
            body: jsonStr,
            encoding: Utf8Codec(),
            headers: headers)
        .then((http.Response response) {
      setState(() {
        Map dataEntity = json.decode(response.body);
        MessageDataEntity data = new MessageDataEntity().fromJson(dataEntity);
        print("success==" + data.paper.pageCount.toString());
        _inputText = data.data[0].msg;

        //        print("successo11=="+response.body);
        //        _showDialog(data.data[0].label, _inputText);
        func();
        ToastUtil.showToast("数据获取成功");
      });
    }).catchError((error) {
      func();
      ToastUtil.showToast("网络错误");
    });
  }

  void _addCount() {
    setState(() {
      _counter++;
    });
  }

  bool status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false, //输入法顶布局
        body: CustomScrollView(
          shrinkWrap: true,
          // 内容
          slivers: <Widget>[
            new SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: new TextField(
                        style: TextStyle(
                          color: YColors.colorPrimary, //字体颜色
                          fontSize: 15.0, //字体大小，注意flutter里面是double类型
                          fontWeight: FontWeight.normal, //字体粗细
                        ),

                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                // 设置内容
                                text: _inputText,
                                // 保持光标在最后
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.downstream,
                                        offset: _inputText.length)))),
                        onChanged: (value) {
                          _inputText = value;
                        },
                        enableInteractiveSelection: true,
                        //禁用长按复制 剪切
                        autocorrect: false,
//        obscureText: true,  //隐藏文字
                        decoration: InputDecoration(hintText: "请输入昵称"), //无下划线
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: GestureDetector(
//          onTap: _incrementCounter,
                        onDoubleTap: _onDoubleClick,
                        child: Text(
                          'You have pushed the button this many times:',
                          style: TextStyle(
                              color: YColors.colorPrimaryDark, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Text(
                      '$_counter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: YColors.colorPrimary,
                        //字体颜色
                        fontSize: 50.0,
                        //字体大小，注意flutter里面是double类型
                        fontWeight: FontWeight.bold,
                        //字体粗细
                        letterSpacing: 10.0,
                        //字体间距
                        wordSpacing: 30.0, //词间距
                      ),
                    ),
                    Container(
                      child: (new GestureDetector(
                        onTap: _jumpSecondView,
                        child: new Image.network(
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554110093883&di=9db9b92f1e6ee0396b574a093cc987d6&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20%2F151%2Fw2048h1303%2F20180429%2F37c0-fzvpatr1915813.jpg',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        _jumpListView();
                      },
                      child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: new ExactAssetImage(imageurl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _addCount();
                                  },
                                  child: Text(
                                    titTag,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFFdd5522)),
                                  ),
                                ),
                                new Text(
                                  titTag,
                                  style: TextStyle(
                                      fontSize: textSize, color: textColor),
                                ),
                              ])),
                    ),
                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: GestureDetector(
//          onTap: _showDialogs,
                            onTap: () {
                              _haveNewVersion("test1236");
//                      _clickMenu(context, "test1236");
                            },
                            // 距离上一个组件的margin
                            child: new ClipRRect(
                              // 圆角
                              borderRadius: BorderRadius.circular(10.0),
                              child: new Image.network(
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1554110093883&di=9db9b92f1e6ee0396b574a093cc987d6&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn20%2F151%2Fw2048h1303%2F20180429%2F37c0-fzvpatr1915813.jpg",
                                width: window.physicalSize.width,
                                height: 240.0,
                                //类似于Android的scaleType 此处让图片尽可能小 以覆盖整个widget
                                fit: BoxFit.cover,
                              ),
                            ))),

                    Container(
                      margin: EdgeInsets.only(top:10,left: 140, right: 140),
                      child: FlutterSwitch(
//                        height: 30,
//                        width: 100,
                        activeColor: Colors.red,
                        inactiveColor: Colors.red[200],
                        toggleColor: Colors.white,
                        value: status,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:20,left: 111, right: 111),
                      child: LiteRollingSwitch(
                        textOn: 'active',
                        textOff: 'inactive',
                        value: false,
                        onChanged: (bool state) {
                          print('turned ${(state) ? 'on' : 'off'}');
                        },
                      ),
                    ),

                    //Customized
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 111, right: 111),
                      child: LiteRollingSwitch(
                        value: true,
                        textOn: 'on',
                        textOff: 'off',
                        colorOn: Colors.deepOrange,
                        colorOff: Colors.blueGrey,
                        iconOn: Icons.lightbulb_outline,
                        iconOff: Icons.power_settings_new,
                        onChanged: (bool state) {
                          print('turned ${(state) ? 'on' : 'off'}');
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top:20),
                      height: 34,
                      width: 200,
                      child: CupertinoSwitch(
                        value: mSelectNetData,
                        onChanged: (bool value) {
                          setState(() {
                            mSelectNetData = value;
                          });
                        },
                      )
                    ),

                  ],
                ),
              ),
            ),
          ], // This trailing comma makes auto-formatting nicer for build methods.
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>  true;
}
