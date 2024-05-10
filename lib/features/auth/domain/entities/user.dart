import 'package:equatable/equatable.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';

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
   List<SchoolModel> schools;
   List<ClassModel> classes;
   List<ClassModel>? teacherClasses;
   SchoolModel? school;
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
   this.teacherClasses,
    this.school,

  });

 User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? isVerified,
    String? role,
    String? profilePicture,
    String? bio,
    String? contactInformation,
    List<SchoolModel>? schools,
    List<ClassModel>? classes,
    List<ClassModel>? teacherClasses,
    SchoolModel? school,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      contactInformation: contactInformation ?? this.contactInformation,
      schools: schools ?? this.schools,
      classes: classes ?? this.classes,
      teacherClasses: teacherClasses ?? this.teacherClasses,
      school: school ?? this.school,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, isVerified, role, profilePicture, bio, contactInformation, schools, classes, teacherClasses, school];
}