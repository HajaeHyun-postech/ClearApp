// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['studentId'] as int,
    json['povisId'] as String,
    json['name'] as String,
    json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'studentId': instance.studentId,
      'povisId': instance.povisId,
      'name': instance.name,
      'isAdmin': instance.isAdmin,
    };
