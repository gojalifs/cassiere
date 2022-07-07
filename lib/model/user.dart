import 'dart:convert';

class User {
  int id;
  String name;
  String email;
  String phone;
  String password;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode;
  }
}
