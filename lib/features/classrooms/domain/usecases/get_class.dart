// get_class.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

class GetPostsUseCase implements UseCase<List<PostModel>, Params3> {
  final ClassroomRepository classroomRepository;

  GetPostsUseCase({required this.classroomRepository});

  @override
  Future<Either<Failure, List<PostModel>>> call(Params3 params) {
    return classroomRepository.getPosts(params.id, params.page, params.type);
  }

  
}

class Params3 extends Equatable {
  final int id;
  final int page;
  final String type;
  const Params3({required this.id, required this.page, required this.type});

  @override
  List<Object> get props => [id, page, type];
}