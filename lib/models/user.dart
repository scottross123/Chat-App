class ChatUser {
  ChatUser({
    required this.id,
    required this.displayName,
    required this.email,
  });

  factory ChatUser.fromMap(Map<String, dynamic>? data) {
    return ChatUser(
        id: data!['id'], 
        displayName: data!['name'], 
        email: data!['email']);
  }

  final String id;
  final String displayName;
  final String email;
}
