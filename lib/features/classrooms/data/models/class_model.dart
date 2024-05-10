import 'package:educonnect/features/classrooms/domain/entities/class.dart';

class ClassModel extends Class {
   ClassModel({
     required int id,
    required String name,
    int? schoolId,
     int? teacherId,
    required String grade,
    required String subject,
     String? code,
     String? teacherFirstName,
     String? teacherLastName,
     int? membersCount,
     String? image,
  }) : super(
          id: id,
          name: name,
          schoolId: schoolId,
          teacherId: teacherId,
          grade: grade,
          subject: subject,
          code: code,
          teacherFirstName: teacherFirstName,
          teacherLastName: teacherLastName,
          membersCount: membersCount,
          image: image,
        );

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      schoolId: json['school_id'],
      teacherId: json['teacher_id'],
      grade: json['grade'],
      subject: json['subject'],
      code: json['code'],
      teacherFirstName: json['teacher_first_name'],
      teacherLastName: json['teacher_last_name'],
      membersCount: json['members_count'],
      image: json['image'],
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
      'code': code,
      'teacher_first_name': teacherFirstName,
      'teacher_last_name': teacherLastName,
      'members_count': membersCount,
      'image': image,
    };
  }
}
