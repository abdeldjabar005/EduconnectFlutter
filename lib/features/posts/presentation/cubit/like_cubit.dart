import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/usecases/like_post.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final LikePost likePostUseCase;

  LikeCubit({
    required this.likePostUseCase,
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
}
