import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/domain/repositories/profile_repository.dart';

class AddChildUseCase implements UseCase<ChildModel, ChildModel> {
  final ProfileRepository profileRepository;

  AddChildUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, ChildModel>> call(ChildModel params) {
    return profileRepository.addChild(params);
  }
}
