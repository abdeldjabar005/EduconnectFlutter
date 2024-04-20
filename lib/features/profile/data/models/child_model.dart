import 'package:quotes/features/profile/domain/entities/child.dart';

class ChildModel extends Child {
  ChildModel({
   int? id,
    required String firstName,
    required String lastName,
    required String grade,
     required String relation,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          grade: grade,
          relation: relation,
        );

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      grade: json['grade_level'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'grade_level': grade,
      'relation': relation
    };
  }
}
