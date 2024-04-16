// classroom.dart
import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String image;

  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        role,
        image,
      ];
}
