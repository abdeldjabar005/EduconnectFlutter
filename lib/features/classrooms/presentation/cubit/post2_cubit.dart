import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:quotes/features/classrooms/domain/usecases/get_class.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

part 'post2_state.dart';

class Post2Cubit extends Cubit<Post2State> {
  final ClassroomRepository classroomRepository;
  final GetPostsUseCase getClassroomPostsUseCase;

  final postsCache = ValueNotifier<Map<int, List<PostModel>>>({});
  final maxCache = ValueNotifier<Map<int, bool>>({});

  Post2Cubit(
      {required this.classroomRepository,
      required this.getClassroomPostsUseCase})
      : super(Post2Initial());

  Future<void> getClassroomPosts(
      int id, int page, String type, bool refresh) async {
    if (postsCache.value.containsKey(id) && !refresh) {
      log("Cache hit");
      final posts = postsCache.value[id];
      if (posts != null && posts.isNotEmpty) {
        log("if statement hit");
        bool hasReachedMax = maxCache.value[id] ?? false;
        emit(Post2Loaded(posts: posts, hasReachedMax: hasReachedMax));
        log(state.toString());
      } else {
        log("else statement hit");
        emit(Post2NoData("No posts found"));
      }
    } else {
      emit(Post2Loading());
      log("Cache miss");
      final response = await getClassroomPostsUseCase(
          Params3(id: id, page: page, type: type));

      response.fold(
        (failure) {
          emit(Post2Error(_mapFailureToMessage(failure)));
        },
        (posts) {
          postsCache.value[id] = posts;
          if (posts.length < 6) {
            log(posts.toString());
            maxCache.value[id] = true;
            emit(Post2Loaded(posts: posts, hasReachedMax: true));
          } else {
            emit(Post2Loaded(posts: posts, hasReachedMax: false));
          }
        },
      );
    }
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
