// post_item.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:intl/intl.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/posts/presentation/widgets/image_detail.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = post.createdAt;
    var time = DateFormat.jm().format(date);
    var restOfDate = DateFormat.yMMMMd().format(date);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20.h,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 10.h,
      ),
      margin: EdgeInsets.all(
        8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9.h),
            child: Row(
              children: [
                CustomImageView(
                  border: Border.all(
                    color: AppColors.gray200,
                    width: 1.h,
                  ),
                  imagePath: post.profilePicture,
                  height: 40.adaptSize,
                  width: 40.adaptSize,
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
                        '${post.firstName} ${post.lastName}',
                        style: CustomTextStyles.bodyMediumRobotoGray900,
                      ),
                      SizedBox(height: 3.v),
                      Text(
                        post.classname,
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.v),
                    post.content.isNotEmpty
              ? post.content.length == 1
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageDetailPage(
                              imageUrls: post.content,
                              initialIndex: 0,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Hero(
                        tag: post.content[0],
                        child: Material(
                          color: Colors.transparent,
                          child: CustomImageView(
                            fit: BoxFit.cover,
                            imagePath: '${EndPoints.storage}${post.content[0]}',
                            // height: 183.h,
                            // width: 329.h,
                            radius: BorderRadius.circular(
                              15.h,
                            ),
                          ),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        int crossAxisCount = post.content.length >= 2 ? 2 : 1;
                        return GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 700 / 500,
                          children: List<Widget>.generate(
                              min(post.content.length, 4), (index) {
                            String imageUrl = post.content[index];

                            // If its the last image
                            if (index == 3) {
                              // Check how many more images are left
                              int remaining = post.content.length - 4;

                              // If no more are remaining return a simple image widget
                              if (remaining == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageDetailPage(
                                          imageUrls: post.content,
                                          initialIndex: index,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: '${post.content[index]}_$index',
                                    // tag: imageUrl,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: CustomImageView(
                                        fit: BoxFit.cover,
                                        imagePath:
                                            '${EndPoints.storage}$imageUrl',
                                        radius: BorderRadius.circular(
                                          15.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Create the facebook like effect for the last image with number of remaining  images
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageDetailPage(
                                          imageUrls: post.content,
                                          initialIndex: index,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: '${post.content[index]}_$index',
                                    // tag: imageUrl,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Stack(
                                        clipBehavior: Clip.hardEdge,
                                        fit: StackFit.expand,
                                        children: [
                                          CustomImageView(
                                            fit: BoxFit.cover,
                                            imagePath:
                                                '${EndPoints.storage}$imageUrl',
                                            radius: BorderRadius.circular(
                                              15.h,
                                            ),
                                          ),
                                          if (remaining > 0)
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15.h,
                                                ),
                                              ),
                                              child: Text(
                                                '+' + remaining.toString(),
                                                style: TextStyle(
                                                    fontSize: 32,
                                                    color: AppColors.whiteA700),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageDetailPage(
                                        imageUrls: post.content,
                                        initialIndex: index,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: '${post.content[index]}_$index',
                                  // tag: imageUrl,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: CustomImageView(
                                      fit: BoxFit.cover,
                                      imagePath:
                                          '${EndPoints.storage}$imageUrl',
                                      radius: BorderRadius.circular(
                                        15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                        );
                      },
                    )
              : SizedBox.shrink(),

          SizedBox(height: 12.v),
          Container(
            width: 297.h,
            margin: EdgeInsets.only(right: 39.h),
            child: Text(
              post.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge!.copyWith(
                height: 1.38,
              ),
            ),
          ),
          SizedBox(height: 11.v),

          Row(
            children: [
              Text(
                time,
                style: theme.textTheme.bodyMedium,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgUser,
                height: 10.adaptSize,
                width: 10.adaptSize,
                margin: EdgeInsets.symmetric(vertical: 3.v),
              ),
              Text(
                restOfDate,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 10.v),
          // devider
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            height: 1.h,
            color: AppColors.gray200,
          ),
          SizedBox(height: 10.v),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 5.v,
                  bottom: 7.v,
                ),
                child: Text(
                  post.likesCount.toString(),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Text(
                'Likes',
                style: theme.textTheme.bodyMedium,
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: 5.v,
                  bottom: 7.v,
                ),
                child: Text(
                  post.commentsCount.toString(),
                  style: theme.textTheme.bodyLarge,
                ),
              ),

              Text(
                'Comments',
                style: theme.textTheme.bodyMedium,
              ),
              // TODO : implement the bookmarks count
              Text(
                '0',
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                'Saves',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 10.v),
          // devider
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            height: 1.h,
            color: AppColors.gray200,
          ),
        ],
      ),
    );
  }
}
