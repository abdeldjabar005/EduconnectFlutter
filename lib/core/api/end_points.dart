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
}
