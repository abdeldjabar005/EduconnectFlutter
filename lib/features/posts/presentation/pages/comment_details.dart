import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/presentation/cubit/comment_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/comment_detail.dart';
import 'package:educonnect/features/posts/presentation/widgets/reply_item.dart';

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
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

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
          AppLocalizations.of(context)!.translate('comment')!,
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
                        CommentDetails(comment: widget.comment),
                        ValueListenableBuilder(
                          valueListenable:
                              context.read<CommentsCubit>().commentsCache,
                          builder: (context, Map<int, List<Comment>> cache, _) {
                            final comment = cache.values
                                .expand((i) => i)
                                .firstWhere((c) => c.id == widget.comment.id);

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comment.replies.length,
                              itemBuilder: (context, index) =>
                                  ReplyItem(reply: comment.replies[index]),
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
                  labelText:
                      AppLocalizations.of(context)!.translate('write_reply')!,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(),
                  prefixIcon: isRtl
                      ? ValueListenableBuilder(
                          valueListenable: _replyController,
                          builder: (BuildContext context, TextEditingValue text,
                              Widget? child) {
                            return IconButton(
                              icon: Transform.rotate(
                                angle: 180 * pi / 180,
                                child: const Icon(Icons.send),
                              ),
                              onPressed: _replyController.text.trim().isEmpty
                                  ? null
                                  : () {
                                      final commentCubit =
                                          context.read<CommentsCubit>();
                                      commentCubit.postReply(widget.comment.id,
                                          _replyController.text);
                                      commentCubit
                                          .getComment(widget.comment.id);
                                      _replyController.clear();
                                    },
                            );
                          },
                        )
                      : null,
                  suffixIcon: !isRtl
                      ? ValueListenableBuilder(
                          valueListenable: _replyController,
                          builder: (BuildContext context, TextEditingValue text,
                              Widget? child) {
                            return IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _replyController.text.trim().isEmpty
                                  ? null
                                  : () {
                                      final commentCubit =
                                          context.read<CommentsCubit>();
                                      commentCubit.postReply(widget.comment.id,
                                          _replyController.text);
                                      commentCubit
                                          .getComment(widget.comment.id);
                                      _replyController.clear();
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
  }
}
