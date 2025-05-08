class UserModel {
  final String id;
  final String name;
  final String email;
  final String? fcmToken;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.fcmToken,
    this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? 'No Name',
      email: map['email'] ?? 'No Email',
      fcmToken: map['fcmToken'],
      profileImage: map['profileImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}
