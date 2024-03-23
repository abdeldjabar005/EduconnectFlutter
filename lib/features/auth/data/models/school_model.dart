

import 'package:quotes/features/auth/domain/entities/school.dart';

class SchoolModel extends School {
  SchoolModel({
    required int id,
    required String name,
    required String address,
    String? image,
    required int adminId,
  }) : super(
          id: id,
          name: name,
          address: address,
          image: image,
          adminId: adminId,
        );

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      adminId: json['admin_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'image': image,
      'admin_id': adminId,
    };
  }
}
