// post_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/usecases/get_posts.dart';
import 'package:equatable/equatable.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPosts getPostsUseCase;

  PostCubit({required this.getPostsUseCase}) : super(PostInitial());

  Future<void> getPosts() async {
    emit(PostLoading());
    final response = await getPostsUseCase(NoParams());
    emit(response.fold(
      (failure) => PostError(message: _mapFailureToMessage(failure)),
      (posts) => PostLoaded(posts: posts),
    ));
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