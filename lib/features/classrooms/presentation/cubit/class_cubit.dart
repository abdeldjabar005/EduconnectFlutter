import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/classrooms/data/models/class_m.dart';
import 'package:quotes/features/classrooms/data/models/class_member.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:quotes/features/classrooms/domain/usecases/get_memebrs.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassroomRepository classroomRepository;
  final GetMembersUseCase getMembersUseCase;
  final schoolCache = ValueNotifier<List<SchoolModel>>([]);
  final classCache = ValueNotifier<List<ClassModel>>([]);
  final classesCache = ValueNotifier<Map<int, List<ClassMemberModel>>>({});

  ClassCubit(
      {required this.classroomRepository, required this.getMembersUseCase})
      : super(ClassInitial());

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
      (classModel) {
        List<ClassModel> newList = List.from(classCache.value);
        newList.add(classModel);
        classCache.value = newList;
        classCache.notifyListeners();
        emit(ClassLoaded(classModel));
      },
    );
  }

  Future<void> joinSchool(String code) async {
    emit(ClassLoading());
    final result = await classroomRepository.joinSchool(code);
    result.fold((failure) {
      if (failure is JoinedFailure) {
        emit(ClassError("You are already enrolled in this class"));
      } else if (failure is InvalidCodeFailure) {
        emit(ClassError("Invalid code"));
      } else {
        emit(ClassError(_mapFailureToMessage(failure)));
      }
    }, (schoolModel) {
      List<SchoolModel> newList = List.from(schoolCache.value);
      newList.add(schoolModel);
      schoolCache.value = newList;
      schoolCache.notifyListeners();
      emit(SchoolLoaded(schoolModel));
    });
  }

  Future<void> getClasses(int id) async {
    if (classesCache.value.containsKey(id)) {
      final classes = classesCache.value[id];
      if (classes != null && classes.isNotEmpty) {
        emit(ClassesLoaded(classes));
      } else {
        emit(NoClasses("No classes found"));
      }
    } else {
      emit(ClassLoading());
      final result = await classroomRepository.getClasses(id);
      result.fold(
        (failure) {
          emit(ClassError(_mapFailureToMessage(failure)));
        },
        (classes) {
          classesCache.value[id] = classes;
          if (classes.isNotEmpty) {
            emit(ClassesLoaded(classes));
          } else {
            emit(NoClasses("This school has no classes"));
          }
        },
      );
    }
  }
Future<void> addClass(ClassM newClass) async {
  emit(ClassLoading());
  final result = await classroomRepository.addClass(newClass);
  result.fold(
    (failure) {
      emit(ClassError(_mapFailureToMessage(failure)));
    },
    (classModel) {
      List<ClassModel> newList = List.from(classCache.value);
      newList.add(classModel);
      classCache.value = newList;
      classCache.notifyListeners();
      emit(ClassLoaded(classModel));
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
