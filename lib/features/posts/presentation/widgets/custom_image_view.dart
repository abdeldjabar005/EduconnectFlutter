// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CustomImageView extends StatefulWidget {
  ///[imagePath] is required parameter for showing image
  String? imagePath;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  @override
  State<CustomImageView> createState() => _CustomImageViewState();
}

class _CustomImageViewState extends State<CustomImageView> {
  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (widget.radius != null) {
      return ClipRRect(
        borderRadius: widget.radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (widget.border != null) {
      return Container(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (widget.imagePath != null) {
      switch (widget.imagePath!.imageType) {
        case ImageType.svg:
          return Container(
            height: widget.height,
            width: widget.width,
            child: SvgPicture.asset(
              widget.imagePath!,
              height: widget.height,
              width: widget.width,
              fit: widget.fit ?? BoxFit.contain,
              colorFilter: widget.color != null
                  ? ColorFilter.mode(
                      this.widget.color ?? Colors.transparent, BlendMode.srcIn)
                  : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(widget.imagePath!),
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            color: widget.color,
          );
        case ImageType.network:
          return CachedNetworkImage(
            memCacheWidth: 700,
            memCacheHeight: 500,
            // maxHeightDiskCache: 183,
            // maxWidthDiskCache: 329,
            imageBuilder: (context, imageProvider) =>
                Image(image: imageProvider),
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
            imageUrl: widget.imagePath!,
            color: widget.color,
            placeholder: (context, url) => Container(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              widget.placeHolder,
              height: widget.height,
              width: widget.width,
              fit: widget.fit ?? BoxFit.cover,
            ),
          );
        case ImageType.video:
          final VlcPlayerController controller = VlcPlayerController.network(
            widget.imagePath!,
            hwAcc: HwAcc.auto,
            autoPlay: false,
            autoInitialize: true,
          );
          return VlcPlayer(
            controller: controller,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          );

        // case ImageType.text:
        //   String contents = File(imagePath!).readAsStringSync();
        //   return Text(contents);
        case ImageType.text:
          Future<String> contents = File(widget.imagePath!).readAsString();
          return FutureBuilder<String>(
            future: contents,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        case ImageType.pdf:
          return PDFView(
            filePath: widget.imagePath!,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
          );
        case ImageType.png:
        default:
          return Image.asset(
            widget.imagePath!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            color: widget.color,
          );
      }
    }
    return SizedBox();
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      if (this.endsWith('.mp4')) {
        return ImageType.video;
      } else {
        return ImageType.network;
      }
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else if (this.endsWith('.txt')) {
      return ImageType.text;
    } else if (this.endsWith('.pdf')) {
      return ImageType.pdf;
    } else {
      return ImageType.unknown;
    }
  }
}

enum ImageType { svg, png, network, file, video, text, pdf, unknown }
