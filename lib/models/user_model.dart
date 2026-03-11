class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.token,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String token;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'token': token,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final accessToken = (json['accessToken'] ?? json['token'] ?? '').toString();

    return UserModel(
      id: json['id'] is int ? json['id'] as int : 0,
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      token: accessToken,
    );
  }
}
