

import 'package:flutter/material.dart';

import 'pk_skeleton.dart';






class PetCardLoad extends StatefulWidget {

  PetCardLoad();
//  PetCardLoad({Key key}) : super(key: key);

  @override
  _PKPetCardLoad createState() => _PKPetCardLoad();
}

class _PKPetCardLoad extends State<PetCardLoad>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget renderCover(BuildContext context) {

     return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Container(
              height: 200,
              decoration: myBoxDec(animation),
            ),
//              child: Image.network(
//                widget.data.coverUrl,
//                height: 200,
//                fit: BoxFit.fitWidth,
//              ),
          ),

        ],
    );
  }

  Widget renderUserInfo() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: myBoxDec(animation, isCircle: true),
              ),
              Padding(padding: EdgeInsets.only(left: 8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 120,
                    decoration: myBoxDec(animation),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Container(
                    height: 15,
                    width: 120,
                    decoration: myBoxDec(animation),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 15,
            width: 30,
            decoration: myBoxDec(animation),
          ),
        ],
      ),
    );
  }

  Widget renderPublishContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 20,
                width: 80,
                decoration: myBoxDec(animation),
              ),
//              Container(
//                margin: EdgeInsets.only(bottom: 14),
//                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                decoration: BoxDecoration(
//                  color: Color(0xFFFFC600),
//                  borderRadius: BorderRadius.only(
//                    topRight: Radius.circular(8),
//                    bottomLeft: Radius.circular(8),
//                    bottomRight: Radius.circular(8),
//                  ),
//                ),
//                child: Text(
//                  '# ${widget.data.topic}',
//                  style: TextStyle(
//                    fontSize: 12,
//                    color: Colors.white,
//                  ),
//                ),
//              ),
              Container(
                height: 20,
                width: 120,
                decoration: myBoxDec(animation),
              ),
//              Theme(
//                data: Theme.of(context).copyWith(
//                    accentColor: Colors.red,
//                    disabledColor: Colors.deepOrangeAccent),
//                child: SyRate(
//                  iconSize: 16.0,
//                  onTap: (v) {
//                    print(v);
//                  },
//                ),
//              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 20,
            decoration: myBoxDec(animation),
          ),

          Container(
            margin: EdgeInsets.only(top: 5),
            height: 20,
            width: 180,
            decoration: myBoxDec(animation),
          ),
//          Text(
//            widget.data.publishContent,
//            maxLines: 2,
//            overflow: TextOverflow.ellipsis,
//            style: TextStyle(
//              fontSize: 15,
//              fontWeight: FontWeight.bold,
//              color: Color(0xFF333333),
//            ),
//          ),
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
          Container(
            height: 15,
            width: 50,
            decoration: myBoxDec(animation),
          ),
          Container(
            height: 15,
            width: 50,
            decoration: myBoxDec(animation),
          ),
          Container(
            height: 15,
            width: 50,
            decoration: myBoxDec(animation),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
//      resizeToAvoidBottomPadding: false, //输入法顶布局
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                this.renderInteractionArea(context),
              ],
            ),
          ),
        );
      },
    );
  }
}


