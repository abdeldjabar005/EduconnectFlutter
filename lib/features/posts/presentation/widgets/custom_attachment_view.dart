import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomAttachmentView extends StatelessWidget {
  final String filePath;

  CustomAttachmentView({required this.filePath});

  Future<void> _launchURL() async {
    if (await canLaunchUrlString(filePath)) {
      await launchUrlString(filePath);
    } else {
      throw 'Could not launch $filePath';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: const Card(
        elevation: 0,
        child: ListTile(
          leading: Icon(Icons.attach_file, size: 33, color: Colors.black),
          // leading: Image.asset(
          //   ImageConstant.attachmentBlack,
          //   width: 33,
          //   height: 33,
          //   fit: BoxFit.cover,
          // ),
          title: Text(
              // filePath.split('/').last,
              'PDF File'),
          subtitle: Text('Tap to view/download'),
        ),
      ),
    );
  }
}
