// post_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/domain/usecases/get_comment.dart';
import 'package:educonnect/features/posts/domain/usecases/get_comments.dart';
import 'package:educonnect/features/posts/domain/usecases/post_comment.dart';
import 'package:educonnect/features/posts/domain/usecases/post_reply.dart';
import 'dart:developer';

import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';

part 'comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final GetComments getCommentsUseCase;
  final GetComment getCommentUseCase;
  final PostComment postCommentUseCase;
  final PostReply postReplyUseCase;
  final AuthCubit authCubit;
  final PostCubit postCubit;

  final commentsCache = ValueNotifier<Map<int, List<Comment>>>({});
  final repliesCache = ValueNotifier<Map<int, List<CommentModel>>>({});
  CommentsCubit(
      {required this.getCommentsUseCase,
      required this.getCommentUseCase,
      required this.postCommentUseCase,
      required this.postReplyUseCase,
      required this.authCubit,
      required this.postCubit})
      : super(CommentsInitial());

  Future<void> getComments(int postId) async {
    if (commentsCache.value.containsKey(postId)) {
      final comments = commentsCache.value[postId];
      if (comments != null && comments.isNotEmpty) {
        emit(
            CommentsLoaded(comments: comments, commentsCount: comments.length));
      } else {
        emit(NoComments(message: "No comments found"));
      }
    } else {
      emit(CommentsLoading());
      final response = await getCommentsUseCase(Params1(postId: postId));
      emit(response.fold(
        (failure) => CommentsError(message: _mapFailureToMessage(failure)),
        (comments) {
          commentsCache.value[postId] = comments;
          if (comments.isNotEmpty) {
            for (var comment in comments) {
              repliesCache.value[comment.id] = comment.replies;
            }
            return (CommentsLoaded(
                comments: comments, commentsCount: comments.length));
          } else {
            return (NoComments(message: "No comments found"));
          }
        },
      ));
    }
  }

  Future<void> getComment(int id) async {
    final response = await getCommentUseCase(id);
    response.fold(
        (failure) =>
            emit(CommentsError(message: _mapFailureToMessage(failure))),
        (comment) {
      emit(CommentLoaded(comment: comment));
    });
  }

  Future<void> postComment(int postId, String comment) async {
    final user = (authCubit.state as AuthAuthenticated).user;

    final failureOrVoid =
        await postCommentUseCase(Params(postId: postId, comment: comment));

    failureOrVoid.fold(
      (failure) => emit(CommentsError(message: _mapFailureToMessage(failure))),
      (_) {
        final newComment = CommentModel(
          id: commentsCache.value[postId]!.length + 1,
          postId: postId,
          userId: user.id,
          text: comment,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          likesCount: 0,
          repliesCount: 0,
          isLiked: false,
          replies: [],
          firstName: user.firstName,
          lastName: user.lastName,
          profilePicture: user.profilePicture ?? 'assets/images/edu.png',
        );
        commentsCache.value[postId]!.add(newComment);

        commentsCache.notifyListeners();

        emit(CommentsLoaded(
            comments: commentsCache.value[postId]!,
            commentsCount: commentsCache.value[postId]!.length));
      },
    );
  }

  Future<void> postReply(int commentId, String reply) async {
    // emit(CommentsLoading());

    // log(authCubit.state.toString());
    final user = (authCubit.state as AuthAuthenticated).user;

    final failureOrVoid =
        await postReplyUseCase(Params2(id: commentId, reply: reply));

    failureOrVoid.fold(
      (failure) => emit(CommentsError(message: _mapFailureToMessage(failure))),
      (_) {
        final comment = commentsCache.value.values
            .expand((i) => i)
            .firstWhere((comment) => comment.id == commentId);

        final newReply = CommentModel(
          id: comment.repliesCount + 1,
          postId: commentId,
          userId: user.id,
          text: reply,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          likesCount: 0,
          repliesCount: 0,
          replies: [],
          isLiked: false,
          firstName: user.firstName,
          lastName: user.lastName,
          profilePicture: user.profilePicture ?? 'assets/images/edu.png',
        );

        // comment.replies.add(newReply);
        // comment.repliesCount++;
        if (!comment.replies.contains(newReply)) {
          log(comment.repliesCount.toString());

          comment.replies.add(newReply);
          comment.repliesCount++;
          log(comment.repliesCount.toString());
        }
        commentsCache.notifyListeners();

        emit(RepliesLoaded(id: commentId, repliesCount: comment.repliesCount));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected error';
    }
  }
}
