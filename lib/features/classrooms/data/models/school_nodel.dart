import 'package:quotes/features/classrooms/domain/entities/school.dart';

class SchoolModel extends School {
  const SchoolModel({
    required int id,
    required String name,
    required String address,
    required String image,
    required int adminId,
    required String adminFirstName,
    required String adminLastName,
    required String? code,
    required int membersCount,
    required bool isVerified,
    required bool verificationRequest,
  }) : super(
          id: id,
          name: name,
          address: address,
          image: image,
          adminId: adminId,
          adminFirstName: adminFirstName,
          adminLastName: adminLastName,
          code: code,
          membersCount: membersCount,
          isVerified: isVerified,
          verificationRequest: verificationRequest,
        );

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      adminId: json['admin_id'],
      adminFirstName: json['admin_first_name'],
      adminLastName: json['admin_last_name'],
      code: json['code'],
      membersCount: json['members_count'],
      isVerified: json['is_verified'],
      verificationRequest: json['verification_request_sent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'image': image,
      'admin_id': adminId,
      'admin_first_name': adminFirstName,
      'admin_last_name': adminLastName,
      'code': code,
      'members_count': membersCount,
      'is_verified': isVerified,
      'verification_request_sent': verificationRequest,
    };
  }
}
