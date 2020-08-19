// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuttle_order_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShuttleOrderHistory _$ShuttleOrderHistoryFromJson(Map<String, dynamic> json) {
  return ShuttleOrderHistory(
    json['id'] as int,
    json['price'] as int,
    json['available'] as bool,
    User.fromJson(json['user'] as Map<String, dynamic>),
    DateTime.parse(json['orderDate'] as String),
    json['received'] as bool,
    json['depositConfirmed'] as bool,
  );
}

Map<String, dynamic> _$ShuttleOrderHistoryToJson(
        ShuttleOrderHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'available': instance.available,
      'user': instance.user,
      'orderDate': instance.orderDate.toIso8601String(),
      'received': instance.received,
      'depositConfirmed': instance.depositConfirmed,
    };
