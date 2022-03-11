class ChatUser {
  ChatUser({
    required this.id,
    required this.displayName,
    required this.email,
    required this.rating,
  });

  factory ChatUser.fromMap(Map<String, dynamic>? data) {
    return ChatUser(
        id: data!['id'], 
        displayName: data!['name'], 
        email: data!['email'],
        rating: data!['rating'] * 1.0
      );
  }

  final String id;
  final String displayName;
  final String email;
  double rating;

  void setRating(rating) {
    this.rating = rating;
  }
}
