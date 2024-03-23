import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/features/auth/domain/entities/user.dart';
import 'package:quotes/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  String selectedRole = '';
  late User? currentUser;
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.login(email, password);
    _eitherLoadedOrErrorState(result);
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
    },
        (user) => {
              currentUser = user,
              emit(AuthEmailVerificationNeeded()),
            });
  }

  void updateVerificationCode(List<String> newCode) {
    emit(AuthCodeEntry(verificationCode: newCode));
  }

  Future<void> verifyEmail(String email, String verificationCode) async {
    emit(AuthLoading());
    final result = await authRepository.verifyEmail(email, verificationCode);
    _eitherLoadedOrErrorState2(result);
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
      default:
        return 'Unexpected error';
    }
  }
}
