// get_class.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/classrooms/data/models/member_model.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

class GetMembersUseCase implements UseCase<List<MemberModel>, Params4> {
  final ClassroomRepository classroomRepository;

  GetMembersUseCase({required this.classroomRepository});

  @override
  Future<Either<Failure, List<MemberModel>>> call(Params4 params) {
    return classroomRepository.getMembers(params.id, params.type);
  }

  
}

class Params4 extends Equatable {
  final int id;
  final String type;
  const Params4({required this.id, required this.type});
  @override
  List<Object> get props => [id, type];
}