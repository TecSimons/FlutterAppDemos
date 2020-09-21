import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app/net/log/Log.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert' as convert;

class ImagePreview extends StatefulWidget {
  final data;
  final Uint8List datas;

  ImagePreview({@required this.datas,this.data});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  PageController _pageController;
  int _currentIndex;
  var data;
  ByteData datas;

  @override
  void initState() {
    if(widget.data!=null) {
      data = convert.jsonDecode(widget.data);
      _currentIndex = data['initIndex'];
    }else{
      _currentIndex=0;
    }
      super.initState();
      _pageController = PageController(initialPage: _currentIndex);

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
          // backgroundDecoration: BoxDecoration(color: Colors.white),
          reverse: false,
          pageController: _pageController,
          scrollPhysics: BouncingScrollPhysics(),
          onPageChanged: _onPageChanged,
          itemCount: widget.data!=null?data['imagesList'].length:1,
          builder: (BuildContext context, int index) {
            if(widget.data!=null) {
              var item = data['imagesList'][index];
              return PhotoViewGalleryPageOptions(
                imageProvider: setItem(item),
                minScale: PhotoViewComputedScale.contained * 0.6,
                maxScale: PhotoViewComputedScale.covered * 1.1,
                initialScale: PhotoViewComputedScale.contained,
              );
            }else{
              return PhotoViewGalleryPageOptions(
                imageProvider: MemoryImage(widget.datas),
                minScale: PhotoViewComputedScale.contained * 0.6,
                maxScale: PhotoViewComputedScale.covered * 1.1,
                initialScale: PhotoViewComputedScale.contained,
              );
            }
          }),
    );
  }

  _closeView(BuildContext context) {
    Navigator.pop(context);
  }

  setItem(item) {
    Log.info("ImagePreviewitem=="+item);
    if(item.toString().substring(0,4).toLowerCase()=="http"){
      return  NetworkImage(item);
    }else if(item.toString().substring(0,4).toLowerCase()=="file"){
      return   FileImage(item);
    }else{
      return   AssetImage(item);
    }
  }
}
