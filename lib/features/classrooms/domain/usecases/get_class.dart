// get_class.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/data/models/post_result.dart';

class GetPostsUseCase implements UseCase<PostsResult, Params3> {
  final ClassroomRepository classroomRepository;

  GetPostsUseCase({required this.classroomRepository});

  @override
  Future<Either<Failure, PostsResult>> call(Params3 params) {
    return classroomRepository.getPosts(params.id, params.page, params.type);
  }
}

class Params3 extends Equatable {
  final int id;
  final int page;
  final String? type;
  const Params3({required this.id, required this.page, required this.type});

  @override
  List<Object> get props => [id, page];
}