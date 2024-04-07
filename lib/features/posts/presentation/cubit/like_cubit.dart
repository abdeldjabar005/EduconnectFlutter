import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/usecases/like_comment.dart';
import 'package:quotes/features/posts/domain/usecases/like_post.dart';
import 'package:quotes/features/posts/domain/usecases/like_reply.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final LikePost likePostUseCase;
  final LikeComment likeCommentUseCase;
  final LikeReply likeReplyUseCase;

  LikeCubit({
    required this.likePostUseCase,
    required this.likeCommentUseCase,
    required this.likeReplyUseCase,
  }) : super(LikeInitial());

  Future<void> likePost(Post post) async {
    final response = await likePostUseCase(post.id);

    // final postResult = await postRepository.getPost(post.id);

    final isLiked = !post.isLiked;
    final likesCount = isLiked ? post.likesCount + 1 : post.likesCount - 1;
    emit(PostLiked(
        postId: post.id.toString(), isLiked: isLiked, likesCount: likesCount));

    // postResult.fold(
    //     (failure) => emit(PostError(message: _mapFailureToMessage(failure))),
    //     (post) {
    //   final isLiked = !post.isLiked;
    //   final likesCount = isLiked
    //       ? post.likesCount + 1
    //       : post.likesCount -
    //           1;
    //   emit(PostLiked(
    //       postId: post.id.toString(), isLiked: isLiked, likesCount: likesCount));
    // });
  }

  Future<void> likeComment(Comment comment) async {
    await likeCommentUseCase(comment.id);

    final isLiked = !comment.isLiked;
    final likesCount =
        isLiked ? comment.likesCount + 1 : comment.likesCount - 1;
    
    emit(CommentLiked(
        commentId: comment.id, isLiked: isLiked, likesCount: likesCount));
  }

  Future<void> likeReply(Comment reply) async {
    await likeReplyUseCase(reply.id);

    final isLiked = !reply.isLiked;
    final likesCount = isLiked ? reply.likesCount + 1 : reply.likesCount - 1;
    emit(ReplyLiked(
        replyId: reply.id, isLiked: isLiked, likesCount: likesCount));
  }
}
