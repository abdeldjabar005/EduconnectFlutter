import 'package:quotes/features/classrooms/domain/entities/member.dart';

class MemberModel extends Member {
  MemberModel({
    required int id,
    required String firstName,
    required String lastName,
    required String role,
    required String image,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          role: role,
          image: image,
        );

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      image: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'image': image,
    };
  }
}
