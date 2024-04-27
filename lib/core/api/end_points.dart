class EndPoints {
  // static const String baseUrl = 'http://10.0.2.2:8000/api/';
  // static const String storage = 'http://10.0.2.2:8000/storage/';

  static const String baseUrl = 'http://localhost:8000/api/';
  static const String storage = 'http://localhost:8000/storage/';

  static const String randomQuote = '${baseUrl}quotes/random';
  static const String login = '${baseUrl}login';
  static const String signUp = '${baseUrl}register';
  static const String posts = '${baseUrl}posts/class/16';
  static String post(int id) => '${baseUrl}posts/$id';

  static const String resendEmail = '${baseUrl}resendotp';
  static const String users = '${baseUrl}users';
  static const String verifyEmail = '${baseUrl}verify';

  static String comments(int postId) => '${baseUrl}posts/$postId/all-comments';
  static String comment(int id) => '${baseUrl}posts/$id/comment';
  static String postComment(int postId) => '${baseUrl}posts/$postId/comments';
  static String postReply(int id) => '${baseUrl}posts/$id/replies';
  static String likePost(int postId) => '${baseUrl}posts/$postId/likes';
  static String likeComment(int id) => '${baseUrl}posts/$id/like';
  static String likeReply(int id) => '${baseUrl}posts/replies/$id/like';
  static String checkIfPostIsLiked(int postId) =>
      '${baseUrl}posts/$postId/isliked';

  static const String joinSchool = '${baseUrl}school-join-requests/join-school';
  static const String joinClass = '${baseUrl}join-requests/class/join';
  static String getClass(int id) => '${baseUrl}posts/class/$id';
  static String getSchool(int id) => '${baseUrl}posts/school/$id';
  static String getMembers(int id) => '${baseUrl}schools/$id/members';
  static String getClassMembers(int id) => '${baseUrl}classes/$id/members';
  static String getClasses(int id) => '${baseUrl}schools/$id/classes';
  static String removeClass(int? id) => '${baseUrl}classes/$id';
  static String updateClass(int? id) => '${baseUrl}classes/$id';
  static String removeSchool(int? id) => '${baseUrl}schools/$id';
  static String updateSchool(int? id) => '${baseUrl}schools/$id';
  static const String getTeacherClasses = '${baseUrl}classes/owned';
  static const String getChildren = '${baseUrl}students/children/parent';
  static const String addChild = '${baseUrl}students';
  static const String addClass = '${baseUrl}classes';
  static const String addSchool = '${baseUrl}schools';
  static String removeChild(int? id) => '${baseUrl}students/$id';
  static String updateChild(int? id) => '${baseUrl}students/$id';

  static String schoolVerifyRequest(int? id ) => '${baseUrl}schools/$id/request/verification';
}
