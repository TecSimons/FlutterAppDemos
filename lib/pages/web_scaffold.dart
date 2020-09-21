import 'package:base_library/base_library.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const/_const.dart';
import 'package:flutter_app/utils/navigator_util.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../view/likebutton/like_button.dart';


class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold> {
//  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

//  WebViewController _webViewController;
//  bool _isShowFloatBtn = false;

  void _onPopSelected(String value) {
    print("_onPopSelected=="+widget.title);
    String _title = widget.title ?? IntlUtil.getString(context, widget.titleId);
    switch (value) {
      case "browser":
        NavigatorUtil.launchInBrowser(widget.url, title: _title);
        break;
      case "collection":
        break;
      case "share":
        String _url = widget.url;
        Share.share('$_title : $_url');
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    flutterWebviewPlugin.onStateChanged.listen((
//        WebViewStateChanged webViewState) async {
////      setState(() {
////        title = webViewState.type.toString();
////      });
//      switch (webViewState.type) {
//        case WebViewState.finishLoad:
//          getWebTitle();
//
//          break;
//        case WebViewState.shouldStart:
//          break;
//        case WebViewState.startLoad:
//          break;
//        case WebViewState.abortLoad:
//          break;
//      }
//    });
  }


  @override
  void dispose() {
    super.dispose();
    Navigator.of(context).pop("11");
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

        leading: IconButton(
//            icon: Icon(Icons.arrow_back, color: Colors.black),
          icon: Image.asset("assets/images/back.png", width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop("11"),
        ),
        backgroundColor: themeColor,
        title: new Text(
//        widget.title ?? IntlUtil.getString(context, widget.titleId),
          widget.title == null? "": widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: <Widget>[
          Offstage(
            offstage: widget.title == null ? true : false,
            child: LikeButton(
              width: 56.0,
              duration: Duration(milliseconds: 500),
            ),
          ),
//          new IconButton(icon: new Icon(Icons.more_vert), onPressed: () {}),
          Offstage(
            offstage: widget.title == null ? true : false,
            child: PopupMenuButton(
                padding: const EdgeInsets.all(0.0),
                onSelected: _onPopSelected,
                itemBuilder: (BuildContext context) =>
                <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                      value: "browser",
                      child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          dense: false,
                          title: new Container(
                            alignment: Alignment.center,
                            child: new Row(
                              children: <Widget>[
                                Icon(
                                  Icons.language,
                                  color: Colours.gray_66,
                                  size: 22.0,
                                ),
                                Gaps.hGap10,
                                Text(
                                  '浏览器打开',
                                  style: TextStyles.listContent,
                                )
                              ],
                            ),
                          ))),
//                    new PopupMenuItem<String>(
//                        value: "collection",
//                        child: ListTile(
//                            contentPadding: EdgeInsets.all(0.0),
//                            dense: false,
//                            title: new Container(
//                              alignment: Alignment.center,
//                              child: new Row(
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.collections,
//                                    color: Colours.gray_66,
//                                    size: 22.0,
//                                  ),
//                                  Gaps.hGap10,
//                                  Text(
//                                    '收藏',
//                                    style: TextStyles.listContent,
//                                  )
//                                ],
//                              ),
//                            ))),
                  new PopupMenuItem<String>(
                      value: "share",
                      child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          dense: false,
                          title: new Container(
                            alignment: Alignment.center,
                            child: new Row(
                              children: <Widget>[
                                Icon(
                                  Icons.share,
                                  color: Colours.gray_66,
                                  size: 22.0,
                                ),
                                Gaps.hGap10,
                                Text(
                                  '分享',
                                  style: TextStyles.listContent,
                                )
                              ],
                            ),
                          ))),
                ]

            ),
          ),
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {
//          _webViewController = webViewController;
//          _webViewController.addListener(() {
//            int _scrollY = _webViewController.scrollY.toInt();
//            if (_scrollY < 480 && _isShowFloatBtn) {
//              _isShowFloatBtn = false;
//              setState(() {});
//            } else if (_scrollY > 480 && !_isShowFloatBtn) {
//              _isShowFloatBtn = true;
//              setState(() {});
//            }
//          });
        },

        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
//      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  //获取h5页面标题
//  Future<String> getWebTitle() async {
//    String script = 'window.document.title';
//    var title = await
//    flutterWebviewPlugin.evalJavascript(script);
//    setState(() {
//     titleName= title;
//      print('####################   $title');
//    });
//  }


//  Widget _buildFloatingActionButton() {
//    if (_webViewController == null || _webViewController.scrollY < 480) {
//      return null;
//    }
//    return new FloatingActionButton(
//        heroTag: widget.title ?? widget.titleId,
//        backgroundColor: Theme.of(context).primaryColor,
//        child: Icon(
//          Icons.keyboard_arrow_up,
//        ),
//        onPressed: () {
//          _webViewController.scrollTop();
//        });
//  }
}
