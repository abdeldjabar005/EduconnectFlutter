// classroom.dart
import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final int id;
  final String name;
  final int? schoolId;
  final int teacherId;
  final int grade;
  final String subject;
  final String code;
  final String teacherFirstName;
  final String teacherLastName;
  final int membersCount;
  final String image;

  const Class({
    required this.id,
    required this.name,
    this.schoolId,
    required this.teacherId,
    required this.grade,
    required this.subject,
    required this.code,
    required this.teacherFirstName,
    required this.teacherLastName,
    required this.membersCount,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        schoolId,
        teacherId,
        grade,
        subject,
        code,
        teacherFirstName,
        teacherLastName,
        membersCount,
        image,
      ];
}
