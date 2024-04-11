part of 'comment_cubit.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;
  final int commentsCount;
  const CommentsLoaded({required this.comments, required this.commentsCount});

  @override
  List<Object> get props => [comments];
}

class CommentLoaded extends CommentsState {
  final Comment comment;

  const CommentLoaded({required this.comment});

  @override
  List<Object> get props => [comment];
}
class NoComments extends CommentsState {
  final String message;

  const NoComments({required this.message});

  @override
  List<Object> get props => [message];
}
class CommentsError extends CommentsState {
  final String message;

  const CommentsError({required this.message});

  @override
  List<Object> get props => [message];
}

class RepliesLoaded extends CommentsState {
  final int id;
  final int repliesCount;

  const RepliesLoaded({required this.id, required this.repliesCount});

  @override
  List<Object> get props => [id, repliesCount];
}
