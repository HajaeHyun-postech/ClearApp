import 'package:clearApp/vo/racket/racket.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'racket_check_out_history.g.dart';

@JsonSerializable(nullable: false)
class RacketCheckOutHistory {
  final int id;
  final User user;
  final Racket racket;
  final DateTime rentDate;
  final DateTime dueDate;
  final DateTime returnDate;

  RacketCheckOutHistory(this.id, this.user, this.racket, this.rentDate,
      this.dueDate, this.returnDate);

  factory RacketCheckOutHistory.fromJson(Map<String, dynamic> json) =>
      _$RacketCheckOutHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$RacketCheckOutHistoryToJson(this);
}
