import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: true)
class User {
  final int studentId;
  final String povisId;
  final String name;
  final bool isAdmin;

  User(this.studentId, this.povisId, this.name, this.isAdmin);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
