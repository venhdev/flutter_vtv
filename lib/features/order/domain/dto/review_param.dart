// ignore_for_file: public_member_api_docs, sort_constructors_first

class ReviewParam {
  String content;
  int rating;
  final String orderItemId;
  String? imagePath;
  bool hasImage;

  // review exist
  String? reviewId;

  ReviewParam({
    required this.content,
    required this.rating,
    required this.orderItemId,
    required this.imagePath,
    required this.hasImage,
    // review exist
    this.reviewId,
  });

  @override
  String toString() {
    return 'ReviewParam(content: $content, rating: $rating, orderItemId: $orderItemId, imagePath: $imagePath, hasImage: $hasImage, reviewId: $reviewId)';
  }
}
