import 'package:clearApp/vo/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shuttle_order_history.g.dart';

@JsonSerializable(nullable: false)
class ShuttleOrderHistory {
  final int id;
  final int price;
  final bool available;
  final User user;
  final DateTime orderDate;
  final bool received;
  final bool depositConfirmed;

  ShuttleOrderHistory(this.id, this.price, this.available, this.user,
      this.orderDate, this.received, this.depositConfirmed);

  factory ShuttleOrderHistory.fromJson(Map<String, dynamic> json) =>
      _$ShuttleOrderHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ShuttleOrderHistoryToJson(this);
}
