// post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/pages/post_details.dart';
import 'package:quotes/features/posts/presentation/widgets/post_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  final _pagingController = PagingController<int, Post>(
    firstPageKey: 1,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // context.read<PostCubit>().getPosts(1);
    _pagingController.addPageRequestListener((pageKey) {
      context.read<PostCubit>().getPosts(pageKey);
    });
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.gray200,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocListener<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostLoaded) {
              _pagingController.itemList ??= [];
              if (state.posts.isNotEmpty) {
                _pagingController.appendPage(
                    state.posts,
                    state.hasReachedMax
                        ? null
                        : _pagingController.nextPageKey! + 1);
              }
              else {
                _pagingController.appendLastPage(state.posts);
                
              }
            }
          },
          child: PagedListView<int, Post>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
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
