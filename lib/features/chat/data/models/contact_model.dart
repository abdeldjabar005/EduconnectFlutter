import 'package:educonnect/features/chat/domain/entities/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    String? profilePicture,
    required bool activeStatus,
    required String? lastMessage,
    required DateTime? updatedAt,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePicture: profilePicture,
          activeStatus: activeStatus,
          lastMessage: lastMessage,
          updatedAt: updatedAt,
        );

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      activeStatus: json['active_status'],
      lastMessage: json['last_message'],
      updatedAt: DateTime.parse(json['last_message_updated_at']),
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
      'last_message': lastMessage,
      'updated_at': updatedAt?.toIso8601String() ,
    };
  }
}
