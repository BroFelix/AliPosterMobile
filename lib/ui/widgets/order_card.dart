import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    required this.orderId,
    required this.cost,
    required this.destination,
    required this.orderedTime,
    required this.clientContact,
  }) : super(key: key);

  final int orderId;
  final int cost;
  final String destination;
  final int orderedTime;
  final String clientContact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text("Заказ №$orderId"),
                    const SizedBox(width: 24),
                    Text("$cost Сум"),
                  ],
                ),
                Text(destination),
                Text("Время заявки $orderedTime"),
                Text("Контакты клиена $clientContact"),
              ],
            ),
            IconButton(
              color: Colors.green,
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
