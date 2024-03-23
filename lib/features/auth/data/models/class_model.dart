
import 'package:quotes/features/auth/domain/entities/class.dart';

class ClassModel extends Class {
  ClassModel({
    required int id,
    required String name,
    required int schoolId,
    required int teacherId,
    required int grade,
    required String subject,
  }) : super(
          id: id,
          name: name,
          schoolId: schoolId,
          teacherId: teacherId,
          grade: grade,
          subject: subject,
        );

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      schoolId: json['school_id'],
      teacherId: json['teacher_id'],
      grade: json['grade'],
      subject: json['subject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'school_id': schoolId,
      'teacher_id': teacherId,
      'grade': grade,
      'subject': subject,
    };
  }
}