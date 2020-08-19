import 'package:json_annotation/json_annotation.dart';

part 'racket.g.dart';

@JsonSerializable(nullable: false)
class Racket {
  final int id;
  final String name;
  final String brand;
  final String info;
  final bool available;
  final String asset;

  Racket(this.id, this.name, this.brand, this.info, this.available, this.asset);
  factory Racket.fromJson(Map<String, dynamic> json) => _$RacketFromJson(json);
  Map<String, dynamic> toJson() => _$RacketToJson(this);
}
