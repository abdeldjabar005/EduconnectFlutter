import 'package:educonnect/features/classrooms/data/models/member_model.dart';
import 'package:educonnect/features/profile/domain/entities/child.dart';

class ChildModel extends Child {
  ChildModel({
    int? id,
    required String firstName,
    required String lastName,
     String? grade,
     String? relation,
    List<MemberModel> parents = const [],
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          grade: grade,
          relation: relation,
          parents: parents,
        );

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      grade: json['grade_level'],
      relation: json['relation'],
      parents: json['parents'] != null
          ? List<MemberModel>.from(
              json['parents'].map((x) => MemberModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'grade_level': grade,
      'relation': relation,
      'parents': parents.map((e) => e.toJson()).toList(),
    };
  }
}
