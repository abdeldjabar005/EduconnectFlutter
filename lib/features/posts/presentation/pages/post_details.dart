// post_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/comment_item.dart';
import 'package:quotes/features/posts/presentation/widgets/post_detail.dart';
import 'package:quotes/features/posts/presentation/widgets/post_item.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().getComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                PostDetails(post: widget.post),
                if (state is CommentsLoading) const CircularProgressIndicator(),
                if (state is CommentsError) Text(state.message),
                if (state is CommentsLoaded)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) =>
                        CommentItem(comment: state.comments[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
