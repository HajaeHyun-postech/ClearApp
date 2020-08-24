// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'racket_check_out_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RacketCheckOutHistory _$RacketCheckOutHistoryFromJson(
    Map<String, dynamic> json) {
  return RacketCheckOutHistory(
    json['id'] as int,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['racket'] == null
        ? null
        : Racket.fromJson(json['racket'] as Map<String, dynamic>),
    json['rentDate'] == null
        ? null
        : DateTime.parse(json['rentDate'] as String),
    json['dueDate'] == null ? null : DateTime.parse(json['dueDate'] as String),
    json['returnDate'] == null
        ? null
        : DateTime.parse(json['returnDate'] as String),
  );
}

Map<String, dynamic> _$RacketCheckOutHistoryToJson(
        RacketCheckOutHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'racket': instance.racket,
      'rentDate': instance.rentDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'returnDate': instance.returnDate?.toIso8601String(),
    };
