import 'dart:core';

class ShuttleData {
  String title;
  DateTime date;
  int price;
  int amount;
  List<int> shuttleList;
  bool received;
  bool approved;

  ShuttleData({
    this.title,
    this.date,
    this.price,
    this.amount,
    this.shuttleList,
    this.received,
    this.approved,
  });

  ShuttleData.initial(String _title, int _price, int _amount)
      : title = _title,
        date = new DateTime.now(),
        price = _price,
        amount = _amount,
        shuttleList = new List<int>(),
        received = false,
        approved = false;

  ShuttleData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = json['date'],
        price = json['price'],
        amount = json['amount'],
        shuttleList = json['shuttleList'],
        received = json['received'],
        approved = json['approved'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'price': price,
        'amount': amount,
        'shuttleList': shuttleList,
        'received': received,
        'approved': approved,
      };

  @override
  bool operator ==(Object other) =>
      other is ShuttleData &&
      this.title == other.title &&
      this.date == other.date &&
      this.price == other.price &&
      this.amount == other.amount;
}
