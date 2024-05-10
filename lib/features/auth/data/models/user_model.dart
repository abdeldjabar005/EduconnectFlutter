import 'package:educonnect/features/auth/domain/entities/user.dart';
import 'package:educonnect/features/classrooms/data/models/class_model.dart';
import 'package:educonnect/features/classrooms/data/models/school_nodel.dart';

class UserModel extends User {
  final String token;

  UserModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required bool isVerified,
    required String role,
    String? profilePicture,
    String? bio,
    String? contactInformation,
    required List<SchoolModel> schools,
    required List<ClassModel> classes,
    required this.token,
    List<ClassModel>? teacherClasses,
    SchoolModel? school,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          isVerified: isVerified,
          role: role,
          profilePicture: profilePicture,
          bio: bio,
          contactInformation: contactInformation,
          schools: schools,
          classes: classes,
          teacherClasses: teacherClasses,
          school: school,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return UserModel(
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

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      isVerified: isVerified,
      role: role,
      profilePicture: profilePicture,
      bio: bio,
      contactInformation: contactInformation,
      schools: schools,
      classes: classes,
      teacherClasses: teacherClasses,
      school: school,
    );
  }
}
