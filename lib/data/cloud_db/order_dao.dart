import 'package:ali_poster/data/model/order.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDao {
  final _orderReference = FirebaseDatabase.instance.reference().child('order');

  void saveOrder(Order order) {
    _orderReference.push().set(order.toJson());
  }

  void updateOrder(Order order) {
    _orderReference.update({order.key!: order.toJson()});
  }

  void deleteWorker(Order order) {
    _orderReference.update({order.key!: order.toJsonWithoutWorker()});
  }

  Query getOrderQuery() {
    return _orderReference;
  }
}
