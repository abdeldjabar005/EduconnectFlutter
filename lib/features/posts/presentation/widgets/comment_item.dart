// post_item.dart

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:intl/intl.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/like_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';

class CommentItem extends StatelessWidget {
  late Comment comment;

  CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
                  imagePath: '${EndPoints.storage}${comment.profilePicture}',
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
                            '${comment.firstName} ${comment.lastName}',
                            style: CustomTextStyles.bodyMediumRobotoGray900,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgUser,
                            height: 10.adaptSize,
                            width: 10.adaptSize,
                            margin: EdgeInsets.symmetric(vertical: 3.v),
                          ),
                          Text(
                            isRtl
                                ? timeAgoArabic(comment.createdAt)
                                : timeAgo(comment.createdAt),
                            style: CustomTextStyles.bodyMediumRobotoGray500,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.v),
                      Text(
                        AppLocalizations.of(context)!
                                        .translate('user')!,
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
              comment.text,
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
                  context.read<LikeCubit>().likeComment(comment);
                },
                child: BlocBuilder<LikeCubit, LikeState>(
                  key: ValueKey(DateTime.now()),
                  builder: (context, state) {
                    final likeCubit = context.watch<LikeCubit>();
                    if (likeCubit.likedCommentsCache.containsKey(comment.id)) {
                      comment = likeCubit.likedCommentsCache[comment.id]!;
                    }
                    return Row(
                      children: [
                        CustomImageView(
                          color: comment.isLiked
                              ? AppColors.blueA200
                              : AppColors.black900,
                          imagePath: ImageConstant.img32Heart,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5.v,
                            bottom: 7.v,
                          ),
                          child: Text(comment.likesCount.toString(),
                              style: theme.textTheme.bodySmall),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     top: 5.v,
              //     bottom: 7.v,
              //   ),
              //   child: Text(
              //     comment.likesCount.toString(),
              //     style: theme.textTheme.bodySmall,
              //   ),
              // ),
              CustomImageView(
                imagePath: ImageConstant.img32Chat,
                height: 24.adaptSize,
                width: 24.adaptSize,
                margin: EdgeInsets.only(left: 8.h),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5.v,
                  bottom: 7.v,
                ),
                child: BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    // if (state is CommentLoaded &&
                    //     state.comment.id == comment.id) {
                    if (state is RepliesLoaded && state.id == comment.id) {
                      comment = comment.copyWith(
                        repliesCount: state.repliesCount,
                      );
                    }
                    return Text(
                      comment.repliesCount.toString(),
                      style: theme.textTheme.bodySmall,
                    );
                  },
                ),
              ),
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
      return DateFormat.yMMMMd('ar').format(date);
    }
  }
}
