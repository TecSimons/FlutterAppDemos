import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/second_view.dart';
import 'package:flutter_app/router/routes.dart';
import 'package:flutter_app/utils/ToastUtil.dart';
import 'package:flutter_app/view/rate.dart';

import '../main.dart';

class DeleteCard extends StatelessWidget {
  final DeleteCardViewModel data;

  const DeleteCard({
    Key key,
    this.data,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
//      resizeToAvoidBottomPadding: false, //输入法顶布局
//      body: Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.publishContent,
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
                      '${data.topic}  ${data.likes}评论',
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
            onTap: () => _showViewUrl(context),
            child: Image.network(
              data.coverUrl,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }






  void _showViewUrl(BuildContext context) {
    List<String> imgList = List();
    imgList.add(data.coverUrl);
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
  }
}

class DeleteCardViewModel {
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

  DeleteCardViewModel({
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
