import 'package:equatable/equatable.dart';

class ClassM extends Equatable {
  final int? id;
  final String name;
  final int? schoolId;
  final int? teacherId;
  final String grade;
  final String subject;
  final String? code;
  final String? teacherFirstName;
  final String? teacherLastName;
  final int? membersCount;
  final String? image;

  const ClassM({
   this.id,
    required this.name,
    this.schoolId,
    this.teacherId,
    required this.grade,
    required this.subject,
    this.code,
    this.teacherFirstName,
    this.teacherLastName,
    this.membersCount,
    this.image,
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

  factory ClassM.fromJson(Map<String, dynamic> json) {
    return ClassM(
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
