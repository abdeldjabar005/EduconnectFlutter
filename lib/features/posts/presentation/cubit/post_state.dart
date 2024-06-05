part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> explorePosts;
  final List<PostModel> schoolPosts;
  final List<PostModel> classPosts;
  final List<PostModel> bookmarksPosts;
  final bool hasReachedMax;

  const PostLoaded({
    required this.explorePosts,
    required this.schoolPosts,
    required this.classPosts,
    required this.bookmarksPosts,
    this.hasReachedMax = false,
  });

  PostLoaded copyWith({
    List<PostModel>? explorePosts,
    List<PostModel>? schoolPosts,
    List<PostModel>? classPosts,
    List<PostModel>? bookmarksPosts,
    bool? hasReachedMax,
  }) {
    return PostLoaded(
      explorePosts: explorePosts ?? this.explorePosts,
      schoolPosts: schoolPosts ?? this.schoolPosts,
      classPosts: classPosts ?? this.classPosts,
      bookmarksPosts: bookmarksPosts ?? this.bookmarksPosts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [explorePosts, schoolPosts, classPosts, bookmarksPosts, hasReachedMax];
}


class PostLoaded2 extends PostState {
  final PostModel post;
  const PostLoaded2({required this.post});

  @override
  List<Object> get props => [post];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object> get props => [message];
}
