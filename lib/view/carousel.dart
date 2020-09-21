import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/router/routes.dart';

class SyCarousel extends StatefulWidget {
  final bool autoPlay; //是否自动播放
  final Duration playInterval; //自动切换的时间间隔
  final Duration playDuration; //动画时长
  final int initIndex; //初始播放位置,从0开始
  final double dotSize; //指示器大小
  final Curve curve; //动画效果
  final bool showIndicators; //是否显示指示器
  final Axis scrollDirection; //滚动方向
  final double viewportFraction; //每个页面在滚动方向占据的视窗比例，默认为 1
  final List<Widget> children;
  final List<String> listImg;
  final int _length;

  SyCarousel(
      {@required this.children,
      this.playInterval,
      this.autoPlay = false,
      this.initIndex = 0,
      this.dotSize = 8.0,
      this.curve = Curves.fastOutSlowIn,
      this.playDuration,
      this.showIndicators = true,
      this.listImg,
      this.scrollDirection = Axis.horizontal,
      this.viewportFraction = 1.0})
      : _length = children.length,
        assert(children.length > 0, 'children 数量必须大于零'),
        assert(viewportFraction > 0.0),
        assert(
            (initIndex >= 0) && (initIndex < children.length), 'initIndex 越界');

  @override
  SyCarouselState createState() {
    return new SyCarouselState();
  }
}

class SyCarouselState extends State<SyCarousel>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin,WidgetsBindingObserver {
  PageController _pageController;
  Timer timer;
  int _currentPage;
  int _realCurrentPage;


  Duration playInterval;
  Duration playDuration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //如果初始值是0，往左就滑不动了，所以给它赋一个大于零的值
    _currentPage = 100 * widget._length + widget.initIndex;

    _realCurrentPage = widget.initIndex;
    _pageController = PageController(
        initialPage: _currentPage, viewportFraction: widget.viewportFraction);

    if (widget.autoPlay) {
       playInterval = widget.playInterval ?? Duration(seconds: 3);
       playDuration = widget.playDuration ?? Duration(seconds: 1);
      timer = Timer.periodic(playInterval, (Timer t) {
        int toPage = _currentPage = _currentPage + 1;
        setState(() {
          _currentPage = toPage;
        });
        _pageController.animateToPage(toPage,
            duration: playDuration, curve: widget.curve);
      });
    }
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台

        if(timer==null){
          timer = Timer.periodic(playInterval, (Timer t) {
            int toPage = _currentPage = _currentPage + 1;
            setState(() {
              _currentPage = toPage;
            });
            _pageController.animateToPage(toPage,
                duration: playDuration, curve: widget.curve);
          });
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        if (timer != null) {
          timer.cancel();
          timer=null;
        }
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }


  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: GestureDetector(
              onTap: _showTabImage,
               child:PageView.builder(
                controller: _pageController,
                scrollDirection: widget.scrollDirection,
                itemBuilder: (context, i) {
                  int index = i % widget._length;
                  return widget.children[index];
                },
                onPageChanged: _onPageChanged))),
        _buildIndicators(),
      ],
    );
    }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _realCurrentPage = index % widget._length;
    });
  }


  void _showTabImage() {
    print("widget.listImg=="+widget.listImg.length.toString());
    if(widget.listImg!=null){
    List<String> imgList = List();
    imgList.add(widget.listImg[_realCurrentPage].toString());
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
   }
}

  Widget _buildIndicators() {
    if (!widget.showIndicators) {
      return Container();
    }
    List<Widget> widgets = [];
    for (int i = 0; i < widget._length; i++) {
      Color color =
          _realCurrentPage == i ? themeColor: Colors.white;
      widgets.add(Container(
        margin: EdgeInsets.only(right: widget.dotSize),
        width: widget.dotSize * (_realCurrentPage == i ? 2 : 1),
        height: widget.dotSize / 2,
        decoration: ShapeDecoration(shape: StadiumBorder(), color: color),
      ));
    }
    return Stack(alignment: Alignment.center, children: <Widget>[
      Positioned(
        bottom: 10.0,
        child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
