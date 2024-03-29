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

  const CommentsLoaded({required this.comments});

  @override
  List<Object> get props => [comments];
}

class CommentsError extends CommentsState {
  final String message;

  const CommentsError({required this.message});

  @override
  List<Object> get props => [message];
}