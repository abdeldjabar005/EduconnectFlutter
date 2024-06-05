part of 'class_cubit.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassLoading2 extends ClassState {}

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

class SchoolVerifyRequested extends ClassState {
  final SchoolModel school;

  SchoolVerifyRequested(this.school);

  @override
  List<Object> get props => [school];
}

class ClassesLoaded extends ClassState {
  final List<ClassMemberModel> classes;

  ClassesLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

class TeacherClassesLoaded extends ClassState {
  final List<ClassModel> classes;

  TeacherClassesLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

class NoClasses extends ClassState {
  final String message;

  NoClasses(this.message);

  @override
  List<Object> get props => [message];
}

class SchoolRemoved extends ClassState {}

class LeftSuccess extends ClassState {}

class RequestSent extends ClassState {}

class StudentsLoaded extends ClassState {
  final List<ChildModel> students;

  StudentsLoaded(this.students);

  @override
  List<Object> get props => [students];
}

class CodesGenerated extends ClassState {
  final List<String> codes;

  CodesGenerated(this.codes);

  @override
  List<Object> get props => [codes];
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
