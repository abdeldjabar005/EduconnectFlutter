import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class PostReply extends UseCase<void, Params2> {
  final PostRepository repository;

  PostReply(this.repository);

  @override
  Future<Either<Failure, void>> call(Params2 params) {
    return repository.postReply(params.id, params.reply);
  }
}

class Params2 extends Equatable {
  final int id;
  final String reply;

  const Params2({required this.id, required this.reply});

  @override
  List<Object> get props => [id, reply];
}