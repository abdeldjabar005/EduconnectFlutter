import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';

class UpdateChildUseCase implements UseCase<void, ChildModel> {
  final ProfileRepository profileRepository;

  UpdateChildUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(ChildModel params) {
    return profileRepository.updateChild(params);
  }
}
