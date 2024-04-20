import 'package:equatable/equatable.dart';

class SchoolM extends Equatable {
  final int? id;
  final String name;
  final String address;
  final String? image;
  final int? adminId;
  final String? adminFirstName;
  final String? adminLastName;
  final String? code;
  final int? membersCount;

  const SchoolM({
     this.id,
    required this.name,
    required this.address,
     this.image,
     this.adminId,
     this.adminFirstName,
     this.adminLastName,
     this.code,
     this.membersCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        image,
        adminId,
        adminFirstName,
        adminLastName,
        code,
        membersCount,
      ];

  factory SchoolM.fromJson(Map<String, dynamic> json) {
    return SchoolM(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      adminId: json['admin_id'],
      adminFirstName: json['admin_first_name'],
      adminLastName: json['admin_last_name'],
      code: json['code'],
      membersCount: json['members_count'],
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
    };
  }
}
