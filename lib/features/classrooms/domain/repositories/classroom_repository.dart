// classroom_repository.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';

abstract class ClassroomRepository {

  Future<Either<Failure, List<PostModel>>> getPosts(int id, int page, String type);
  Future<Either<Failure, ClassModel>> joinClass(String code);
  Future<Either<Failure, SchoolModel>> joinSchool(String code);
}
