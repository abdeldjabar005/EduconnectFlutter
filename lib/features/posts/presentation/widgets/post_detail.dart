// post_item.dart
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/class_details.dart';
import 'package:educonnect/features/classrooms/presentation/pages/school_details.dart';
import 'package:educonnect/features/posts/domain/entities/post.dart';
import 'package:intl/intl.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/like_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_attachment_view.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_video_player.dart';
import 'package:educonnect/features/posts/presentation/widgets/image_detail.dart';

class PostDetails extends StatelessWidget {
  late String type;
  late Post post;

  PostDetails({Key? key, required this.type, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
                      type == 'post'
                          ? GestureDetector(
                              onTap: () {
                                final user = (context.read<AuthCubit>().state
                                        as AuthAuthenticated)
                                    .user;
                                final postClassOrSchoolId =
                                    post.classOrSchoolId;

                                final schoolList = user.schools
                                    .where((school) =>
                                        school.id == postClassOrSchoolId)
                                    .toList();
                                final classList = user.classes
                                    .where((classe) =>
                                        classe.id == postClassOrSchoolId)
                                    .toList();

                                if (schoolList.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SchoolDetails(school: schoolList[0]),
                                    ),
                                  );
                                } else if (classList.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClassDetails(classe: classList[0]),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                post.classname,
                                style: theme.textTheme.titleSmall,
                              ),
                            )
                          : Text(
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
              ? post.type == 'video'
                  ? GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => VideoPlayerPage(
                        //       videoUrl: post.content[0],
                        //     ),
                        //     fullscreenDialog: true,
                        //   ),
                        // );
                      },
                      child: Hero(
                        tag: '${post.content[0]}_0',
                        child: Material(
                          color: Colors.transparent,
                          child: CustomVideoPlayer(
                            fit: BoxFit.cover,
                            videoPath:
                                '${EndPoints.storage}${post.content[0]['url']}',
                            radius: BorderRadius.circular(
                              15.h,
                            ),
                          ),
                        ),
                      ),
                    )
                  : post.type == 'attachment'
                      ? GestureDetector(
                          onTap: () {},
                          child: CustomAttachmentView(
                            name: post.content[0]['name'],
                            filePath:
                                '${EndPoints.storage}${post.content[0]['url']}',
                          ),
                        )
                      : post.content.length == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageDetailPage(
                                      imageUrls: post.content
                                          .map((item) => item['url'] as String?)
                                          .toList(),
                                      initialIndex: 0,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Hero(
                                // tag: post.content[0],
                                tag: '${post.content[0]['url']}_0',
                                child: Material(
                                  color: Colors.transparent,
                                  child: CustomImageView(
                                    fit: BoxFit.cover,
                                    imagePath:
                                        '${EndPoints.storage}${post.content[0]['url']}',
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
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                int crossAxisCount =
                                    post.content.length >= 2 ? 2 : 1;
                                return GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 700 / 500,
                                  children: List<Widget>.generate(
                                      min(post.content.length, 4), (index) {
                                    String? imageUrl =
                                        post.content[index]['url'];

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
                                                builder: (context) =>
                                                    ImageDetailPage(
                                                  imageUrls: post.content
                                                      .map((item) => item['url']
                                                          as String?)
                                                      .toList(),
                                                  initialIndex: index,
                                                ),
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag:
                                                '${post.content[index]['url']}_$index',
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
                                                builder: (context) =>
                                                    ImageDetailPage(
                                                  imageUrls: post.content
                                                      .map((item) => item['url']
                                                          as String?)
                                                      .toList(),
                                                  initialIndex: index,
                                                ),
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag:
                                                '${post.content[index]['url']}_$index',
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
                                                    radius:
                                                        BorderRadius.circular(
                                                      15.h,
                                                    ),
                                                  ),
                                                  if (remaining > 0)
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          15.h,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '+$remaining',
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            color: AppColors
                                                                .whiteA700),
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
                                              builder: (context) =>
                                                  ImageDetailPage(
                                                imageUrls: post.content
                                                    .map((item) =>
                                                        item['url'] as String?)
                                                    .toList(),
                                                initialIndex: index,
                                              ),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag:
                                              '${post.content[index]['url']}_$index',
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
              : const SizedBox.shrink(),

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

          Text(isRtl ? timeAgoArabic(post.createdAt) : timeAgo(post.createdAt),
              style: theme.textTheme.bodyMedium),
          SizedBox(height: 10.v),
          // devider
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            height: 1.h,
            color: AppColors.gray250,
          ),
          SizedBox(height: 14.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
        

              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<LikeCubit>().likePost(post);
                  },
                  child: BlocBuilder<LikeCubit, LikeState>(
                    key: ValueKey(DateTime.now()),
                    builder: (context, state) {
                      final likeCubit = context.watch<LikeCubit>();
                      if (likeCubit.likedPostsCache.containsKey(post.id)) {
                        post = likeCubit.likedPostsCache[post.id]!;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            post.likesCount.toString(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: post.isLiked ? Colors.blue : null,
                            ),
                          ),
                          SizedBox(width: 5.v),
                          Text(
                            AppLocalizations.of(context)!
                              .translate("likes")!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: post.isLiked ? Colors.blue : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocListener<CommentsCubit, CommentsState>(
                      listener: (context, state) {
                        if (state is CommentsLoaded &&
                            state.comments.first.postId == post.id) {
                          post =
                              post.copyWith(commentsCount: state.commentsCount);
                        }
                      },
                      child: BlocBuilder<PostCubit, PostState>(
                        builder: (context, state) {
                          if (state is PostLoaded2 &&
                              state.post.id == post.id) {
                            post = post.copyWith(
                                commentsCount: state.post.commentsCount);
                          }
                          return Text(
                            post.commentsCount.toString(),
                            style: theme.textTheme.bodyLarge,
                          );
                        },
                      ),
                    ),
                    // Text(
                    //   post.commentsCount.toString(),
                    //   style: theme.textTheme.bodyLarge,
                    // ),
                    SizedBox(width: 5.v),
                    Text(
                      AppLocalizations.of(context)!
                              .translate("comments")!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0', // TODO: Replace with actual bookmarks count
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(width: 5.v),
                    Text(
                      AppLocalizations.of(context)!
                              .translate("saves")!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.v),
          // devider
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            height: 1.h,
            color: AppColors.gray250,
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 4) {
      return '${difference.inDays}d';
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }

  String timeAgoArabic(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'منذ ${difference.inSeconds} ثواني';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inDays < 4) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return DateFormat.yMMMMd('ar_SA').format(date);
    }
  }
}
