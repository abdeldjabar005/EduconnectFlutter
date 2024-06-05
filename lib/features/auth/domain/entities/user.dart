import 'package:educonnect/features/profile/data/models/profile_model.dart';
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
  String? token;
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
    this.token,
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

  factory User.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return User(
      id: data['id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      isVerified: data['is_verified'],
      role: data['role'],
      profilePicture: data['profile_picture'],
      bio: data['bio'],
      contactInformation: data['contact_information'],
      schools: (data['schools'] as List)
          .map((i) => SchoolModel.fromJson(i))
          .toList(),
      classes:
          (data['classes'] as List).map((i) => ClassModel.fromJson(i)).toList(),
      teacherClasses: data['owned_classes'] != null
          ? (data['owned_classes'] as List)
              .map((i) => ClassModel.fromJson(i))
              .toList()
          : [],
      school: data['owned_school'] != null
          ? SchoolModel.fromJson(data['owned_school'])
          : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'is_verified': isVerified,
      'role': role,
      'profile_picture': profilePicture,
      'bio': bio,
      'contact_information': contactInformation,
      'schools': schools.map((i) => (i as SchoolModel).toJson()).toList(),
      'classes': classes.map((i) => (i as ClassModel).toJson()).toList(),
      'token': token,
    };
  }

  ProfileModel toProfileModel() {
    return ProfileModel(
      firstName: firstName,
      lastName: lastName,
      bio: bio ?? '',
      contactInformation: contactInformation ?? '',
      // imageUrl: profilePicture ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        isVerified,
        role,
        profilePicture,
        bio,
        contactInformation,
        schools,
        classes,
        teacherClasses,
        school
      ];
}
