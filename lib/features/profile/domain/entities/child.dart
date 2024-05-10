import 'package:equatable/equatable.dart';
import 'package:educonnect/features/classrooms/data/models/member_model.dart';

class Child extends Equatable {
  int? id;
  final String firstName;
  final String lastName;
  String? grade;
  String? relation;
  List<MemberModel> parents;
  Child({
    this.id,
    required this.firstName,
    required this.lastName,
    this.grade,
    this.relation,
    List<MemberModel>? parents,
  }) : parents = parents ?? [];

  @override
  List<Object?> get props => [id, firstName, lastName, grade, relation];
}
