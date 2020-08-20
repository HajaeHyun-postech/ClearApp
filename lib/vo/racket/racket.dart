import 'package:json_annotation/json_annotation.dart';

part 'racket.g.dart';

@JsonSerializable(nullable: false)
class Racket {
  final int id;
  final String name;
  final String brand;
  final String type;
  final int balance;
  final int weight;
  final String info;
  final bool available;
  final String disabledInfo;
  final String asset;

  Racket(this.id, this.name, this.brand, this.info, this.available, this.asset,
      this.type, this.balance, this.weight, this.disabledInfo);
  factory Racket.fromJson(Map<String, dynamic> json) => _$RacketFromJson(json);
  Map<String, dynamic> toJson() => _$RacketToJson(this);
}
