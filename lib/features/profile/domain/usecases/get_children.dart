import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';

class GetChildren implements UseCase<List<ChildModel>, String> {
  final ProfileRepository profileRepository;

  GetChildren({required this.profileRepository});

  @override
  Future<Either<Failure, List<ChildModel>>> call(String code) {
    return profileRepository.getChildren();
  }
}
