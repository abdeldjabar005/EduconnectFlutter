import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<ChildModel>>> getChildren();
  Future<Either<Failure, ChildModel>> addChild(ChildModel child);
  Future<Either<Failure, void>> removeChild(int? id);
  Future<Either<Failure, void>> updateChild(ChildModel child);
  Future<Either<Failure, void>> updateProfile(ProfileModel user, File? image);
  Future<Either<Failure, void>> changePassword(
      String oldpassword, String password, String confirmPassword);
}
