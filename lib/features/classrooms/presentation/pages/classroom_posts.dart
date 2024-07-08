// post_screen.dart
import 'dart:developer';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/themes/app_decoration.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/pages/new_post.dart';
import 'package:educonnect/features/posts/presentation/pages/post_details.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/posts/presentation/widgets/post_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ClassroomPosts extends StatefulWidget {
  final int id;
  final String type;
  final String name;
  ClassroomPosts(
      {Key? key, required this.id, required this.type, required this.name})
      : super(key: key);
  @override
  _ClassroomPostsState createState() => _ClassroomPostsState();
}

class _ClassroomPostsState extends State<ClassroomPosts>
    with AutomaticKeepAliveClientMixin {
  var _pagingController = PagingController<int, PostModel>(
    firstPageKey: 1,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, PostModel>(
      firstPageKey: 1,
    );

    _pagingController.addPageRequestListener((pageKey) {
      context
          .read<Post2Cubit>()
          .getClassroomPosts(widget.id, pageKey, widget.type, false);
    });
    _refresh();
  }

  Future<void> _refresh() async {
    context.read<Post2Cubit>().getClassroomPosts(
        widget.id, _pagingController.firstPageKey, widget.type, true);
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final authState = context.watch<AuthCubit>().state;
    User? user;
    if (authState is AuthAuthenticated) {
      user = authState.user;
    }
    // _refresh();
    return Scaffold(
      backgroundColor: AppColors.gray200,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocListener<Post2Cubit, Post2State>(
          listener: (context, state) {
            // log(state.toString());

            if (state is Post2Loaded) {
              // log(state.posts.toString());
              _pagingController.itemList ??= [];
              if (state.posts.isNotEmpty) {
                // log("Appending page");
                _pagingController.appendPage(
                    state.posts,
                    state.hasReachedMax
                        ? null
                        : (_pagingController.nextPageKey ?? 1) + 1);
              } else {
                _pagingController.appendLastPage(state.posts);
              }
            } else if (state is Post2NoData) {
              _pagingController.appendLastPage([]);
            }
          },
          child: CustomScrollView(
            slivers: <Widget>[
              if (widget.type == 'school' && widget.id == user?.school?.id ||
                  widget.type == 'class')
                SliverToBoxAdapter(
                  child: _buildWriteNewPost(context),
                ),
              PagedSliverList<int, PostModel>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<PostModel>(
                  itemBuilder: (context, post, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailPage(post: post, type: 'classroom'),
                        ),
                      );
                    },
                    child: PostItem(post: post, type: 'classroom'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWriteNewPost(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewPost(
                id: widget.id,
                schoolClass: widget.type,
                name: widget.name,
              ),
            ),
          );
        },
        child: Container(
          height: 65.v,
          padding: EdgeInsets.symmetric(
            horizontal: 12.h,
            vertical: 6.v,
          ),
          margin: EdgeInsets.all(
            10.v,
          ),
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomImageView(
                // imagePath: ImageConstant.imgRectangle17,
                imagePath: '${EndPoints.storage}${user.profilePicture}',

                height: 40.v,
                width: 38.h,
                radius: BorderRadius.circular(
                  18.h,
                ),
                margin: EdgeInsets.only(
                  left: 6.h,
                  top: 2.v,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.h,
                  top: 15.v,
                  right: 8.h,
                  bottom: 10.v,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('write_something')!,
                  style: CustomTextStyles.bodyMediumRobotoGray700,
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgEditEditPencil01,
                height: 24.v,
                width: 20.h,
                margin: EdgeInsets.only(
                  left: 6.h,
                  top: 10.v,
                  bottom: 8.v,
                ),
              ),
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgSave,
                height: 24.adaptSize,
                width: 24.adaptSize,
                margin: EdgeInsets.only(
                  top: 10.v,
                  bottom: 8.v,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
