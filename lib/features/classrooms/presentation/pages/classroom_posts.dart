// post_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/pages/post_details.dart';
import 'package:quotes/features/posts/presentation/widgets/post_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ClassroomPosts extends StatefulWidget {
  final int id;
  final String type;

  ClassroomPosts({Key? key, required this.id, required this.type})
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
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
    // log("refreshing");
    context.read<Post2Cubit>().getClassroomPosts(
        widget.id, _pagingController.firstPageKey, widget.type, true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _refresh();
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
                        : _pagingController.nextPageKey! + 1);
              } else {
                _pagingController.appendLastPage(state.posts);
              }
            } else if (state is Post2NoData) {
              _pagingController.appendLastPage([]);
            }
          },
          child: PagedListView<int, PostModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              itemBuilder: (context, post, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: post),
                    ),
                  );
                },
                child: PostItem(post: post),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
