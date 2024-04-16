import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/profile/data/models/child_model.dart';
import 'package:quotes/features/profile/domain/repositories/profile_repository.dart';

class AddChildUseCase extends UseCase<void, ChildModel> {
  final ProfileRepository profileRepository;

  AddChildUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(ChildModel params) {
    return profileRepository.addChild(params);
  }
}
