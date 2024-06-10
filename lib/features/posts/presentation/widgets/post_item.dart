// post_item.dart
import 'dart:math';
import 'dart:developer' as dev;

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/utils/logger.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/themes/app_decoration.dart';
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
import 'package:flutter_polls/flutter_polls.dart';
import 'package:intl/intl.dart';
import 'package:educonnect/features/posts/presentation/cubit/like_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_attachment_view.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_video_player.dart';
import 'package:educonnect/features/posts/presentation/widgets/image_detail.dart';

enum ActionItems { delete, update }

class PostItem extends StatelessWidget {
  late Post post;
  late String type;

  PostItem({Key? key, required this.post, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    final items = <ActionItems, String>{
      ActionItems.delete: isRtl ? 'حذف' : 'Delete',
      ActionItems.update: isRtl ? 'تحديث' : 'Update',
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 13.h,
        vertical: 10.h,
      ),
      margin: EdgeInsets.all(
        8.h,
      ),
      decoration: AppDecoration.fillWhiteA.copyWith(
        border: Border.fromBorderSide(
            BorderSide(color: Colors.black.withOpacity(0.1))),
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
                  imagePath:
                      'http://127.0.0.1:8000/storage/${post.profilePicture}',
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
                      type == "post"
                          ? InkWell(
                              onTap: () {
                                dev.log("clicked");
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
                                dev.log('schoolList: $schoolList');
                                dev.log('classList: $classList');
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
                const Spacer(),
                // if (post.userId == user.id)
                //   PopupMenuButton<ActionItems>(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     onSelected: (value) async {
                //       switch (value) {
                //         case ActionItems.delete:
                //           final confirm = await showDialog(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return AlertDialog(
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(20),
                //                 ),
                //                 title: Text(
                //                   AppLocalizations.of(context)!
                //                       .translate('confirm')!,
                //                   style: TextStyle(
                //                       color: AppColors.indigoA200,
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //                 content: Text(
                //                   AppLocalizations.of(context)!
                //                       .translate('delete_child')!,
                //                   style: TextStyle(color: Colors.black54),
                //                 ),
                //                 actions: <Widget>[
                //                   TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(true),
                //                     child: Text(
                //                       AppLocalizations.of(context)!
                //                           .translate('delete')!,
                //                       style: TextStyle(color: Colors.red),
                //                     ),
                //                   ),
                //                   TextButton(
                //                     onPressed: () =>
                //                         Navigator.of(context).pop(false),
                //                     child: Text(
                //                       AppLocalizations.of(context)!
                //                           .translate('cancel')!,
                //                       style: TextStyle(color: Colors.blue),
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             },
                //           );
                //           if (confirm == true) {
                //             context
                //                 .read<Post2Cubit>()
                //                 .removePost(post.id, post.classOrSchoolId);
                //           }
                //           break;
                //         case ActionItems.update:
                //           // Navigator.push(
                //           //   context,
                //           //   MaterialPageRoute(
                //           //       builder: (context) =>
                //           //           UpdateChild(child: child)),
                //           // );
                //           break;
                //       }
                //     },
                //     itemBuilder: (context) => items
                //         .map((item, text) => MapEntry(
                //             item,
                //             PopupMenuItem<ActionItems>(
                //               value: item,
                //               child: ListTile(
                //                 contentPadding: EdgeInsets.zero,
                //                 leading: Icon(
                //                     item == ActionItems.delete
                //                         ? Icons.delete
                //                         : Icons.update,
                //                     color: AppColors.indigoA200),
                //                 title: Text(text),
                //               ),
                //             )))
                //         .values
                //         .toList(),
                //   ),
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
                        tag: '${post.content[0]['url']}_0',
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
                      : post.type == 'poll'
                          ? FlutterPolls(
                              pollId: post.content[0]['id'].toString(),
                              pollTitle: Text(post.content[0]['question']),
                              hasVoted: post.content[0]['user_vote'] != null,
                              pollOptions:
                                  (post.content[0]['options'] as List<String>)
                                      .map((option) {
                                final votes = (post.content[0]['results']
                                        as Map<String, dynamic>)[option] ??
                                    0;
                                return PollOption(
                                  id: option,
                                  title: Text(option),
                                  votes: votes,
                                );
                              }).toList(),
                              userVotedOptionId: post.content[0]['user_vote'],
                              onVoted: (option, index) async {
                                vLog(
                                    'Voted on poll: ${post.content[0]['user_vote']}');
                                vLog(option.id);
                                await context.read<Post2Cubit>().voteOnPoll(
                                      post.content[0]['id'],
                                      option.id!,
                                    );
                                return true;
                              },
                            )
                          : post.content.length == 1
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageDetailPage(
                                          imageUrls: post.content
                                              .map((item) =>
                                                  item['url'] as String?)
                                              .toList(),
                                          initialIndex: 0,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: '${post.content[0]['url']}_0',
                                    child: Material(
                                      color: Colors.transparent,
                                      child: CustomImageView(
                                        fit: BoxFit.cover,
                                        imagePath:
                                            '${EndPoints.storage}${post.content[0]['url']}',
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                          int remaining =
                                              post.content.length - 4;

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
                                                          .map((item) =>
                                                              item['url']
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
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: CustomImageView(
                                                    fit: BoxFit.cover,
                                                    imagePath:
                                                        '${EndPoints.storage}$imageUrl',
                                                    radius:
                                                        BorderRadius.circular(
                                                      15.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            // Create the effect for the last image with number of remaining images
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageDetailPage(
                                                      imageUrls: post.content
                                                          .map((item) =>
                                                              item['url']
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
                                                        radius: BorderRadius
                                                            .circular(
                                                          15.h,
                                                        ),
                                                      ),
                                                      if (remaining > 0)
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.black54,
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
                                                            item['url']
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
              // CustomImageView(
              //   imagePath: ImageConstant.img32Heart,
              //   height: 32.adaptSize,
              //   width: 32.adaptSize,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     top: 5.v,
              //     bottom: 7.v,
              //   ),
              //   child: Text(
              //     post.likesCount.toString(),
              //     style: theme.textTheme.bodyLarge,
              //   ),
              // ),

              InkWell(
                onTap: () {
                  context.read<LikeCubit>().likePost(post);
                },
                child: BlocBuilder<LikeCubit, LikeState>(
                  key: ValueKey(DateTime.now()),
                  builder: (context, state) {
                    if (state is PostLiked &&
                        int.parse(state.postId) == post.id) {
                      post = post.copyWith(
                        isLiked: state.isLiked,
                        likesCount: state.likesCount,
                      );
                    }
                    return Row(
                      children: [
                        CustomImageView(
                          color: post.isLiked
                              ? AppColors.blueA200
                              : AppColors.black900,
                          imagePath: ImageConstant.img32Heart,
                          height: 32.adaptSize,
                          width: 32.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5.v,
                            bottom: 7.v,
                          ),
                          child: Text(post.likesCount.toString(),
                              style: theme.textTheme.bodyLarge),
                        ),
                      ],
                    );
                  },
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
                      post = post.copyWith(
                        commentsCount: state.post.commentsCount,
                      );
                    }
                    return Text(
                      post.commentsCount.toString(),
                      style: theme.textTheme.bodyLarge,
                    );
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
          // Row(
          //   children: [
          //     Text(
          //       time,
          //       style: theme.textTheme.bodyMedium,
          //     ),
          //     CustomImageView(
          //       imagePath: ImageConstant.imgUser,
          //       height: 10.adaptSize,
          //       width: 10.adaptSize,
          //       margin: EdgeInsets.symmetric(vertical: 3.v),
          //     ),
          //     Text(
          //       restOfDate,
          //       style: theme.textTheme.bodyMedium,
          //     ),
          //   ],
          // ),
          Text(
            isRtl ? timeAgoArabic(post.createdAt) : timeAgo(post.createdAt),
            style: CustomTextStyles.bodyMediumRobotoGray500,
          ),
          SizedBox(height: 10.v),
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
