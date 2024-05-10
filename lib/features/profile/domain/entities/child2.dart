import 'package:equatable/equatable.dart';

class Child2 extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String relation;
  final String relationDisplay;

  const Child2({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.relation,
    required this.relationDisplay,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        relation,
        relationDisplay,
      ];
}