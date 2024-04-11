part of 'class_cubit.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final ClassModel classe;

  ClassLoaded(this.classe);

  @override
  List<Object> get props => [classe];
}

class SchoolLoaded extends ClassState {
  final SchoolModel school;

  SchoolLoaded(this.school);

  @override
  List<Object> get props => [school];
}

class ClassError extends ClassState {
  final String message;

  ClassError(this.message);

  @override
  List<Object> get props => [message];
}

// class ClassJoined extends ClassState {
//   final ClassModel classModel;

//   ClassJoined(this.classModel);

//   @override
//   List<Object> get props => [classModel];
// }
