import 'package:educonnect/features/classrooms/domain/entities/request.dart';

class RequestModel extends Request {
  RequestModel({
    required int id,
    required String name,
    required String firstName,
    required String lastName,
    required String profilePicture,
  }) : super(
          id: id,
          name: name,
          firstName: firstName,
          lastName: lastName,
          profilePicture: profilePicture,
        );

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      name: json['class_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
    };
  }
}
