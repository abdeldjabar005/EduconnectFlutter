import 'package:equatable/equatable.dart';
import 'package:quotes/features/classrooms/data/models/class_model.dart';
import 'package:quotes/features/classrooms/data/models/school_nodel.dart';

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
  final List<SchoolModel> schools;
  final List<ClassModel> classes;

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