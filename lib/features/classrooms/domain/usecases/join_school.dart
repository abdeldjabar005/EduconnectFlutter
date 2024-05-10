// join_school.dart
import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';

class JoinSchool implements UseCase<SchoolModel, String> {
  final ClassroomRepository schoolRepository;

  JoinSchool({required this.schoolRepository});

  @override
  Future<Either<Failure, SchoolModel>> call(String code) {
    return schoolRepository.joinSchool(code);
  }
}
