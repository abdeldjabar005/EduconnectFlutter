import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/pages/comment_details.dart';
import 'package:educonnect/features/posts/presentation/widgets/comment_item.dart';
import 'package:educonnect/features/posts/presentation/widgets/post_detail.dart';

class PostDetailPage extends StatefulWidget {
  late String type;
  final PostModel post;

  PostDetailPage({Key? key, required this.type, required this.post})
      : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().getComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Builder(builder: (context) {
      // context.read<CommentsCubit>().getComments(widget.post.id);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: const BackButton(
            color: Colors.black,
            style: ButtonStyle(),
          ),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.translate('post')!,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // BlocProvider<PostCubit>(
                          //   create: (context) => sl<PostCubit>(),
                          //   child: PostDetails(post: widget.post),
                          // ),
                          PostDetails(post: widget.post, type: widget.type),
                          if (state is CommentsLoading)
                            const CircularProgressIndicator(),
                          if (state is NoComments) Text(state.message),
                          if (state is CommentsError) Text(state.message),
                          if (state is CommentsLoaded || state is CommentLoaded)
                            ValueListenableBuilder(
                              valueListenable:
                                  context.read<CommentsCubit>().commentsCache,
                              builder:
                                  (context, Map<int, List<Comment>> cache, _) {
                                final comments = cache[widget.post.id];

                                if (comments == null) {
                                  return Text(AppLocalizations.of(context)!
                                      .translate('no_comments')!);
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CommentDetailPage(
                                            comment: comments[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        CommentItem(comment: comments[index]),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate('write_comment')!,
                    border: const OutlineInputBorder(),
                    prefixIcon: isRtl
                        ? ValueListenableBuilder(
                            valueListenable: _commentController,
                            builder: (BuildContext context,
                                TextEditingValue text, Widget? child) {
                              return IconButton(
                                icon: Transform.rotate(
                                  angle: 180 * pi / 180,
                                  child: const Icon(Icons.send),
                                ),
                                onPressed: () {
                                  context.read<CommentsCubit>().postComment(
                                      widget.post.id, _commentController.text);
                                  final postCubit = context.read<PostCubit>();
                                  postCubit.getPost(widget.post.id);
                                  _commentController.clear();
                                },
                              );
                            },
                          )
                        : null,
                    suffixIcon: !isRtl
                        ? ValueListenableBuilder(
                            valueListenable: _commentController,
                            builder: (BuildContext context,
                                TextEditingValue text, Widget? child) {
                              return IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: text.text.isEmpty
                                    ? null
                                    : () {
                                        context
                                            .read<CommentsCubit>()
                                            .postComment(widget.post.id,
                                                _commentController.text);
                                        final postCubit =
                                            context.read<PostCubit>();
                                        postCubit.getPost(widget.post.id);
                                        _commentController.clear();
                                      },
                              );
                            },
                          )
                        : null,
                  ),
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
