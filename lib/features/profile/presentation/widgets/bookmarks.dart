import 'package:educonnect/core/utils/size_utils.dart';
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

class BookMarks extends StatefulWidget {
  const BookMarks({super.key});

  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks>
    with AutomaticKeepAliveClientMixin {
  final _pagingController = PagingController<int, PostModel>(
    firstPageKey: 1,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<PostCubit>().getPosts(pageKey, 'bookmarks');
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
        appBar: AppBar(
          leading: BackButton(
            color: AppColors.black900,
          ),
          backgroundColor: AppColors.whiteA700,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate('bookmarks')!,
            style: TextStyle(
              fontFamily: "Poppins",
              color: AppColors.black900,
              fontWeight: FontWeight.w400,
              fontSize: 18.v,
            ),
          ),
        ),
        backgroundColor: AppColors.gray200,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocListener<PostCubit, PostState>(
            listener: (context, state) {
              if (state is PostLoaded) {
                final isLastPage = state.hasReachedMax;
                String type = 'bookmarks';
                List<PostModel> postsOfType = state.bookmarksPosts;
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
            child: PagedListView<int, PostModel>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<PostModel>(
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate("a")!,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
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
            ),
          ),
        ),
      ),
    );
  }
}
