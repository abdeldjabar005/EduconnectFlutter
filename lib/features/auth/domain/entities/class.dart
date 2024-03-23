import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final int id;
  final String name;
  final int schoolId;
  final int teacherId;
  final int grade;
  final String subject;

  Class({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.teacherId,
    required this.grade,
    required this.subject,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        schoolId,
        teacherId,
        grade,
        subject,
      ];
}
