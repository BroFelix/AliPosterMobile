import 'package:ali_poster/data/local_db/db_helper.dart';
import 'package:ali_poster/data/model/order.dart';
import 'package:ali_poster/data/model/worker.dart';
import 'package:ali_poster/theme/color.dart';
import 'package:ali_poster/theme/style.dart';
import 'package:ali_poster/ui/widgets/delivered_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final Worker currentUser;

  static const route = '/history';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _totalCostOfOrders = 0;
  List<Order> _deliveredOrders = [];
  late FirebaseDatabase _cloudDatabase;
  final _localDatabase = DatabaseHelper.instance;
  DateTime timeQueryToGetDeliveredOrders = DateTime.now();

  @override
  void initState() {
    _localDatabase
        .totalCostOfOrders(timeQueryToGetDeliveredOrders)
        .then((cost) => setState(() => _totalCostOfOrders = cost));
    _localDatabase
        .filterQuery(timeQueryToGetDeliveredOrders)
        .then((orders) => setState(() => _deliveredOrders.addAll(orders)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var _currencyFormatter = NumberFormat.currency(
      locale: 'uz_UZ',
      name: 'Сум',
      decimalDigits: 0,
    );

    final _reportDateDay = timeQueryToGetDeliveredOrders.day;
    final _reportDateMonth = timeQueryToGetDeliveredOrders.month;
    final _reportDateYear = timeQueryToGetDeliveredOrders.year;

    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        _cloudDatabase = Provider.of<FirebaseDatabase>(context);
        final _ordersReference = _cloudDatabase.reference().child('order');
        _ordersReference.keepSynced(true);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Отчет',
              style: AppTextStyle.appBarTitle,
            ),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_reportDateDay/$_reportDateMonth/$_reportDateYear',
                        style: AppTextStyle.dateTimeStyle,
                      ),
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: IconButton(
                          color: AppColors.green,
                          iconSize: 32.0,
                          icon: const Icon(Icons.calendar_today_outlined),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            ).then((selectedDateTimeForOrderQuery) {
                              if (selectedDateTimeForOrderQuery != null) {
                                timeQueryToGetDeliveredOrders =
                                    selectedDateTimeForOrderQuery;
                                _deliveredOrders = [];
                                _localDatabase
                                    .totalCostOfOrders(
                                        timeQueryToGetDeliveredOrders)
                                    .then((value) => setState(
                                        () => _totalCostOfOrders = value));
                                _localDatabase
                                    .filterQuery(timeQueryToGetDeliveredOrders)
                                    .then((value) => setState(
                                        () => _deliveredOrders.addAll(value)));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: mediaQuery.size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 18,
                        right: 18,
                      ),
                      itemCount: _deliveredOrders.length,
                      itemBuilder: (context, index) {
                        return DeliveredOrder(
                          taken: _deliveredOrders[index].worker !=
                              widget.currentUser.id,
                          orderId: _deliveredOrders[index].id,
                          cost: _deliveredOrders[index].total,
                          destination: _deliveredOrders[index].address,
                          orderedTime: _deliveredOrders[index].orderedTime,
                          clientContact: _deliveredOrders[index].clientPhone,
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: mediaQuery.size.height * 0.1,
                  alignment: Alignment.center,
                  child: Text(
                    'Общая сумма: ${_currencyFormatter.format(_totalCostOfOrders)}',
                    style: AppTextStyle.costPresentStyle,
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
