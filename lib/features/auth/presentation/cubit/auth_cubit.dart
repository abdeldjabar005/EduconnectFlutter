import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/auth/data/repositories/token_repository.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_m.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  String selectedRole = '';
  late User? currentUser;
  final TokenProvider tokenProvider;
  final FlutterSecureStorage secureStorage;

  AuthCubit(
      {required this.authRepository,
      required this.tokenProvider,
      required this.secureStorage})
      : super(AuthInitial());

  Future<Either<Failure, User>> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.login(email, password);
    return result.fold((failure) {
      if (failure is InvalidCredentialsException) {
        emit(AuthError(
            message: _mapFailureToMessage(InvalidCredentialsFailure())));
        return Left(InvalidCredentialsFailure());
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
        return Left(failure);
      }
    }, (user) async {
      await secureStorage.write(key: 'email', value: email);
      await secureStorage.write(key: 'password', value: password);

      currentUser = user;
      log("loginsuccesfully");
      emit(AuthAuthenticated(user: user));
      log(state.toString());
      return Right(user);
    });
  }

  // Future<void> signUp(String firstName, String lastName, String role,
  //     String email, String password, String confirmPassword) async {
  //   emit(AuthLoading());
  //   final result = await authRepository.signUp(
  //       email, password, role, email, password, confirmPassword);
  //   _eitherLoadedOrErrorState(result);
  // }
  Future<void> signUp(String firstName, String lastName, String role,
      String email, String password, String confirmPassword) async {
    emit(AuthLoading());
    final result = await authRepository.signUp(
        firstName, lastName, role, email, password, confirmPassword);
    result.fold((failure) {
      if (failure is EmailAlreadyExistsException) {
        emit(AuthError(
            message: _mapFailureToMessage(EmailAlreadyExistsFailure())));
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (user) async {
      currentUser = user;
      emit(AuthEmailVerificationNeeded());
      await secureStorage.write(key: 'email', value: email);
      await secureStorage.write(key: 'password', value: password);
    });
  }

  Future<void> verifyEmail(String email, String verificationCode) async {
    emit(AuthLoading());
    final result = await authRepository.verifyEmail(email, verificationCode);
    _eitherLoadedOrErrorState2(result);
  }

  Future<void> resendEmail(String email) async {
    try {
      final result = await authRepository.resendEmail(email);
    } on ServerException {
      emit(AuthError(message: 'Server Failure'));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await authRepository.forgotPassword(email);
    result.fold((failure) {
      if (failure is EmailDoesNotExistException) {
        emit(AuthError(
            message: _mapFailureToMessage(EmailDoesNotExistFailure())));
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (right) {
      emit(AuthCodeSent());
    });
  }

  Future<void> validateOtp(String code) async {
    emit(AuthLoading());
    final result = await authRepository.validateOtp(code);
    result.fold((failure) {
      if (failure is InvalidCodeException) {
        emit(AuthError(message: _mapFailureToMessage(InvalidCodeFailure())));
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (right) {
      emit(AuthEmailVerified());
    });
  }

  Future<void> resetPassword(String password, String confirmPassword) async {
    emit(AuthLoading());
    final result =
        await authRepository.resetPassword(password, confirmPassword);
    result.fold((failure) {
      if (failure is InvalidCredentialsException) {
        emit(AuthError(
            message: _mapFailureToMessage(InvalidCredentialsFailure())));
      } else {
        emit(AuthError(message: _mapFailureToMessage(failure)));
      }
    }, (right) {
      emit(AuthPasswordReset());
    });
  }

  User? getCurrentUser() {
    return state is AuthAuthenticated
        ? (state as AuthAuthenticated).user
        : null;
  }

  void emitAuthenticated() {
    emit(AuthAuthenticated(user: currentUser!));
  }

  void _eitherLoadedOrErrorState(Either<Failure, User> failureOrUser) {
    emit(
      failureOrUser.fold(
        (failure) {
          if (failure is EmailAlreadyExistsException) {
            return AuthError(
                message: _mapFailureToMessage(EmailAlreadyExistsFailure()));
          } else {
            return AuthError(message: _mapFailureToMessage(failure));
          }
        },
        (user) => AuthAuthenticated(user: user),
      ),
    );
  }

  void reset() {
    currentUser = null;
    emit(AuthInitial());
  }

  Future<void> logout() async {
    await tokenProvider.logout();
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');

    currentUser = null;
    emit(AuthInitial());
  }

  Future<bool> autoLogin() async {
    final email = await secureStorage.read(key: 'email');
    final password = await secureStorage.read(key: 'password');
    log(email.toString());
    log(password.toString());
    if (email != null && password != null) {
      final result = await login(email, password);
      return result.isRight();
    }

    return false;
  }

  void addSchool(SchoolModel school) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedSchools = currentState.user.schools;
      updatedSchools.add(school);

      final updatedUser =
          currentState.user.copyWith(school: school, schools: updatedSchools);
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void addClass(ClassModel classModel) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedClasses = currentState.user.classes;
      updatedClasses.add(classModel);
      final updatedUser = currentState.user.copyWith(classes: updatedClasses);
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void updateClass(ClassModel updatedClass) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedClasses = currentState.user.classes.map((classModel) {
        if (classModel.id == updatedClass.id) {
          return updatedClass;
        } else {
          return classModel;
        }
      }).toList();

      final updatedUser = currentState.user.copyWith(classes: updatedClasses);
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void updateSchool(SchoolModel updatedSchool) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final updatedSchools = currentState.user.schools.map((schoolModel) {
        if (schoolModel.id == updatedSchool.id) {
          return updatedSchool;
        } else {
          return schoolModel;
        }
      }).toList();

      final updatedUser = currentState.user
          .copyWith(schools: updatedSchools, school: updatedSchool);
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void removeClass(int id) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      currentState.user.classes.removeWhere((classe) => classe.id == id);
      final updatedUser =
          currentState.user.copyWith(classes: currentState.user.classes);
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void removeSchool(int id) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      currentState.user.schools
          .removeWhere((schoolModel) => schoolModel.id == id);

      final updatedUser = currentState.user.copyWith(school: null);
      log(updatedUser.toString());
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void leaveSchool(int id) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      currentState.user.schools
          .removeWhere((schoolModel) => schoolModel.id == id);

      final updatedUser =
          currentState.user.copyWith(schools: currentState.user.schools);
      log(updatedUser.toString());
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  void _eitherLoadedOrErrorState2(Either<Failure, User> failureOrUser) {
    emit(
      failureOrUser.fold(
        (failure) {
          if (failure is EmailAlreadyExistsException) {
            return AuthError(
                message: _mapFailureToMessage(EmailAlreadyExistsFailure()));
          } else {
            return AuthError(message: _mapFailureToMessage(failure));
          }
        },
        (user) => AuthEmailVerified(),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case InvalidCredentialsFailure:
        return 'Invalid credentials';
      case EmailAlreadyExistsFailure:
        return 'Email already exists';
      case EmailDoesNotExistFailure:
        return 'Email does not exist';
      case InvalidCodeFailure:
        return 'Invalid code';

      default:
        return 'Unexpected error';
    }
  }
}
