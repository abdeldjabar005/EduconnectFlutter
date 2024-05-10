import 'package:equatable/equatable.dart';

class Request extends Equatable {
  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final String profilePicture;

  Request({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  @override
  List<Object> get props => [id, name, firstName, lastName, profilePicture];
}
