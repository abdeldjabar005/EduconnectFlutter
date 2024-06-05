class ProfileModel {
  String firstName;
  String lastName;
  String bio;
  String contactInformation;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.contactInformation,
  });
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'contact_information': contactInformation,
    };
  }
}
