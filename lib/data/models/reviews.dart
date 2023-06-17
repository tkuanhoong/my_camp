class Review {
  final String uid;
  final String review;
  final double rating;
  final DateTime timestamp;
  final String imagePath;
  final String username;

  Review({
    required this.uid,
    required this.review,
    required this.rating,
    required this.timestamp,
    required this.imagePath,
    required this.username,
  });
}
