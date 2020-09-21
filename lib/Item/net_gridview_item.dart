import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/router/routes.dart';

import 'net_gridview_entity.dart';

class NetGridViewItem extends StatefulWidget {
  NetGridViewItem(this.item);

  final NetGridViewEntity item;

  @override
  _NetGridViewState createState() {
    return _NetGridViewState();
  }
}

class _NetGridViewState extends State<NetGridViewItem> {
  _NetGridViewState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _itemClicked(widget.item.url),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color(0xff999999), blurRadius: 2, offset: Offset(0.5, 0.5))
        ], borderRadius: BorderRadius.circular(4), color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                child: Image.network(
                  widget.item.url,
                  fit: BoxFit.cover,
                ),
                constraints: BoxConstraints.expand(),
              ),
              Container(
                constraints:
                    BoxConstraints.expand(width: double.infinity, height: 30),
                color: Colors.black26,
                child: Center(
                  child: Text(
                    widget.item.desc,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemClicked(url) {
    List<String> imgList = List();
    imgList.add(url);
    var param = {'initIndex': 0, 'imagesList': imgList};
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      Routes.navigateTo(context, '/imagePreview',
          params: {'data': json.encode(param)});
    });
  }
}
