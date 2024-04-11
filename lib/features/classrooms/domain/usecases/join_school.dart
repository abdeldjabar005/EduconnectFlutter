// join_school.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';

class JoinSchool implements UseCase<SchoolModel, String> {
  final ClassroomRepository schoolRepository;

  JoinSchool({required this.schoolRepository});

  @override
  Future<Either<Failure, SchoolModel>> call(String code) {
    return schoolRepository.joinSchool(code);
  }
}
