// join_class.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';

class JoinClass implements UseCase<ClassModel, String> {
  final ClassroomRepository classroomRepository;

  JoinClass({required this.classroomRepository});

  @override
  Future<Either<Failure, ClassModel>> call(String code) {
    return classroomRepository.joinClass(code);
  }
}
