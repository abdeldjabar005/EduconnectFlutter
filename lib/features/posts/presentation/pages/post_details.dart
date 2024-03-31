import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/usecases/post_comment.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/comment_item.dart';
import 'package:quotes/features/posts/presentation/widgets/post_detail.dart';
import 'package:quotes/injection_container.dart';

class PostDetailPage extends StatefulWidget {
  final PostModel post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

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
    return BlocProvider<CommentsCubit>(
      create: (context) => sl<CommentsCubit>(),
      child: Builder(builder: (context) {
        context.read<CommentsCubit>().getComments(widget.post.id);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: const BackButton(
              color: Colors.black,
              style: ButtonStyle(),
            ),
            elevation: 0,
            title: const Text(
              'Post',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // BlocProvider<CommentsCubit>(
                          //   create: (context) => sl<CommentsCubit>(),
                          //   child: PostDetails(post: widget.post),
                          // ),
                          PostDetails(post: widget.post),
                          if (state is CommentsLoading)
                            const CircularProgressIndicator(),
                          if (state is CommentsError) Text(state.message),
                          if (state is CommentsLoaded)
                            ValueListenableBuilder(
                              valueListenable:
                                  context.read<CommentsCubit>().commentsCache,
                              builder:
                                  (context, Map<int, List<Comment>> cache, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cache[widget.post.id]!.length,
                                  itemBuilder: (context, index) => CommentItem(
                                      comment: cache[widget.post.id]![index]),
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
                    labelText: 'Write a comment...',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        context.read<CommentsCubit>().postComments(
                            widget.post.id, _commentController.text);
                        final postCubit = context.read<PostCubit>();
                        postCubit.getPost(widget.post.id);
                        _commentController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
