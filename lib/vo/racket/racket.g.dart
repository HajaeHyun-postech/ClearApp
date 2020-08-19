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
    json['info'] as String,
    json['available'] as bool,
    json['asset'] as String,
  );
}

Map<String, dynamic> _$RacketToJson(Racket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'info': instance.info,
      'available': instance.available,
      'asset': instance.asset,
    };
