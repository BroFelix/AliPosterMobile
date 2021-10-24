import 'package:flutter/cupertino.dart';

class Order {
  int id;
  int cashierId;
  String cashierName;
  String clientPhone;
  bool delivered;
  bool sent;
  String orderedTime;
  String guide;
  String products;
  int total;
  int uniqueId;
  int worker;

  Order({
    required this.id,
    required this.cashierId,
    required this.cashierName,
    required this.clientPhone,
    required this.delivered,
    required this.sent,
    required this.orderedTime,
    required this.guide,
    required this.products,
    required this.total,
    required this.uniqueId,
    this.worker = -1,
  });
}
