

import 'package:educonnect/features/chat/domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    String? profilePicture,
    required bool activeStatus,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePicture: profilePicture,
          activeStatus: activeStatus,
        );

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      activeStatus: json['active_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_picture': profilePicture,
      'active_status': activeStatus,
    };
  }
}