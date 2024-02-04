import 'dart:convert';

class RegisterParams {
  final String username;
  final String password;
  final String email;
  final bool gender;
  final String fullName;
  final DateTime birthday;

  RegisterParams({
    required this.username,
    required this.password,
    required this.email,
    required this.gender,
    required this.fullName,
    required this.birthday,
  });

  RegisterParams copyWith({
    String? username,
    String? password,
    String? email,
    bool? gender,
    String? fullName,
    DateTime? birthday,
  }) {
    return RegisterParams(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'email': email,
      'gender': gender,
      'fullName': fullName,
      'birthday': birthday.toIso8601String(),
    };
  }

  factory RegisterParams.fromMap(Map<String, dynamic> map) {
    return RegisterParams(
      username: map['username'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      gender: map['gender'] as bool,
      fullName: map['fullName'] as String,
      birthday: DateTime.parse(map['birthday'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterParams.fromJson(String source) => RegisterParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RegisterDTO(username: $username, password: $password, email: $email, gender: $gender, fullName: $fullName, birthday: $birthday)';
  }

  @override
  bool operator ==(covariant RegisterParams other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.password == password &&
        other.email == email &&
        other.gender == gender &&
        other.fullName == fullName &&
        other.birthday == birthday;
  }

  @override
  int get hashCode {
    return username.hashCode ^ password.hashCode ^ email.hashCode ^ gender.hashCode ^ fullName.hashCode ^ birthday.hashCode;
  }
}
