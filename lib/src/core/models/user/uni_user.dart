class UniUserModel {
  /// [userId] is the unique identifier of the peer.
  late String userId;

  /// [fullName] is the full name of the peer.
  late String fullName;

  /// [imageUrl] is the image url of the peer.
  late String imageUrl;

  /// [fcmToken] is the firebase cloud messaging token of the peer to send the notification.
  late String fcmToken;

  /// [customData] is the custom data of the peer.
  late Map<String, dynamic> customData;

  /// [UniUserModel] is the model class for the user of chat room
  UniUserModel({
    required this.userId,
    required this.fullName,
    this.imageUrl = "",
    this.fcmToken = "",
    this.customData = const {},
  });

  /// [UniUserModel.fromJson] is the fromJson constructor for the UniUserModel
  factory UniUserModel.fromJson(Map<String, dynamic> json) {
    return UniUserModel(
      userId: json['userId'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'] ?? "",
      fcmToken: json['fcmToken'] ?? "",
      customData: json['customData'] ?? {},
    );
  }

  /// [UniUserModel.toJson] is the toJson method for the UniUserModel
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'fcmToken': fcmToken,
      'customData': customData,
    };
  }
}
