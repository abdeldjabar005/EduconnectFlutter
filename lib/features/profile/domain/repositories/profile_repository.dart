

import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';

abstract class ProfileRepository {

  Future<Either<Failure, List<ChildModel>>> getChildren();
  Future<Either<Failure, ChildModel>> addChild(ChildModel child);
  Future<Either<Failure, void>> removeChild(int? id);
  Future<Either<Failure, void>> updateChild(ChildModel child);
}