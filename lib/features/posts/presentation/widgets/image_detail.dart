import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';

class ImageDetailPage extends StatefulWidget {
  final List<String?> imageUrls;
  final int initialIndex;

  ImageDetailPage({required this.imageUrls, this.initialIndex = 0});

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          
          tag: '${widget.imageUrls[_currentIndex]}_$_currentIndex',
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              return Material(
                child: CustomImageView(
                  imagePath: '${EndPoints.storage}${widget.imageUrls[index]}',
                  radius: BorderRadius.circular(
                    15.h,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}