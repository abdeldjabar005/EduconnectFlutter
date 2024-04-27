import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/comment_detail.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/posts/presentation/widgets/reply_item.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _textController = TextEditingController();
  List<XFile>? images;
  String type = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<AuthCubit>().state as AuthAuthenticated).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: const BackButton(
          color: Colors.black,
          style: ButtonStyle(),
        ),
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
                BorderSide(color: Colors.black.withOpacity(0.1))),
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 13.h,
            vertical: 10.h,
          ),
          margin: EdgeInsets.all(
            12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Row(
                  children: [
                    CustomImageView(
                      border: Border.all(
                        color: AppColors.gray200,
                        width: 1.h,
                      ),
                      imagePath: ImageConstant.imgRectangle17100x100,
                      // imagePath: '${EndPoints.storage}${user.profilePicture}',

                      height: 60.adaptSize,
                      width: 60.adaptSize,
                      radius: BorderRadius.circular(
                        20.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.h,
                        top: 3.v,
                        bottom: 3.v,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: CustomTextStyles.bodyMediumRobotoGray900,
                          ),
                          SizedBox(height: 3.v),
                          Text(
                            'parent', //TODO: Replace with actual implementation
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.v),
              Container(
                width: 297.h,
                margin: EdgeInsets.only(right: 39.h),
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write something ...",
                    hintStyle: theme.textTheme.bodyLarge!.copyWith(
                      height: 1.38,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70.v),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      bool pickImage = true;
                      if (images == null || images!.isEmpty) {
                        // Ask the user if they want to pick a picture or a video.
                        pickImage = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Pick Pictures or a Video?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Picture'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Video'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ) ??
                            true; // Default to picking a picture.
                      } else {
                        pickImage = type == 'picture';
                      }
                      if (pickImage) {
                        // Let the user pick multiple pictures.
                        final List<XFile> pickedImages =
                            await _picker.pickMultiImage();
                        if (pickedImages.isNotEmpty) {
                          setState(() {
                            images = [...?images, ...pickedImages];
                            type = 'picture';
                          });
                        }
                      } else {
                        // Let the user pick a video.
                        final XFile? video = await _picker.pickVideo(
                            source: ImageSource.gallery);
                        if (video != null) {
                          setState(() {
                            images = [video];
                            type = 'video';
                          });
                        }
                      }
                    },
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.gallery,
                          height: 33.adaptSize,
                          width: 33.adaptSize,
                          margin: EdgeInsets.symmetric(vertical: 3.v),
                        ),
                        SizedBox(width: 17.h),
                        Text(
                          'Photo/Video',
                          style: CustomTextStyles.bodyMediumRobotoGray9002,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 13.v),
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      bool takePicture = true;
                      if (images == null || images!.isEmpty) {
                        // Ask the user if they want to take a picture or a video.
                        takePicture = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Take a Picture or a Video?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Picture'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Video'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ) ??
                            true; // Default to taking a picture.
                      } else {
                        takePicture = type == 'picture';
                      }
                      if (takePicture) {
                        // Let the user take a picture.
                        final XFile? picture =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (picture != null) {
                          setState(() {
                            images = [...?images, picture];
                            type = 'picture';
                          });
                        }
                      } else {
                        // Let the user record a video.
                        final XFile? video =
                            await _picker.pickVideo(source: ImageSource.camera);
                        if (video != null) {
                          setState(() {
                            images = [video];
                            type = 'video';
                          });
                        }
                      }
                    },
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.camera,
                          height: 33.adaptSize,
                          width: 33.adaptSize,
                          margin: EdgeInsets.symmetric(vertical: 3.v),
                        ),
                        SizedBox(width: 17.h),
                        Text(
                          'Camera',
                          style: CustomTextStyles.bodyMediumRobotoGray9002,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 13.v),
                  Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.attachment,
                        height: 33.adaptSize,
                        width: 33.adaptSize,
                        margin: EdgeInsets.symmetric(vertical: 3.v),
                      ),
                      SizedBox(width: 17.h),
                      Text(
                        'Attachment',
                        style: CustomTextStyles.bodyMediumRobotoGray9002,
                      ),
                    ],
                  ),
                  SizedBox(height: 13.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.poll, // purple Poll
                            height: 33.adaptSize,
                            width: 33.adaptSize,
                            margin: EdgeInsets.symmetric(vertical: 3.v),
                          ),
                          SizedBox(width: 17.h),
                          Text(
                            'Poll',
                            style: CustomTextStyles.bodyMediumRobotoGray9002,
                          ),
                        ],
                      ),
                      _buildButton2(context, "Post"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton2(BuildContext context, String buttonText) {
    return CustomElevatedButton(
      height: 40.v,
      width: 127.h,
      onPressed: () {
        String text = _textController.text;
        if (text.isEmpty) {
          print('Please enter some text.');
        } else {
          print('Text: $text');
          // context.read<Post>().newPost(...);
        }
      },
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.indigoA300),
      ),
      text: buttonText,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins12,
    );
  }
}
