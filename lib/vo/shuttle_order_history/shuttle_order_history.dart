import 'package:clearApp/vo/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shuttle_order_history.g.dart';

@JsonSerializable(nullable: true)
class ShuttleOrderHistory {
  final List<int> id;
  final int price;
  final bool isAvailable;
  final User user;
  final String orderUsage;
  final DateTime orderDate;
  final bool isReceived;
  final bool isConfirmed;

  ShuttleOrderHistory(
    this.id,
    this.price,
    this.isAvailable,
    this.user,
    this.orderDate,
    this.isReceived,
    this.isConfirmed,
    this.orderUsage,
  );

  factory ShuttleOrderHistory.fromJson(Map<String, dynamic> json) =>
      _$ShuttleOrderHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ShuttleOrderHistoryToJson(this);
}
