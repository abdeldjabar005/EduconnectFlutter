// post_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/usecases/get_comments.dart';
part 'comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final GetComments getCommentsUseCase;
  final Map<int, List<Comment>> commentsCache = {};

  CommentsCubit({
    required this.getCommentsUseCase,
  }) : super(CommentsInitial());

  Future<void> getComments(int postId) async {
    if (commentsCache.containsKey(postId)) {
      emit(CommentsLoaded(comments: commentsCache[postId]!));
    } else {
      emit(CommentsLoading());
      final response = await getCommentsUseCase(Params(postId: postId));
      emit(response.fold(
        (failure) => CommentsError(message: _mapFailureToMessage(failure)),
        (comments) {
          commentsCache[postId] = comments;
          return CommentsLoaded(comments: comments);
        },
      ));
    }
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
