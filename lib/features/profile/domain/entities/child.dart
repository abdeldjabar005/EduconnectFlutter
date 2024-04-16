import 'package:equatable/equatable.dart';

class Child extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String grade;
  final String? relation;

  const Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.relation,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, grade, relation];
}
