import 'dart:developer';
import 'dart:io';

import 'package:educonnect/core/error/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_class.dart';
import 'package:educonnect/features/posts/data/models/post_m.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

part 'post2_state.dart';

class Post2Cubit extends Cubit<Post2State> {
  final ClassroomRepository classroomRepository;
  final GetPostsUseCase getClassroomPostsUseCase;
  final PostRepository postRepository;

  final postsCache = ValueNotifier<Map<int, List<PostModel>>>({});
  final maxCache = ValueNotifier<Map<int, bool>>({});

  Post2Cubit(
      {required this.classroomRepository,
      required this.getClassroomPostsUseCase,
      required this.postRepository})
      : super(Post2Initial());

  Future<void> getClassroomPosts(
      int id, int page, String? type, bool refresh) async {
    // if (postsCache.value.containsKey(id) &&
    //     !refresh &&
    //     (maxCache.value[id] ?? false)) {
    //   log("Cache hit");
    //   final posts = postsCache.value[id];
    //   if (posts != null && posts.isNotEmpty) {
    //     log("if statement hit");
    //     bool hasReachedMax = maxCache.value[id] ?? false;
    //     emit(Post2Loaded(posts: posts, hasReachedMax: hasReachedMax));
    //     log(state.toString());
    //   } else {
    //     log("else statement hit");
    //     emit(Post2NoData("No posts found"));
    //   }
    // } else {
    emit(Post2Loading());
    log("Cache miss");
    final response =
        await getClassroomPostsUseCase(Params3(id: id, page: page, type: type));
    response.fold(
      (failure) {
        emit(Post2Error(_mapFailureToMessage(failure)));
      },
      (result) {
        postsCache.value[id] = result.data;
        log("Page: ${result.meta.currentPage} of ${result.meta.lastPage}");
        if (result.meta.currentPage >= result.meta.lastPage) {
          log(result.data.toString());
          maxCache.value[id] = true;
          emit(Post2Loaded(posts: result.data, hasReachedMax: true));
        } else {
          emit(Post2Loaded(posts: result.data, hasReachedMax: false));
        }
      },
    );
    // }
  }

  Future<void> newPost(PostM post, List<File>? images, String? schoolClass,
      String? pollQuestion, List<String>? pollOptions) async {
    emit(Post2Loading());

    final response = await postRepository.newPost(
        post, images, schoolClass, pollQuestion, pollOptions);
    response.fold((failure) => emit(Post2Error(_mapFailureToMessage(failure))),
        (post) {
      if (post != null) {
        log(post.classOrSchoolId.toString());
        // Add the new post to the cache
        if (postsCache.value.containsKey(post.classOrSchoolId)) {
          postsCache.value[post.classOrSchoolId]!.insert(0, post);
        } else {
          postsCache.value[post.classOrSchoolId] = [post];
        }
        // Fetch all the posts again
        getClassroomPosts(post.classOrSchoolId, 1, schoolClass, true);
        emit(Post2Loaded2(post: post));
      } else {
        emit(Post2Error("Failed to create new post"));
      }
    });
  }
  Future<void> removePost(int postId, int classOrSchoolId) async {
    emit(Post2Loading());
  
    final response = await postRepository.removePost(postId);
    response.fold(
      (failure) {
        emit(Post2Error(_mapFailureToMessage(failure)));
      },
      (_) {
        final posts = postsCache.value[classOrSchoolId];
        if (posts != null) {
          final index = posts.indexWhere((post) => post.id == postId);
          if (index != -1) {
            posts.removeAt(index);
            postsCache.value[classOrSchoolId] = posts;
          }
        }
        emit(Post2Loaded(
            posts: postsCache.value[classOrSchoolId] ?? [],
            hasReachedMax: maxCache.value[classOrSchoolId] ?? false));
      },
    );
  }

  Future<void> associateStudent(
      int studentId, int schoolId, String type) async {
    emit(MembersLoading());
    final result =
        await classroomRepository.associateStudent(studentId, schoolId, type);
    result.fold(
      (failure) {
        if (failure is StudentAlreadyAssociatedException) {
          emit(StudentAlreadyAssociated());
        } else {
          emit(MembersError(_mapFailureToMessage(failure)));
        }
      },
      (_) {
        emit(AssociateStudentSuccess());
      },
    );
  }

  Future<void> voteOnPoll(int postId, String option) async {
    emit(Post2Loading());

    final response = await postRepository.voteOnPoll(postId, option);
    response.fold(
      (failure) {
        emit(Post2Error(_mapFailureToMessage(failure)));
      },
      (updatedPost) {
        final posts = postsCache.value[updatedPost.classOrSchoolId];
        if (posts != null) {
          final index = posts.indexWhere((post) => post.id == postId);
          if (index != -1) {
            posts[index] = updatedPost;
            postsCache.value[updatedPost.classOrSchoolId] = posts;
          }
        }
        emit(Post2Loaded(
            posts: postsCache.value[updatedPost.classOrSchoolId] ?? [],
            hasReachedMax:
                maxCache.value[updatedPost.classOrSchoolId] ?? false));
      },
    );
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
