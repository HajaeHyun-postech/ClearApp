// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'racket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Racket _$RacketFromJson(Map<String, dynamic> json) {
  return Racket(
    json['id'] as int,
    json['name'] as String,
    json['brand'] as String,
    json['type'] as String,
    json['balance'] as int,
    json['weight'] as int,
    json['info'] as String,
    json['isAvailable'] as bool,
    json['disabledInfo'] as String,
    json['asset'] as String,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RacketToJson(Racket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'type': instance.type,
      'balance': instance.balance,
      'weight': instance.weight,
      'info': instance.info,
      'isAvailable': instance.isAvailable,
      'disabledInfo': instance.disabledInfo,
      'asset': instance.asset,
      'user': instance.user,
    };
