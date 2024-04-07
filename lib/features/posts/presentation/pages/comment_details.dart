import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/comment_detail.dart';
import 'package:quotes/features/posts/presentation/widgets/reply_item.dart';

class CommentDetailPage extends StatefulWidget {
  final Comment comment;

  const CommentDetailPage({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentDetailPageState createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetailPage> {
  final TextEditingController _replyController = TextEditingController();
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
          'Comment',
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
                      CommentDetails(comment: widget.comment),
                      ValueListenableBuilder(
                        valueListenable: context.read<CommentsCubit>().commentsCache,
                        builder: (context, Map<int, List<Comment>> cache, _) {
                          final comment = cache.values.expand((i) => i).firstWhere((c) => c.id == widget.comment.id);
                      
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comment.replies.length,
                            itemBuilder: (context, index) => ReplyItem(reply: comment.replies[index]),
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
              controller: _replyController,
              decoration: InputDecoration(
                labelText: 'Write a reply...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final commentCubit = context.read<CommentsCubit>();
                    commentCubit.postReply(
                        widget.comment.id, _replyController.text);
                    commentCubit.getComment(widget.comment.id);
                    
                    _replyController.clear();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
