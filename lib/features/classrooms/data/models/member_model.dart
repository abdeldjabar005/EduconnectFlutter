import 'package:educonnect/features/classrooms/domain/entities/member.dart';
import 'package:educonnect/features/profile/data/models/child2_model.dart';

class MemberModel extends Member {
  MemberModel({
    required int id,
    required String firstName,
    required String lastName,
    required String role,
    required String image,
    String? bio,
    String? contact,
    List<Child2Model>? children,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          role: role,
          image: image,
          children: children,
          bio: bio,
          contact: contact,
        );

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      image: json['profile_picture'],
      children: json['children'] != null
          ? List<Child2Model>.from(
              json['children'].map((x) => Child2Model.fromJson(x)))
          : null,
      bio: json['bio'],
      contact: json['contact'],
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
