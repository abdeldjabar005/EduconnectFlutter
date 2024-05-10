// post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/pages/post_details.dart';
import 'package:educonnect/features/posts/presentation/widgets/post_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:educonnect/injection_container.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  final _pagingController = PagingController<int, PostModel>(
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
                } else {
                  _pagingController.appendLastPage(state.posts);
                }
              }
            },
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoaded && state.posts.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate("welcome_edu")!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.translate("no_posts")!,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return PagedListView<int, PostModel>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<PostModel>(
                      itemBuilder: (context, post, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailPage(post: post, type: 'post'),
                            ),
                          );
                        },
                        child: PostItem(post: post, type: 'post'),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
