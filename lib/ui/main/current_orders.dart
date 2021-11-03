import 'package:ali_poster/data/cloud_db/order_dao.dart';
import 'package:ali_poster/data/local_db/db_helper.dart';
import 'package:ali_poster/data/model/order.dart';
import 'package:ali_poster/data/model/worker.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:ali_poster/ui/widgets/taken_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final Worker currentUser;

  static const route = '/orders';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _takenOrders = [];
  final _orderDao = OrderDao();
  late FirebaseDatabase _cloudDatabase;
  final _localDatabase = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        _cloudDatabase = Provider.of<FirebaseDatabase>(context);
        final _ordersReferenceToDatabase =
            _cloudDatabase.reference().child('order');
        _ordersReferenceToDatabase.keepSynced(true);

        return Scaffold(
          appBar: AppBar(
            actions: [
              Image.asset('assets/images/logo.png'),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                alignment: Alignment.center,
                child: Text(
                  widget.currentUser.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.userNameStyle,
                ),
              ),
            ],
          ),
          body: Container(
            height: mediaQuery.size.height,
            width: mediaQuery.size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/background.jpg').image,
                fit: BoxFit.fill,
              ),
            ),
            child: SizedBox(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              child: StreamBuilder(
                stream: _ordersReferenceToDatabase.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _takenOrders = [];
                    DataSnapshot dataSnapshotFromEvent =
                        (snapshot.data as Event).snapshot;
                    dataSnapshotFromEvent.value.forEach((key, value) {
                      if (value['worker'] == widget.currentUser.id) {
                        _takenOrders.add(Order(
                          address: value['address']!,
                          id: value['id'],
                          cashierId: value['cashier_id'],
                          cashierName: value['cashier_name'],
                          clientPhone: value['client_phone'],
                          delivered: value['delivered'],
                          sent: value['sent'],
                          orderedTime: value['dt'],
                          guide: value['guide'],
                          products: value['products'],
                          total: value['total'],
                          uniqueId: value['unique_id'],
                          worker: value['worker'],
                          key: key,
                        ));
                      }
                    });

                    return SizedBox(
                      height: mediaQuery.size.height * 0.65,
                      width: mediaQuery.size.width,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 18,
                          top: 8,
                          right: 18,
                        ),
                        itemCount: _takenOrders.length,
                        itemBuilder: (context, index) {
                          DateTime deliveredTimeStamp = DateTime.now();
                          return TakenOrder(
                            isOrderSent: _takenOrders[index].sent,
                            onDelivered: () => setState(() {
                              _takenOrders[index].delivered = true;
                              _orderDao.updateOrder(_takenOrders[index]);
                              _localDatabase.insert(
                                _takenOrders[index],
                                deliveredTime: deliveredTimeStamp,
                              );
                            }),
                            onCancel: () => setState(() {
                              _orderDao.deleteWorker(_takenOrders[index]);
                              _localDatabase.delete(_takenOrders[index].id);
                            }),
                            orderId: _takenOrders[index].id,
                            cost: _takenOrders[index].total,
                            destination: _takenOrders[index].address,
                            orderedTime: _takenOrders[index].orderedTime,
                            clientContact: _takenOrders[index].clientPhone,
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
