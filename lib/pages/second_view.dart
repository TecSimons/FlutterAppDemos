import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/application_bloc.dart';
import 'package:flutter_app/app/bloc_provider.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/const/string_const.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/spHelper.dart';
import 'package:flutter_app/view/carousel.dart';
import 'package:lottie/lottie.dart';

List<String> _images = [
  'https://gw.alipayobjects.com/zos/rmsportal/iZBVOIhGJiAnhplqjvZW.png',
  'https://gw.alipayobjects.com/zos/rmsportal/uMfMFlvUuceEyPpotzlq.png',
  StringConst.imgUrl,
  'https://gw.alipayobjects.com/zos/rmsportal/uMfMFlvUuceEyPpotzlq.png',
];

//class SecondScreen extends StatelessWidget {

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key key}) : super(key: key);

  @override
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen>
    with AutomaticKeepAliveClientMixin {
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Column(children: <Widget>[
//          Container(
//            alignment: Alignment.topLeft,
//            padding: const EdgeInsets.only(left: 10,top: 5),
//            child: RaisedButton(
//              onPressed: () {
//                try{
//                  bool isBack=Navigator.canPop(context);
//                  if(!isBack){
//                    ToastUtil.showDialogs(context,"提示","不可返回");
//                  }else{
//                    Navigator.pop(context);
//                  }
//                }catch(e){
//
//                }
//              },
//              child: Text('Go back!'),
//
//            )
//          ),
          new Container(
            height: 220.0,
            child: SyCarousel(
              autoPlay: true,
              dotSize: 10.0,
              showIndicators: true,
              children: _images.map((item) {
                return Image.network(
                  item,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) => networkImage,
              itemCount: 10,
            ),
          )
        ]),
      ),
    );
  }

  // 网络图片
  GestureDetector networkImage = new GestureDetector(
      onTap: () {
        // ignore: unnecessary_statements
        _showViewUrl;
      },
      child: Container(
          // 距离上一个组件的margin
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
//          child: new ClipRRect(
//            // 圆角
//            borderRadius: BorderRadius.circular(10.0),
            child: Lottie.asset(
              'assets/emoji_shock.json',
              width: 200,
              height: 200,
//            fit: BoxFit.fill,
            ),
//            child: new Image.network(
//              StringConst.imgUrl,
//              width: window.physicalSize.width,
//              height: 240.0,
//              //类似于Android的scaleType 此处让图片尽可能小 以覆盖整个widget
//              fit: BoxFit.cover,
//            ),
//          )
  ));

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// assets图片
Container assetsImage = new Container(
  child: new Image.asset(
    ("assets/images/scroll1.png"),
    width: window.physicalSize.width,
    height: 240.0,
    //类似于Android的scaleType 此处让图片尽可能小 以覆盖整个widget
    fit: BoxFit.cover,
  ),
);

void _showViewUrl(BuildContext context) {
  List<String> imgList = List();
  imgList.add(StringConst.imgUrl);
  var param = {'initIndex': 0, 'imagesList': imgList};
  Future.delayed(Duration(milliseconds: 100)).then((e) {
    Routes.navigateTo(context, '/imagePreview',
        params: {'data': json.encode(param)});
  });
//  Routes.navigateTo(context, '/sliverHeader');
}
