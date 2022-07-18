import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  bool? isAdmin;
  bool? isOwner;
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.isAdmin,
    this.isOwner,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? isAdmin,
    bool? isOwner,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'isAdmin': isAdmin,
      'isOwner': isOwner,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: int.parse(map['user_id']),
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      isAdmin: map['isAdmin'] == '1' ? true : false,
      isOwner: map['isOwner'] == '1' ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, password: $password, isAdmin: $isAdmin, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.isAdmin == isAdmin &&
        other.isOwner == isOwner;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        isAdmin.hashCode ^
        isOwner.hashCode;
  }
}
