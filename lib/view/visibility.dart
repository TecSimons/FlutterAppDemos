import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

enum VisibilityFlag {
  visible,
  invisible,
  offscreen,
  gone,
}

class Visibility extends StatelessWidget {
  final Visibility visibility;
  final Widget child;
  final Widget removeChild;

  Visibility({
    this.child,
    @required this.visibility,
  }) : this.removeChild = Container();

  @override
  Widget build(BuildContext context) {
    if(visibility == VisibilityFlag.visible) {
      return child;
    }else if(visibility == VisibilityFlag.invisible) {
      return new IgnorePointer(
          ignoring: true,
          child: new Opacity(
              opacity: 0.0,
              child: child
          )
      );
    }else if(visibility == VisibilityFlag.offscreen) {
      return new Offstage(
          offstage: true,
          child: child
      );
    }else{
      return removeChild;
    }
  }
}