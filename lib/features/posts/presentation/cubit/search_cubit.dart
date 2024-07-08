import 'package:bloc/bloc.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/classrooms/domain/entities/school.dart';
import 'package:educonnect/features/posts/data/models/search_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final PostRepository postRepository;
  final schools = ValueNotifier<Map<int, SearchModel>>({});

  SearchCubit({required this.postRepository}) : super(SearchInitial());

  Future<void> searchSchools(String query) async {
    emit(SearchLoading());
    final response = await postRepository.search(query);
    response.fold(
      (failure) => emit(SearchError(_mapFailureToMessage(failure))),
      (schools) {
        this.schools.value = {for (var v in schools) v.id: v};
        emit(SearchLoaded(schools));
      },
    );
  }

  Future<void> sendJoinRequest(int id) async {
    emit(SearchLoading());
    final response = await postRepository.joinSchoolRequest(id);
    response.fold(
      (failure) => emit(SearchError(_mapFailureToMessage(failure))),
      (success) {
        if (schools.value.containsKey(id)) {
          schools.value[id] = schools.value[id]!.copyWith(isMember: 2);
        }
        emit(SearchLoaded(schools.value.values.toList()));
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
