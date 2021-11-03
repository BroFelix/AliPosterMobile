import 'package:ali_poster/theme/color.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class TakenOrder extends StatelessWidget {
  const TakenOrder({
    Key? key,
    this.orderId,
    this.cost,
    this.destination,
    this.orderedTime,
    this.clientContact,
    required this.isOrderSent,
    required this.onDelivered,
    required this.onCancel,
  }) : super(key: key);

  final bool isOrderSent;
  final String? orderId;
  final int? cost;
  final String? destination;
  final String? orderedTime;
  final String? clientContact;
  final VoidCallback onDelivered;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Заказ №$orderId',
                      style: AppTextStyle.orderTextStyle,
                    ),
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
                  'Контакты клиена ${clientContact ?? ""}',
                  style: AppTextStyle.orderTextStyle,
                ),
              ],
            ),
            if (isOrderSent) ...[
              Material(
                shape: const CircleBorder(),
                // color: Colors.green,
                color: AppColors.red,
                child: IconButton(
                  iconSize: 32.0,
                  splashRadius: 25.0,
                  onPressed: onDelivered,
                  icon: const Icon(
                    Icons.done,
                    color: AppColors.white,
                  ),
                ),
              )
            ] else ...[
              Material(
                shape: const CircleBorder(),
                color: AppColors.purple,
                child: IconButton(
                  iconSize: 32.0,
                  splashRadius: 25.0,
                  onPressed: onCancel,
                  icon: const Icon(
                    Icons.remove,
                    color: AppColors.white,
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
