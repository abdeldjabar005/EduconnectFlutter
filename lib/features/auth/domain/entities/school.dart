
import 'package:equatable/equatable.dart';

class School extends Equatable {
  final int id;
  final String name;
  final String address;
  final String? image;
  final int adminId;

  School({
    required this.id,
    required this.name,
    required this.address,
    this.image,
    required this.adminId,
  });

 @override
  List<Object?> get props => [id, name, address, image, adminId];
}
