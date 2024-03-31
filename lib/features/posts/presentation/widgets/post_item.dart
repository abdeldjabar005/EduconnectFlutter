// post_item.dart
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/app_decoration.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:intl/intl.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quotes/features/posts/presentation/widgets/image_detail.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = post.createdAt;
    var time = DateFormat.jm().format(date); // Time in AM/PM format
    var restOfDate = DateFormat.yMMMMd().format(date); // Rest of the date

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 10.h,
      ),
      margin: EdgeInsets.all(
        8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder21,
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
                        // tag: post.content[0],
                        tag: '${post.content[0]}_0',

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
              CustomImageView(
                imagePath: ImageConstant.img32Heart,
                height: 32.adaptSize,
                width: 32.adaptSize,
              ),
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
              CustomImageView(
                imagePath: ImageConstant.img32Chat,
                height: 32.adaptSize,
                width: 32.adaptSize,
                margin: EdgeInsets.only(left: 8.h),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: 5.v,
                  bottom: 7.v,
                ),
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded2 && state.post.id == post.id) {
                      return Text(
                        state.post.commentsCount.toString(),
                        style: theme.textTheme.bodyLarge,
                      );
                    } else {
                      return Text(
                        post.commentsCount.toString(),
                        style: theme.textTheme.bodyLarge,
                      );
                    }
                  },
                ),
                // child: Text(
                //   post.commentsCount.toString(),
                //   style: theme.textTheme.bodyLarge,
                // ),
              ),
              // IconButton(
              //   onPressed: () {
              //     // Save post
              //   },
              //   icon: Icon(
              //     Icons.save,
              //     color: post.isSaved ? Colors.yellow : Colors.grey,
              //   ),
              // ),
              CustomImageView(
                imagePath: ImageConstant.imgBookmark,
                height: 32.adaptSize,
                width: 32.adaptSize,
                margin: EdgeInsets.only(left: 8.h),
              ),
            ],
          ),
          SizedBox(height: 13.v),
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
        ],
      ),
    );
  }

  // _buildImageLayout(BuildContext context, List<String> images) {
  //   int imageCount = images.length;

  //   return GridView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount:
  //             imageCount == 2 || imageCount == 3 || imageCount == 4 ? 2 : 1,
  //         crossAxisSpacing: 8,
  //         mainAxisSpacing: 8,
  //         childAspectRatio: 1),
  //     itemCount: imageCount,
  //     itemBuilder: (context, index) {
  //       String imageUrl = images[index];
  //       print(images);
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ImageDetailPage(imageUrl: imageUrl),
  //                 fullscreenDialog: true,
  //               ));
  //         },
  //         child: Hero(
  //           tag: imageUrl,
  //           child: CachedNetworkImage(
  //             imageUrl: 'http://10.0.2.2:8000/storage/$imageUrl',
  //             imageBuilder: (context, imageProvider) => Container(
  //               decoration: BoxDecoration(
  //                 // shape: BoxShape.rectangle,
  //                 image: DecorationImage(
  //                   image: imageProvider,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //             ),
  //             placeholder: (context, url) => CircularProgressIndicator(),
  //             errorWidget: (context, url, error) => Icon(Icons.error),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
