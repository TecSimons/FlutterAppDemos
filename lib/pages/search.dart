import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const/color_const.dart';
import 'package:flutter_app/entity/hot_key_entity.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/viewModel/hot_key_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Search();
}

class _Search extends State<SearchPage> {
  HotKeyViewModel _hotKeyViewModel = HotKeyViewModel();
  TextEditingController _searcherController = TextEditingController();
  bool _showClear = false;
  List<HotKeyEntity> _list = new List();

  @override
  void initState() {
    _hotKeyViewModel.getHotKey();
    super.initState();
  }

  @override
  void dispose() {
    _hotKeyViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: _hotKeyViewModel.hotStream,
        builder: (context, snap) {
          _list = snap.data;
          return new Scaffold(
            appBar: AppBar(
              backgroundColor: themeColor,
              leading: IconButton(
                icon: Image.asset("assets/images/back.png",width: 24,height: 24),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Expanded(
              child:Container(
                height: 34,
                padding: EdgeInsets.only(left: 5),
                margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: CenterColor,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: boardColor,
                        width: 1.2,
                        style: BorderStyle.solid)),
                child: TextField(
                    style: TextStyle(
                    color: WHITE, //字体颜色
                    fontSize: 14.0, //字体大小，注意flutter里面是double类型
                    fontWeight: FontWeight.normal, //字体粗细
                  ),

                  controller: _searcherController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  onChanged: _onInputChanged,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
//                      border: InputBorder.none,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "搜索",
                      hintStyle: TextStyle(fontSize: 14, color: WHITE),
                      suffixIcon: _showClear
                          ? GestureDetector(
                              child: Icon(
                                Icons.clear,
                                color: WHITE,
                              ),
                              onTap: _onClearClicked)
                          : null),
                ),
              ),
              ),
              actions: <Widget>[
                GestureDetector(
                  child: Icon(Icons.search),
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _search(_searcherController.text),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                )
              ],
            ),
            body: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "大家都在搜",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: (Icon(Icons.delete, color: TEXT_BLACK)),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildCupertinoAlertDialog(context)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                    ),
                    new Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _renderHotContainer(),
                    ),
                  ],
                )),
          );
        });
  }

  List<Widget> _renderHotContainer() {
    List<Widget> widgets = new List();
    if (_list != null && _list.length > 0) {
      for (var item in _list) {
        widgets.add(GestureDetector(
            child: ActionChip(
                label: new Text(
                  item.name,
                  style: TextStyle(fontSize: 13, color: WHITE),
                ),
                backgroundColor: themeColor,
                padding: const EdgeInsets.all(5),
                onPressed: () => _search(item.name))));
      }
    }
    return widgets;
  }

  _onInputChanged(String s) {
    if (s != null && s.length > 0 && !_showClear) {
      setState(() {
        _showClear = true;
      });
    } else if (s.length == 0 && _showClear) {
      setState(() {
        _showClear = false;
      });
    }
  }

  _onClearClicked() {
    _searcherController.clear();
    setState(() {
      _showClear = false;
    });
  }

  _search(String value) {
    Log.info("searchValue==" + value);
    FocusScope.of(context).requestFocus(new FocusNode());
//    Navigator.of(context).push(
//        new MaterialPageRoute(builder: (context) => SearchResult(value)));
  }

  Widget _buildCupertinoAlertDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: Text(
          '清空历史记录',
          style: TextStyle(
            color: Colors.red,
            fontSize: ScreenUtil().setSp(48),
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Column(children: <Widget>[
            Text(
              '是否确定要清空历史记录?',
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenUtil().setSp(36)),
            ),
          ]),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('确定!'),
            onPressed: () {
              Routes.pop(context);
              _deleteAllHistory();
            },
          ),
          CupertinoButton(
            child: Text('取消'),
            onPressed: () => Routes.pop(context),
          ),
        ],
      ),
    );
  }

  //删除数据所有记录
  _deleteAllHistory() async {
    setState(() {
      _list.clear();
    });
  }
}
