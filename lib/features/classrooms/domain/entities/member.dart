// classroom.dart
import 'package:equatable/equatable.dart';
import 'package:educonnect/features/profile/data/models/child2_model.dart';

class Member extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String image;
  final String? bio;
  final String? contact;
  final List<Child2Model> children;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.image,
    this.bio,
    this.contact,
    List<Child2Model>? children,
  }) : children = children ?? [];

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        role,
        image,
        children,
      ];
}
