// post_item.dart
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/api/end_points.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:intl/intl.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/like_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/posts/presentation/widgets/image_detail.dart';

class CommentDetails extends StatelessWidget {
  late Comment comment;

  CommentDetails({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = comment.createdAt;
    var time = DateFormat.jm().format(date);
    var restOfDate = DateFormat.yMMMMd().format(date);

    return Container(
      decoration: BoxDecoration(
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
                  imagePath: comment.profilePicture,
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
                        '${comment.firstName} ${comment.lastName}',
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
            child: Text(
              comment.text,
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
            color: AppColors.gray250,
          ),
          SizedBox(height: 14.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         // "222",
              //         post.likesCount.toString(),
              //         style: theme.textTheme.bodyLarge,
              //       ),
              //       SizedBox(width: 5.v),
              //       Text(
              //         'Likes',
              //         style: theme.textTheme.bodyMedium,
              //       ),
              //     ],
              //   ),
              // ),

              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<LikeCubit>().likeComment(comment);
                  },
                  child: BlocBuilder<LikeCubit, LikeState>(
                    key: ValueKey(DateTime.now()),
                    builder: (context, state) {
                      if (state is CommentLiked &&
                          state.commentId == comment.id) {
                        comment = comment.copyWith(
                          isLiked: state.isLiked,
                          likesCount: state.likesCount,
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            comment.likesCount.toString(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: comment.isLiked ? Colors.blue : null,
                            ),
                          ),
                          SizedBox(width: 5.v),
                          Text(
                            'Likes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: comment.isLiked ? Colors.blue : null,
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
                    BlocBuilder<CommentsCubit, CommentsState>(
                      builder: (context, state) {
                        // if (state is CommentLoaded &&
                        //     state.comment.id == comment.id) {
                        //   comment = comment.copyWith(
                        //       repliesCount: state.comment.repliesCount);
                        //   dev.log(comment.repliesCount.toString());
                        // } else
                        if (state is RepliesLoaded && state.id == comment.id) {
                          dev.log(comment.repliesCount.toString());

                          comment = comment.copyWith(
                              repliesCount: state.repliesCount);
                        }
                        return Text(
                          comment.repliesCount.toString(),
                          style: theme.textTheme.bodyLarge,
                        );
                      },
                    ),
                    // Text(
                    //   post.commentsCount.toString(),
                    //   style: theme.textTheme.bodyLarge,
                    // ),
                    SizedBox(width: 5.v),
                    Text(
                      'Comments',
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
}
