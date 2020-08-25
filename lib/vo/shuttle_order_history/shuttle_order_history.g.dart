// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuttle_order_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShuttleOrderHistory _$ShuttleOrderHistoryFromJson(Map<String, dynamic> json) {
  return ShuttleOrderHistory(
    (json['idList'] as List)?.map((e) => e as int)?.toList(),
    json['price'] as int,
    json['isAvailable'] as bool,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['orderDate'] == null
        ? null
        : DateTime.parse(json['orderDate'] as String),
    json['isReceived'] as bool,
    json['isConfirmed'] as bool,
    json['orderUsage'] as String,
  );
}

Map<String, dynamic> _$ShuttleOrderHistoryToJson(
        ShuttleOrderHistory instance) =>
    <String, dynamic>{
      'idList': instance.idList,
      'price': instance.price,
      'isAvailable': instance.isAvailable,
      'user': instance.user,
      'orderUsage': instance.orderUsage,
      'orderDate': instance.orderDate?.toIso8601String(),
      'isReceived': instance.isReceived,
      'isConfirmed': instance.isConfirmed,
    };
