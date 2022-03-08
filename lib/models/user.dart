class User {
  final String id;
  final String displayName;
  final String messageText;
  final String imageURL;
  final String time;
  
  User({required this.id, required this.displayName, required this.messageText, required this.imageURL, required this.time});

  User.fromJson(String id, Map<String, dynamic> json) : this(
    id: id,
    displayName: json["display_name"],
    messageText: json["message_text"],
    imageURL: json["image_url"],
    time: json["time"]
  );

  Map<String, Object?> toJson(){
    return {
      "display_name" : displayName,
      "message_text" : messageText,
      "image_url" : imageURL,
      "time" : time
    };
  }
}