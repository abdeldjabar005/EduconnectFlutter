import 'package:quotes/features/classrooms/data/models/class_model.dart';

class ClassMemberModel {
  final ClassModel classModel;
  final bool isMember;

  ClassMemberModel({required this.classModel, required this.isMember});

  factory ClassMemberModel.fromJson(Map<String, dynamic> json) {
    return ClassMemberModel(
      classModel: ClassModel.fromJson(json['class']),
      isMember: json['is_member'],
    );
  }
}