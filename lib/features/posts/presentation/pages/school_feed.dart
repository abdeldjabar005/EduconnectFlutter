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

class SchoolFeed extends StatefulWidget {
  const SchoolFeed({super.key});

  @override
  _SchoolFeedState createState() => _SchoolFeedState();
}

class _SchoolFeedState extends State<SchoolFeed>
    with AutomaticKeepAliveClientMixin {
  final _pagingController = PagingController<int, PostModel>(firstPageKey: 1);
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<PostCubit>().getPosts(pageKey, 'school');
    });
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
                final isLastPage = state.hasReachedMax;
                List<PostModel> postsOfType = state.schoolPosts;
                print('Loaded posts for school: ${postsOfType.length}');

                if (postsOfType.isNotEmpty) {
                  if (isLastPage) {
                    _pagingController.appendLastPage(postsOfType);
                  } else {
                    final nextPageKey = _pagingController.nextPageKey! + 1;
                    _pagingController.appendPage(postsOfType, nextPageKey);
                  }
                } else if (isLastPage) {
                  _pagingController.appendLastPage([]);
                }
              } else if (state is PostError) {
                _pagingController.error = state.message;
              }
            },
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => PagedListView<int, PostModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<PostModel>(
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("no_posts")!,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    itemBuilder: (context, post, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailPage(post: post, type: 'post'),
                          ),
                        );
                      },
                      child: PostItem(post: post, type: 'post'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
