class LikePostResponse {
  final String postId;
  final bool isLiked;

  LikePostResponse({required this.postId, required this.isLiked});

  factory LikePostResponse.fromJson(Map<String, dynamic> json) {
    return LikePostResponse(
      postId: json['postId'],
      isLiked: json['isLiked'],
    );
  }
}