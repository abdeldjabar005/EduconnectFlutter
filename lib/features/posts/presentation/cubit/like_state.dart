

part of 'like_cubit.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitial extends LikeState {}


class LikeLoading extends LikeState {}

class PostLiked extends LikeState {
  final String postId;
  final bool isLiked;
  final int likesCount;
  const PostLiked({required this.postId, required this.isLiked, required this.likesCount});

  @override
  List<Object> get props => [postId, isLiked];
}

class CommentLiked extends LikeState {
  final int commentId;
  final bool isLiked;
  final int likesCount;
  const CommentLiked({required this.commentId, required this.isLiked, required this.likesCount});

  @override
  List<Object> get props => [commentId, isLiked];
}

class ReplyLiked extends LikeState {
  final int replyId;
  final bool isLiked;
  final int likesCount;
  const ReplyLiked({required this.replyId, required this.isLiked, required this.likesCount});

  @override
  List<Object> get props => [replyId, isLiked];
}