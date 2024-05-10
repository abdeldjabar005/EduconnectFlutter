part of 'post2_cubit.dart';

abstract class Post2State extends Equatable {
  const Post2State();
  
  @override
  List<Object> get props => [];
}

class Post2Initial extends Post2State {}

class Post2Loading extends Post2State {}
class MembersLoading extends Post2State {}

class Post2Loaded extends Post2State {
  final List<PostModel> posts;
  final bool hasReachedMax;
  const Post2Loaded({required this.posts, this.hasReachedMax = false});

  Post2Loaded copyWith({
    List<PostModel>? posts,
  }) {
    return Post2Loaded(
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class Post2Loaded2 extends Post2State {
  final PostModel post;

  Post2Loaded2({required this.post});

  @override
  List<Object> get props => [post];
}

class Post2Error extends Post2State {
  final String message;

  Post2Error(this.message);

  @override
  List<Object> get props => [message];
}

class Post2NoData extends Post2State {
  final String message;

  Post2NoData(this.message);

  @override
  List<Object> get props => [message];
}

class AssociateStudentSuccess extends Post2State {}

class StudentAlreadyAssociated extends Post2State {}
class MembersError extends Post2State {
  final String message;

  MembersError(this.message);

  @override
  List<Object> get props => [message];
}
