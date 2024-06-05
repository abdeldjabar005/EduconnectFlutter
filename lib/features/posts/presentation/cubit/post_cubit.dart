import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_class.dart';
import 'package:educonnect/features/posts/data/models/post_m.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';
import 'package:educonnect/features/posts/domain/usecases/check_liked.dart';
import 'package:educonnect/features/posts/domain/usecases/get_post.dart';
import 'package:educonnect/features/posts/domain/usecases/get_posts.dart';
import 'package:equatable/equatable.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetPosts getPostsUseCase;
  final GetPost getPostUseCase;
  final CheckIfPostIsLiked checkIfPostIsLikedUseCase;
  final PostRepository postRepository;
  PostCubit({
    required this.getPostsUseCase,
    required this.getPostUseCase,
    required this.checkIfPostIsLikedUseCase,
    required this.postRepository,
  }) : super(PostInitial());
  
Future<void> getPosts(int page, String type) async {
  emit(PostLoading());
  final response = await getPostsUseCase(Params(page: page, type: type));
  emit(response.fold(
    (failure) => PostError(message: _mapFailureToMessage(failure)),
    (posts) {
      final hasReachedMax = posts.length < 6;
      if (state is PostLoaded) {
        final loadedState = state as PostLoaded;
        switch (type) {
          case 'explore':
            return loadedState.copyWith(
              explorePosts: [...loadedState.explorePosts, ...posts],
              hasReachedMax: hasReachedMax,
            );
          case 'school':
            return loadedState.copyWith(
              schoolPosts: [...loadedState.schoolPosts, ...posts],
              hasReachedMax: hasReachedMax,
            );
          case 'class':
            return loadedState.copyWith(
              classPosts: [...loadedState.classPosts, ...posts],
              hasReachedMax: hasReachedMax,
            );
          case 'bookmarks':
            return loadedState.copyWith(
              bookmarksPosts: [...loadedState.bookmarksPosts, ...posts],
              hasReachedMax: hasReachedMax,
            );
          default:
            return loadedState;
        }
      }
      switch (type) {
        case 'explore':
          return PostLoaded(
            explorePosts: posts,
            schoolPosts: [],
            classPosts: [],
            bookmarksPosts: [],
            hasReachedMax: hasReachedMax,
          );
        case 'school':
          return PostLoaded(
            explorePosts: [],
            schoolPosts: posts,
            classPosts: [],
            bookmarksPosts: [],
            hasReachedMax: hasReachedMax,
          );
        case 'class':
          return PostLoaded(
            explorePosts: [],
            schoolPosts: [],
            classPosts: posts,
            bookmarksPosts: [],
            hasReachedMax: hasReachedMax,
          );
        case 'bookmarks':
          return PostLoaded(
            explorePosts: [],
            schoolPosts: [],
            classPosts: [],
            bookmarksPosts: posts,
            hasReachedMax: hasReachedMax,
          );
        default:
          return PostLoaded(
            explorePosts: [],
            schoolPosts: [],
            classPosts: [],
            bookmarksPosts: [],
            hasReachedMax: hasReachedMax,
          );
      }
    },
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
