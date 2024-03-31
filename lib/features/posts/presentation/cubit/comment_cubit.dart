// post_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/posts/data/models/comment_model.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/usecases/get_comments.dart';
import 'package:quotes/features/posts/domain/usecases/post_comment.dart';
import 'dart:developer';

import 'package:quotes/features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/injection_container.dart';

part 'comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final GetComments getCommentsUseCase;
  final PostComment postComment;
  final AuthCubit authCubit;
  final PostCubit postCubit;

  final commentsCache = ValueNotifier<Map<int, List<Comment>>>({});

  CommentsCubit(
      {required this.getCommentsUseCase,
      required this.postComment,
      required this.authCubit,
      required this.postCubit})
      : super(CommentsInitial());

  Future<void> getComments(int postId) async {
    if (commentsCache.value.containsKey(postId)) {
      emit(CommentsLoaded(comments: commentsCache.value[postId]!));
    } else {
      emit(CommentsLoading());
      final response = await getCommentsUseCase(Params1(postId: postId));
      emit(response.fold(
        (failure) => CommentsError(message: _mapFailureToMessage(failure)),
        (comments) {
          commentsCache.value[postId] = comments;
          return CommentsLoaded(comments: comments);
        },
      ));
    }
  }

  Future<void> postComments(int postId, String comment) async {
    // emit(CommentsLoading());

    // log(authCubit.state.toString());
    final user = (authCubit.state as AuthAuthenticated).user;

    final failureOrVoid =
        await postComment(Params(postId: postId, comment: comment));

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
          replies: [],
          firstName: user.firstName,
          lastName: user.lastName,
          profilePicture: user.profilePicture ?? 'assets/images/edu.png',
        );

        // Add the new comment to the cache
        commentsCache.value[postId]!.add(newComment);

        commentsCache.notifyListeners();

        // Emit the new state
        emit(CommentsLoaded(comments: commentsCache.value[postId]!));
        // log(postCubit.state.toString());
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
