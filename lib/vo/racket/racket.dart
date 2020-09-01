import 'package:clearApp/vo/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'racket.g.dart';

@JsonSerializable(nullable: true)
class Racket {
  final int id;
  final String name;
  final String brand;
  final String type;
  final int balance;
  final int weight;
  final String info;
  final bool isAvailable;
  final String disabledInfo;
  final String asset;
  final User user;

  Racket(this.id, this.name, this.brand, this.type, this.balance, this.weight,
      this.info, this.isAvailable, this.disabledInfo, this.asset, this.user);

  factory Racket.fromJson(Map<String, dynamic> json) => _$RacketFromJson(json);
  Map<String, dynamic> toJson() => _$RacketToJson(this);
}
