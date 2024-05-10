
import 'package:educonnect/features/profile/domain/entities/child2.dart';

class Child2Model extends Child2 {
  Child2Model({
    required int id,
    required String firstName,
    required String lastName,
    required String relation,
    required String relationDisplay,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          relation: relation,
          relationDisplay: relationDisplay,
        );

  factory Child2Model.fromJson(Map<String, dynamic> json) {
    return Child2Model(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      relation: json['relation'],
      relationDisplay: json['relation_display'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'relation': relation,
      'relationDisplay': relationDisplay,
    };
  }
}