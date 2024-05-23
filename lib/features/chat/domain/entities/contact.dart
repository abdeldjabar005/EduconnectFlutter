import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;
  final bool activeStatus;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
    required this.activeStatus,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, profilePicture, activeStatus];
}