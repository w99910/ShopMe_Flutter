import 'dart:convert';

class User {
  int id;
  String name;
  String email;
  String password;
  String role;
  String profile;
  String stripeid;
  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.role,
      this.profile,
      this.stripeid});
  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      name: json['name'],
      password: json['password'] ?? "",
      email: json['email'],
      role: json['role'],
      profile: json['profile_url'],
      stripeid: json['stripe_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "password": this.password ?? "",
      "email": this.email,
      "role": this.role,
      "profile": this.profile,
      "stripeid": this.stripeid,
    };
  }
}
