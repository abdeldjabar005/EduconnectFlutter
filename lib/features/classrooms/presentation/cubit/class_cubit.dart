import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/classrooms/data/models/class_m.dart';
import 'package:quotes/features/classrooms/data/models/class_member.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/data/models/school_m.dart';
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
  List<ClassModel>? _classes = [];

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

  Future<void> getClasses(int id, {bool useCache = true}) async {
    if (useCache && classesCache.value.containsKey(id)) {
      final classes = classesCache.value[id];
      if (classes != null && classes.isNotEmpty) {
        emit(ClassesLoaded(classes));
        return;
      }
    }

    try {
      emit(ClassLoading());
      final result = await classroomRepository.getClasses(id);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (classes) {
          classesCache.value[id] = classes;
          classesCache.notifyListeners();
          if (classes.isNotEmpty) {
            emit(ClassesLoaded(classes));
          } else {
            emit(NoClasses("This school has no classes"));
          }
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> getTeacherClasses(int? id, {bool useCache = true}) async {
    if (useCache && classesCache.value.containsKey(id)) {
      final classes = classesCache.value[id];
      if (classes != null && classes.isNotEmpty) {
        emit(ClassesLoaded(classes));
        return;
      }
    }
    try {
      emit(ClassLoading());
      final result = await classroomRepository.getTeacherClasses(id);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (classes) {
          log(classes.toString());
          List<ClassMemberModel> classMemberModels = classes.map((classModel) {
            return ClassMemberModel(classModel: classModel, isMember: true);
          }).toList();
          classesCache.value[id!] = classMemberModels;
          classesCache.notifyListeners();
          if (classMemberModels.isNotEmpty) {
            emit(TeacherClassesLoaded(classes));
          } else {
            emit(NoClasses("This school has no classes"));
          }
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> addClass(ClassM newClass, File? image) async {
    try {
      emit(ClassLoading());
      final result = await classroomRepository.addClass(newClass, image);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (classModel) {
          List<ClassModel> newList = List.from(classCache.value);
          newList.add(classModel);
          classCache.value = newList;
          classCache.notifyListeners();
          emit(ClassLoaded(classModel));
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> removeClass(int id) async {
    try {
      emit(ClassLoading());
      final result = await classroomRepository.removeClass(id);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (_) async {
          await getTeacherClasses(id, useCache: false);
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> updateClass(int id, ClassM classToUpdate, File? image) async {
    try {
      emit(ClassLoading());
      final result =
          await classroomRepository.updateClass(classToUpdate, image);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (_) async {
          await getTeacherClasses(id, useCache: false);
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> addSchool(SchoolM newSchool, File? image) async {
    emit(ClassLoading());
    final result = await classroomRepository.addSchool(newSchool, image);
    result.fold(
      (failure) {
        emit(ClassError(_mapFailureToMessage(failure)));
      },
      (schoolModel) {
        List<SchoolModel> newList = List.from(schoolCache.value);
        newList.add(schoolModel);
        schoolCache.value = newList;
        schoolCache.notifyListeners();
        emit(SchoolLoaded(schoolModel));
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
