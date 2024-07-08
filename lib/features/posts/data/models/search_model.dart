import 'package:educonnect/features/classrooms/domain/entities/school.dart';
class SearchModel extends School {
  final int isMember;

  SearchModel({
    required int id,
    required String name,
    required String address,
    required String image,
    required bool isVerified,
    required bool verificationRequest,
    required int adminId,
    required String adminFirstName,
    required String adminLastName,
    required int membersCount,
    required this.isMember,
  }) : super(
          id: id,
          name: name,
          address: address,
          image: image,
          isVerified: isVerified,
          verificationRequest: verificationRequest,
          adminId: adminId,
          adminFirstName: adminFirstName,
          adminLastName: adminLastName,
          membersCount: membersCount,
        );

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      isVerified: json['is_verified'],
      verificationRequest: json['verification_request_sent'],
      adminId: json['admin_id'],
      adminFirstName: json['admin_first_name'],
      adminLastName: json['admin_last_name'],
      membersCount: json['members_count'],
      isMember: json['is_member'],
    );
  }

  SearchModel copyWith({
    int? id,
    String? name,
    String? address,
    String? image,
    bool? isVerified,
    bool? verificationRequest,
    int? adminId,
    String? adminFirstName,
    String? adminLastName,
    int? membersCount,
    int? isMember,
  }) {
    return SearchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      image: image ?? this.image,
      isVerified: isVerified ?? this.isVerified,
      verificationRequest: verificationRequest ?? this.verificationRequest,
      adminId: adminId ?? this.adminId,
      adminFirstName: adminFirstName ?? this.adminFirstName,
      adminLastName: adminLastName ?? this.adminLastName,
      membersCount: membersCount ?? this.membersCount,
      isMember: isMember ?? this.isMember,
    );
  }
}