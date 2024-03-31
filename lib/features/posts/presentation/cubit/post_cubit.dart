import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/usecases/get_post.dart';
import 'package:quotes/features/posts/domain/usecases/get_posts.dart';
import 'package:equatable/equatable.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPosts getPostsUseCase;
  final GetPost getPostUseCase;
  PostCubit({
    required this.getPostsUseCase,
    required this.getPostUseCase,
  }) : super(PostInitial());

  Future<void> getPosts(int page) async {
    emit(PostLoading());
    final response = await getPostsUseCase(Params(page: page));
    emit(response.fold(
      (failure) => PostError(message: _mapFailureToMessage(failure)),
      (posts) => PostLoaded(posts: posts),
    ));
  }

  Future<void> getPost(int id) async {
    // emit(PostLoading());
    // log('getPost called with id: $id');

    final response = await getPostUseCase(id);
    response.fold(
        (failure) => emit(PostError(message: _mapFailureToMessage(failure))),
        (post) {
      emit(PostLoaded2(post: post));
    });
  }

void refresh() {
    emit(PostInitial());
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
