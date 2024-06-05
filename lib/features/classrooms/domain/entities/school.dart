// school.dart
import 'package:equatable/equatable.dart';

class School extends Equatable {
  final int id;
  final String name;
  final String address;
  final String image;
  final int adminId;
  final String adminFirstName;
  final String adminLastName;
  final int membersCount;
  final bool isVerified;
  final bool verificationRequest;

  const School({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.adminId,
    required this.adminFirstName,
    required this.adminLastName,
    required this.membersCount,
    required this.isVerified,
    required this.verificationRequest,
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
        membersCount,
        isVerified,
        verificationRequest
      ];
}
