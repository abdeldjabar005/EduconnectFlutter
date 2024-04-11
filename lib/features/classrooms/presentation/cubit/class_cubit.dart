import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassroomRepository classroomRepository;

  ClassCubit({required this.classroomRepository}) : super(ClassInitial());

  Future<void> joinClass(String code) async {
    emit(ClassLoading());
    final result = await classroomRepository.joinClass(code);
    result.fold(
      (failure) {
        if (failure is JoinedFailure) {
          emit(ClassError("You are already enrolled in this class"));
        } else if (failure is InvalidCodeFailure) {
          emit(ClassError("Invalid code"));
        } else {
          emit(ClassError(_mapFailureToMessage(failure)));
        }
      },
      (classModel) => emit(ClassLoaded(classModel)),
    );
  }

  Future<void> joinSchool(String code) async {
    emit(ClassLoading());
    final result = await classroomRepository.joinSchool(code);
    result.fold(
      (failure) {
        if (failure is JoinedFailure) {
          emit(ClassError("You are already enrolled in this class"));
        } else if (failure is InvalidCodeFailure) {
          emit(ClassError("Invalid code"));
        } else {
          emit(ClassError(_mapFailureToMessage(failure)));
        }
      },
      (schoolModel) => emit(SchoolLoaded(schoolModel)),
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
