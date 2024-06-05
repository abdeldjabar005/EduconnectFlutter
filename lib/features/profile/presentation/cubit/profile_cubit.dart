import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/classrooms/domain/entities/class.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final AuthCubit authCubit;

  ProfileCubit({required this.profileRepository, required this.authCubit})
      : super(ProfileInitial());

  Future<void> updateProfile(ProfileModel userToUpdate, File? image) async {
    try {
      emit(ProfileLoading());
      final result = await profileRepository.updateProfile(userToUpdate, image);
      result.fold(
        (failure) {
          emit(ProfileError(_mapFailureToMessage(failure)));
        },
        (user) async {
          authCubit.updateUserInformation(
            firstName: userToUpdate.firstName,
            lastName: userToUpdate.lastName,
            bio: userToUpdate.bio,
            contactInformation: userToUpdate.contactInformation,
            // profilepicture: user.profilePicture,
          );
          emit(ProfileUpdated(userToUpdate));
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> changePassword(
      String oldpassword, String password, String confirmPassword) async {
    try {
      emit(ProfileLoading());
      final result = await profileRepository.changePassword(
          oldpassword, password, confirmPassword);
      result.fold(
        (failure) {
          if (failure is OldPasswordWrongException) {
            emit(ProfileError(_mapFailureToMessage(OldPasswordWrongFailure())));
          } else {
            emit(ProfileError(_mapFailureToMessage(failure)));
          }
        },
        (right) {
          emit(ProfilePasswordUpdated());
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case OldPasswordWrongFailure:
        return 'Old password is wrong';
      default:
        return 'Unexpected error';
    }
  }
}
