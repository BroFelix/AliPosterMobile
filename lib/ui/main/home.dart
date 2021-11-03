import 'package:ali_poster/data/cloud_db/order_dao.dart';
import 'package:ali_poster/data/cloud_db/worker_dao.dart';
import 'package:ali_poster/data/model/order.dart';
import 'package:ali_poster/data/model/worker.dart';
import 'package:ali_poster/data/prefs/shared_preferences.dart';
import 'package:ali_poster/theme/color.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:ali_poster/ui/main/current_orders.dart';
import 'package:ali_poster/ui/widgets/order_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Worker? _currentUser;
  final _orderDao = OrderDao();
  final _workerDao = WorkerDao();
  late FirebaseDatabase _cloudDatabase;
  List<Order> _notSentOrders = [];
  final String dateFromToday = (DateTime.now().day < 10 ? '0' : '') +
      DateTime.now().day.toString() +
      '/' +
      DateTime.now().month.toString() +
      '/' +
      DateTime.now().year.toString();

  @override
  void initState() {
    getUser().then((user) => setState(() => _currentUser = user));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        _cloudDatabase = Provider.of<FirebaseDatabase>(context);
        final _ordersReference = _cloudDatabase.reference().child('order');
        _ordersReference.keepSynced(true);

        getFCMToken().then((token) {
          if (token != _currentUser!.token) {
            _currentUser!.token = token!;
            _workerDao.updateWorker(_currentUser!);
          }
        });

        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
            actions: [
              Image.asset('assets/images/logo.png'),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                alignment: Alignment.center,
                child: Text(
                  _currentUser != null ? _currentUser!.name : 'Anonymous',
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
                fit: BoxFit.fill,
                image: Image.asset('assets/images/background.jpg').image,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Доска заказов',
                        style: AppTextStyle.homePageTitleStyle,
                      ),
                      Text(
                        dateFromToday,
                        style: AppTextStyle.dateTimeStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.7,
                  width: mediaQuery.size.width,
                  child: StreamBuilder(
                    stream: _ordersReference.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _notSentOrders = [];

                        DataSnapshot dataSnapshotFromEvent =
                            (snapshot.data as Event).snapshot;

                        dataSnapshotFromEvent.value.forEach((key, value) {
                          if (value != null || value['worker'] == null) {
                            _notSentOrders.add(Order(
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
                              top: 8,
                              left: 18,
                              right: 18,
                            ),
                            itemCount: _notSentOrders.length,
                            itemBuilder: (context, index) => OrderCard(
                              onPressed: () => setState(() {
                                _notSentOrders[index].worker = _currentUser!.id;
                                _orderDao.updateOrder(_notSentOrders[index]);
                              }),
                              orderId: _notSentOrders[index].id,
                              cost: _notSentOrders[index].total,
                              destination: _notSentOrders[index].address,
                              orderedTime: _notSentOrders[index].orderedTime,
                              clientContact: _notSentOrders[index].clientPhone,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: FractionalOffset.bottomCenter,
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: mediaQuery.size.height * 0.06,
                          minWidth: mediaQuery.size.width * 0.6,
                          color: AppColors.green,
                          textColor: AppColors.white,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      OrdersPage(currentUser: _currentUser!))),
                          child: const Text('Мои заказы'),
                        ),
                        Material(
                          shape: const CircleBorder(),
                          color: Colors.transparent,
                          child: IconButton(
                            iconSize: 48.0,
                            splashRadius: 25.0,
                            splashColor: AppColors.greenAccent,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HistoryPage(
                                        currentUser: _currentUser!))),
                            icon: const Icon(
                              Icons.history,
                              color: AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
