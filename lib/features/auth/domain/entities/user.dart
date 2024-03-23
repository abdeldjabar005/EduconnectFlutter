import 'package:equatable/equatable.dart';
import 'package:quotes/features/auth/domain/entities/class.dart';
import 'package:quotes/features/auth/domain/entities/school.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isVerified;
  final String role;
  final String? profilePicture;
  final String? bio;
  final String? contactInformation;
  final List<School> schools;
  final List<Class> classes;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isVerified,
    required this.role,
    this.profilePicture,
    this.bio,
    this.contactInformation,
    required this.schools,
    required this.classes,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, isVerified, role, profilePicture, bio, contactInformation, schools, classes];
}