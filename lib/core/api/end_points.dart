class EndPoints {
  // static const String baseUrl = 'http://10.0.2.2:8000/api/';
  // static const String storage = 'http://10.0.2.2:8000/storage/';

  static const String baseUrl = 'http://localhost:8000/api/';
  static const String storage = 'http://localhost:8000/storage/';

  static const String chatifyUrl = 'http://127.0.0.1:8000/chatify/api/';

  static const String updateProfile = '${baseUrl}user';
  static const String auth = '${chatifyUrl}chat/auth';

  static const String randomQuote = '${baseUrl}quotes/random';
  static const String login = '${baseUrl}login';
  static const String signUp = '${baseUrl}register';
  static const String changePassword = '${baseUrl}change-password';
  // static const String posts = '${baseUrl}posts/class/16';
  static const String posts = '${baseUrl}posts/user/posts';
  static const String schoolPosts = '${baseUrl}posts/user/schools';
  static const String classPosts = '${baseUrl}posts/user/classes';
  static const String bookmarkPosts = '${baseUrl}posts/saved-posts';

  static String post(int id) => '${baseUrl}posts/$id';

  static String search(String query) =>
      '${baseUrl}schools/search?search=$query';

  static const String resendEmail = '${baseUrl}resendotp';
  static const String users = '${baseUrl}users';
  static const String verifyEmail = '${baseUrl}verify';

  static const String forgotPassword = '${baseUrl}forgot-password';
  static const String validateOtp = '${baseUrl}validate-otp';
  static const String resetPassword = '${baseUrl}reset-password';

  static const String getContacts = '${chatifyUrl}getContacts';
  static const String getMessages = '${chatifyUrl}fetchMessages';
  static const String sendMessage = '${chatifyUrl}sendMessage';

  static const String newPost = '${baseUrl}posts';
  static String removePost(int id) => '${baseUrl}posts/$id';
  static String removeComment(int id, int postId) =>
      '${baseUrl}posts/$postId/comments/$id';
  static String removeReply(int id) => '${baseUrl}posts/replies/$id';
  static String voteOnPoll(int postId) => '${baseUrl}posts/vote/$postId';

  static String removeMember1(int id, int id2) => '${baseUrl}schools/$id/members/$id2';
  static String removeMember2(int id, int id2) => '${baseUrl}classes/$id/members/$id2';

  static String comments(int postId) => '${baseUrl}posts/$postId/all-comments';
  static String comment(int id) => '${baseUrl}posts/$id/comment';
  static String postComment(int postId) => '${baseUrl}posts/$postId/comments';
  static String postReply(int id) => '${baseUrl}posts/$id/replies';
  static String likePost(int postId) => '${baseUrl}posts/$postId/likes';
  static String likeComment(int id) => '${baseUrl}posts/$id/like';
  static String likeReply(int id) => '${baseUrl}posts/replies/$id/like';
  static String checkIfPostIsLiked(int postId) =>
      '${baseUrl}posts/$postId/isliked';

  static String savePost(int postId) => '${baseUrl}posts/$postId/toggle-save';

  static const String joinSchool = '${baseUrl}school-join-requests/join-school';
  static const String joinSchoolRequest = '${baseUrl}school-join-requests';
  static const String joinClass = '${baseUrl}join-requests/class/join';
  static const String sendJoinRequest = '${baseUrl}join-requests';
  static String getClass(int id) => '${baseUrl}posts/class/$id';
  static String getSchool(int id) => '${baseUrl}posts/school/$id';
  static String getMembers(int id) => '${baseUrl}schools/$id/members';
  static String getStudents(int id) => '${baseUrl}schools/$id/students';
  static String getClassStudents(int id) => '${baseUrl}classes/$id/students';
  static String associateStudent(int id) => '${baseUrl}schools/$id/associate';
  static String associateStudent2(int id) => '${baseUrl}classes/$id/associate';

  static String acceptSchool(int id) =>
      '${baseUrl}school-join-requests/$id/approve';
  static String acceptClass(int id) => '${baseUrl}join-requests/$id/approve';
  static String refuseSchool(int id) =>
      '${baseUrl}school-join-requests/$id/reject';
  static String refuseClass(int id) => '${baseUrl}join-requests/$id/reject';

  static String getClassMembers(int id) => '${baseUrl}classes/$id/members';

  static String getClasses(int id) => '${baseUrl}schools/$id/classes';
  static String removeClass(int? id) => '${baseUrl}classes/$id';
  static String updateClass(int? id) => '${baseUrl}classes/$id';
  static String removeSchool(int? id) => '${baseUrl}schools/$id';
  static String updateSchool(int? id) => '${baseUrl}schools/$id';
  static String leaveSchool(int id) => '${baseUrl}schools/$id/leave';
  static String leaveClass(int id) => '${baseUrl}classes/$id/leave';
  static const String getTeacherClasses = '${baseUrl}classes/owned';
  static const String getChildren = '${baseUrl}students/children/parent';
  static const String addChild = '${baseUrl}students';
  static const String addClass = '${baseUrl}classes';
  static const String addSchool = '${baseUrl}schools';
  static String removeChild(int? id) => '${baseUrl}students/$id';
  static String updateChild(int? id) => '${baseUrl}students/$id';

  static String schoolVerifyRequest(int? id) =>
      '${baseUrl}schools/$id/request/verification';

  static String getSchoolRequests(int id) =>
      '${baseUrl}school-join-requests/$id';
  static String getClassRequests(int id) => '${baseUrl}join-requests/$id';

  static String generateCodes(String type, int id) =>
      '$baseUrl$type/$id/generate-code';
}
