import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/domain/repositories/profile_repository.dart';

class GetChildren implements UseCase<List<ChildModel>, String> {
  final ProfileRepository profileRepository;

  GetChildren({required this.profileRepository});

  @override
  Future<Either<Failure, List<ChildModel>>> call(String code) {
    return profileRepository.getChildren();
  }
}
