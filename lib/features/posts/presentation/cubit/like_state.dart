

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