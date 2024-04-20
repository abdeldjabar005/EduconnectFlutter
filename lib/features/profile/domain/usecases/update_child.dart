import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/domain/repositories/profile_repository.dart';

class UpdateChildUseCase implements UseCase<void, ChildModel> {
  final ProfileRepository profileRepository;

  UpdateChildUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(ChildModel params) {
    return profileRepository.updateChild(params);
  }
}
