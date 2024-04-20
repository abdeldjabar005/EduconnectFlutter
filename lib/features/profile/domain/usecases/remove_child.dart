import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/profile/domain/repositories/profile_repository.dart';

class RemoveChild extends UseCase<void, int?> {
  final ProfileRepository repository;

  RemoveChild({required this.repository});

  @override
  Future<Either<Failure, void>> call(int? params) async {
    return await repository.removeChild(params);
  }
}
