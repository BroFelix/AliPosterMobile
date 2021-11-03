import 'package:ali_poster/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveredOrder extends StatelessWidget {
  DeliveredOrder({
    Key? key,
    this.orderId,
    this.cost,
    this.destination,
    this.orderedTime,
    this.clientContact,
    required this.taken,
  }) : super(key: key);

  bool taken;
  final String? orderId;
  final int? cost;
  final String? destination;
  final String? orderedTime;
  final String? clientContact;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Заказ №$orderId'),
                    const SizedBox(width: 24),
                    Text(
                      '$cost Сум',
                      style: AppTextStyle.orderTextStyle,
                    ),
                  ],
                ),
                Text(
                  'Адрес: $destination!',
                  style: AppTextStyle.orderTextStyle,
                ),
                Text(
                  'Время заявки: $orderedTime!',
                  style: AppTextStyle.orderTextStyle,
                ),
                Text(
                  'Контакты клиента: ${clientContact ?? ""}',
                  style: AppTextStyle.orderTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
