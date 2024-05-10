import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/data/models/class_m.dart';
import 'package:educonnect/features/classrooms/data/models/class_member.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/member_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_m.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:educonnect/features/classrooms/domain/usecases/get_memebrs.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';

part 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassroomRepository classroomRepository;
  final GetMembersUseCase getMembersUseCase;
  final AuthCubit authCubit;
  final schoolCache = ValueNotifier<List<SchoolModel>>([]);
  final classCache = ValueNotifier<List<ClassModel>>([]);
  final classesCache = ValueNotifier<Map<int, List<ClassMemberModel>>>({});
  List<ClassModel>? _classes = [];

  ClassCubit(
      {required this.classroomRepository,
      required this.getMembersUseCase,
      required this.authCubit})
      : super(ClassInitial());

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
      List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
      newList.add(schoolModel);
      schoolCache.value = newList;
      schoolCache.notifyListeners();
      authCubit.addSchool(schoolModel);
      emit(SchoolLoaded(schoolModel));
    });
  }

  Future<void> addSchool(SchoolM newSchool, File? image) async {
    emit(ClassLoading());
    final result = await classroomRepository.addSchool(newSchool, image);
    result.fold(
      (failure) {
        emit(ClassError(_mapFailureToMessage(failure)));
      },
      (schoolModel) {
        List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
        newList.add(schoolModel);
        schoolCache.value = newList;
        schoolCache.notifyListeners();
        authCubit.addSchool(schoolModel);
        emit(SchoolLoaded(schoolModel));
      },
    );
  }

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
        List<ClassModel> newList = List.from(authCubit.currentUser!.classes);
        newList.add(classModel);
        _classes!.add(classModel);
        classCache.value = newList;
        classCache.notifyListeners();
        authCubit.addClass(classModel);
        emit(ClassLoaded(classModel));
      },
    );
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
    if (useCache && _classes != null && _classes!.isNotEmpty) {
      emit(TeacherClassesLoaded(_classes!));
      return;
    }

    try {
      emit(ClassLoading());
      final result = await classroomRepository.getTeacherClasses(id);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (classes) {
          _classes = classes;
          if (classes.isNotEmpty) {
            emit(TeacherClassesLoaded(classes));
          } else {
            emit(NoClasses("You dont have classes"));
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
          List<ClassModel> newList = List.from(authCubit.currentUser!.classes);
          newList.add(classModel);
          _classes!.add(classModel);
          classCache.value = newList;
          classCache.notifyListeners();
          authCubit.addClass(classModel);
          emit(TeacherClassesLoaded(_classes!));
          // emit(ClassLoaded(classModel));
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
          List<ClassModel> newList = List.from(authCubit.currentUser!.classes);
          newList.removeWhere((classModel) => classModel.id == id);
          classCache.value = newList;
          classCache.notifyListeners();
          authCubit.removeClass(id);

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
          await classroomRepository.updateClass(id, classToUpdate, image);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (updatedClass) async {
          List<ClassModel> newList = List.from(authCubit.currentUser!.classes);
          int indexToUpdate =
              newList.indexWhere((classModel) => classModel.id == id);
          if (indexToUpdate != -1) {
            newList[indexToUpdate] = updatedClass;
            classCache.value = newList;
            classCache.notifyListeners();
            authCubit.updateClass(updatedClass);
          }
          await getTeacherClasses(id, useCache: false);
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> updateSchool(int id, SchoolM schoolToUpdate, File? image) async {
    try {
      emit(ClassLoading());
      final result =
          await classroomRepository.updateSchool(id, schoolToUpdate, image);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (updatedSchool) async {
          List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
          int indexToUpdate =
              newList.indexWhere((schoolModel) => schoolModel.id == id);

          if (indexToUpdate != -1) {
            log("indextoupdate is not -1 ");
            newList[indexToUpdate] = updatedSchool;
            schoolCache.value = newList;
            schoolCache.notifyListeners();
            authCubit.updateSchool(updatedSchool);
          }
          emit(SchoolLoaded(updatedSchool));
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> removeSchool(int id) async {
    try {
      emit(ClassLoading());
      final result = await classroomRepository.removeSchool(id);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (_) async {
          List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
          newList.removeWhere((schoolModel) => schoolModel.id == id);
          schoolCache.value = newList;
          schoolCache.notifyListeners();
          authCubit.removeSchool(id);

          emit(SchoolRemoved());
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> leave(int id, String type) async {
    emit(ClassLoading());
    final result = await classroomRepository.leave(id, type);
    result.fold(
      (failure) {
        emit(ClassError(_mapFailureToMessage(failure)));
      },
      (_) {
        if (type == 'class') {
          List<ClassModel> newList = List.from(authCubit.currentUser!.classes);
          newList.removeWhere((classModel) => classModel.id == id);
          classCache.value = newList;
          classCache.notifyListeners();
          authCubit.removeClass(id);
        } else if (type == 'school') {
          List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
          newList.removeWhere((schoolModel) => schoolModel.id == id);
          schoolCache.value = newList;
          schoolCache.notifyListeners();
          authCubit.leaveSchool(id);
        }
        emit(LeftSuccess());
      },
    );
  }

  Future<void> getStudents(int id, String type) async {
    emit(ClassLoading2());
    final result = await classroomRepository.getStudents(id, type);
    result.fold(
      (failure) {
        emit(ClassError(_mapFailureToMessage(failure)));
      },
      (students) {
        emit(StudentsLoaded(students));
      },
    );
  }

  Future<void> sendJoinRequest(int classId, int schoolId) async {
    emit(ClassLoading());
    final result = await classroomRepository.sendJoinRequest(classId);
    result.fold(
      (failure) {
        if (failure is JoinedFailure) {
          emit(ClassError("You are already enrolled in this class"));
        } else {
          emit(ClassError(_mapFailureToMessage(failure)));
        }
      },
      (_) {
        getClasses(schoolId, useCache: false);

        emit(RequestSent());
      },
    );
  }

  Future<void> schoolVerifyRequest(
      int schoolId, String email, String phoneNumber, File? file) async {
    try {
      emit(ClassLoading());
      final result = await classroomRepository.schoolVerifyRequest(
          schoolId, email, phoneNumber, file);
      result.fold(
        (failure) => emit(ClassError(_mapFailureToMessage(failure))),
        (updatedSchool) async {
          List<SchoolModel> newList = List.from(authCubit.currentUser!.schools);
          int indexToUpdate =
              newList.indexWhere((schoolModel) => schoolModel.id == schoolId);
          if (indexToUpdate != -1) {
            newList[indexToUpdate] = updatedSchool;
            schoolCache.value = newList;
            schoolCache.notifyListeners();
            authCubit.updateSchool(updatedSchool);
          }
          emit(SchoolVerifyRequested(updatedSchool));
        },
      );
    } catch (e) {
      emit(ClassError(e.toString()));
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
