import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String email;
  String token;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyId = 'id';
  static const _keyName = 'name';
  static const _keyEmail = 'email';
  static const _keyToken = 'token';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_keyId, user.id);
    await instance.setString(_keyName, user.name);
    await instance.setString(_keyEmail, user.email);
    await instance.setString(_keyToken, user.token);
  }

  static User getUser() {
    final id = _preferences.getString(_keyId);
    final name = _preferences.getString(_keyName);
    final email = _preferences.getString(_keyEmail);
    final token = _preferences.getString(_keyToken);

    return User(id: id!, name: name!, email: email!, token: token!);
  }
}
