
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/pk_skeleton.dart';


class DeleteCardLoad extends StatefulWidget {

  DeleteCardLoad();

  @override
  _DeleteCardLoad createState() => _DeleteCardLoad();


}

class _DeleteCardLoad extends State<DeleteCardLoad>
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 300,
                        decoration: myBoxDec(animation, isCircle: false),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        height: 20,
                        width: 300,
                        decoration: myBoxDec(animation, isCircle: false),
                      ),

                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: 60,
                            decoration: myBoxDec(animation, isCircle: false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                Container(
                  height: 60,
                  width: 100,
                  decoration: myBoxDec(animation, isCircle: false),
                ),
              ],
            ),

          );
//    );
        }
    );
  }

}
