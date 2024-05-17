part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}
// class AuthEmailVerification extends AuthState {
//   final User user;

//   const AuthEmailVerification({required this.user});

//   @override
//   List<Object> get props => [user];
// }
class AuthCodeEntry extends AuthState {
  final List<String> verificationCode;

  const AuthCodeEntry({required this.verificationCode});

  @override
  List<Object> get props => [verificationCode];
}

class AuthEmailVerificationNeeded extends AuthState {}

class AuthEmailVerified extends AuthState {}
class AuthCodeSent extends AuthState {}
class AuthPasswordReset extends AuthState {}
class AuthUnauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}