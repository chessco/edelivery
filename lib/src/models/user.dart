import 'package:edelivery/src/api/my_api.dart';
import 'package:meta/meta.dart';

class User {
  final String id, username, email, avatar;
  final DateTime createdAt, updatedAt;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.createdAt,
    this.avatar,
    @required this.updatedAt,
  });

  User setAvatar(String url) {
    return User(
      id: this.id,
      email: this.email,
      username: this.username,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      avatar: url,
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    String avatar;

  //  if (json['avatar'] != null) {
  //    avatar = baseUrl + json['avatar'];
  //  }
    avatar = baseUrl + '/Content/images/products/boot-ang1.png';

    return User(
      id: '1', //json['_id'],
      username: json['displayName'],
      email: json['email'],
      avatar: avatar,
      createdAt: DateTime.parse(DateTime.now().toString()),//json['createdAt']),
      updatedAt: DateTime.parse(DateTime.now().toString()),//json['updatedAt']),
    );
  }
}