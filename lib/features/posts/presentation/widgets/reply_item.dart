// post_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:intl/intl.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/like_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';

class ReplyItem extends StatelessWidget {
  late Comment reply;

  ReplyItem({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  imagePath: reply.profilePicture,
                  height: 33.adaptSize,
                  width: 33.adaptSize,
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
                      Row(
                        children: [
                          Text(
                            '${reply.firstName} ${reply.lastName}',
                            style: CustomTextStyles.bodyMediumRobotoGray900,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgUser,
                            height: 10.adaptSize,
                            width: 10.adaptSize,
                            margin: EdgeInsets.symmetric(vertical: 3.v),
                          ),
                          Text(
                            timeAgo(reply.createdAt),
                            style: CustomTextStyles.bodyMediumRobotoGray500,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.v),
                      Text(
                        reply.lastName,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<int>(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  icon: Icon(Icons.more_vert, size: 20),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Text('Report', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    // Handle your menu item click here
                    if (value == 1) {
                      // Do something when the first item is clicked
                    } else if (value == 2) {
                      // Do something when the second item is clicked
                    }
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Container(
            width: 297.h,
            margin: EdgeInsets.only(right: 39.h),
            child: Text(
              reply.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // style: theme.textTheme.bodyMedium!.copyWith(
              //   height: 1.38,
              // ),
              style: CustomTextStyles.bodyMediumRobotoGray900big,

              // style: CustomTextStyles.titleMediumPoppinsblacksmall,
            ),
          ),

          SizedBox(height: 10.v),
          Row(
            children: [
              // CustomImageView(
              //   imagePath: ImageConstant.img32Heart,
              //   height: 24.adaptSize,
              //   width: 24.adaptSize,
              // ),
              InkWell(
                onTap: () {
                  context.read<LikeCubit>().likeReply(reply);
                },
                child: BlocBuilder<LikeCubit, LikeState>(
                  key: ValueKey(DateTime.now()),
                  builder: (context, state) {
                    if (state is ReplyLiked && state.replyId == reply.id) {
                      reply = reply.copyWith(
                        isLiked: state.isLiked,
                        likesCount: state.likesCount,
                      );
                    }
                    return Row(
                      children: [
                        CustomImageView(
                          color: reply.isLiked
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
                          child: Text(reply.likesCount.toString(),
                              style: theme.textTheme.bodyLarge),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // CustomImageView(
              //   imagePath: ImageConstant.img32Chat,
              //   height: 24.adaptSize,
              //   width: 24.adaptSize,
              //   margin: EdgeInsets.only(left: 8.h),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     top: 5.v,
              //     bottom: 7.v,
              //   ),
              //   child: BlocBuilder<CommentsCubit, CommentsState>(
              //     builder: (context, state) {
              //       if (state is RepliesLoaded && state.id == reply.id) {
              //         reply = reply.copyWith(
              //           repliesCount: state.repliesCount,
              //         );
              //       }
              //       return Text(
              //         reply.repliesCount.toString(),
              //         style: theme.textTheme.bodySmall,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 5.v),
          // devider
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 10.h,
          //   ),
          //   height: 1.h,
          //   color: AppColors.gray300,
          // ),
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
}