import 'dart:convert';

class UserModel {
  final String email;
  final String username;
  final String typeUser;
  UserModel({
    required this.email,
    required this.username,
    required this.typeUser,
  });

  UserModel copyWith({
    String? email,
    String? username,
    String? typeUser,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      typeUser: typeUser ?? this.typeUser,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'username': username});
    result.addAll({'typeuser': typeUser});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      typeUser: map['typeuser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(email: $email, username: $username, typeuser: $typeUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.username == username &&
        other.typeUser == typeUser;
  }

  @override
  int get hashCode => email.hashCode ^ username.hashCode ^ typeUser.hashCode;
}
