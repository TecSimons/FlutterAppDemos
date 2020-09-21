import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_view.dart';
import 'package:flutter_app/pages/second_view.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/view/rate.dart';

import '../main.dart';


class GridCard extends StatelessWidget {
  final GridCardViewModel data;

  const GridCard({
    Key key,
    this.data,
  }) : super(key: key);

  Widget renderCover(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showViewUrl(context);
      },
      child: Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Image.network(
            data.coverUrl,
            height: 100,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          left: 0,
          top: 100,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 0, 0, 0),
                  Color.fromARGB(80, 0, 0, 0),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget renderUserInfo() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFCCCCCC),
                backgroundImage: NetworkImage(data.userImgUrl),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.userName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),
//          Text(
//            data.publishTime,
//            style: TextStyle(
//              fontSize: 10,
//              color: Color(0xFF999999),
//            ),
//          ),
        ],
      ),
    );
  }

  Widget renderPublishContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFC600),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    '# ${data.topic}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      accentColor: Colors.red,
                      disabledColor: Colors.deepOrangeAccent),
                  child: SyRate(
                    iconSize: 10.0,
                    onTap: (v) {
//                      print(v);
                    },
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget renderInteractionArea(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _clickComment(context);
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: 16,
                  color: Color(0xFF992244),
                ),
                Padding(padding: EdgeInsets.only(left: 6)),
                Text(
                  data.replies.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _clicklike(context);
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: Color(0xFFFFC600),
                ),
                Padding(padding: EdgeInsets.only(left: 6)),
                Text(
                  data.likes.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _clickShare(context);
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.share,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                Padding(padding: EdgeInsets.only(left: 6)),
                Text(
                  data.shares.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      resizeToAvoidBottomPadding: false, //输入法顶布局
//      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Container(
          margin: EdgeInsets.fromLTRB(10,20, 10, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                spreadRadius: 4,
                color: Color.fromARGB(20, 0, 0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              this.renderCover(context),
              this.renderUserInfo(),
              this.renderPublishContent(context),
            ],
          ),
        ),
      );
//    );
  }

  void _clickComment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
    );
  }
  void _clickShare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondScreen()),
    );

  }
  void _clicklike(BuildContext context) {
    ToastUtil.showToast(data.likes.toString());
  }

  void _showViewUrl(BuildContext context) {
    List<String> imgList=List();
    imgList.add(data.coverUrl);
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
  }
}

class GridCardViewModel {
  /// 封面地址
   String coverUrl;

  /// 用户头像地址
   String userImgUrl;

  /// 用户名
   String userName;

  /// 用户描述
   String description;

  /// 话题
   String topic;

  /// 发布时间
   String publishTime;

  /// 发布内容
   String publishContent;

  /// 回复数量
   int replies;

  /// 喜欢数量
  int likes;

  /// 分享数量
   int shares;

   GridCardViewModel({
    this.coverUrl,
    this.userImgUrl,
    this.userName,
    this.description,
    this.topic,
    this.publishTime,
    this.publishContent,
    this.replies,
    this.likes,
    this.shares,
  });
}
