class Order {
  String? key;
  String address;
  String id;
  int cashierId;
  String cashierName;
  String? clientPhone;
  bool delivered;
  bool sent;
  String orderedTime;
  String guide;
  String products;
  int total;
  int uniqueId;
  int? worker;

  Order({
    this.key,
    required this.address,
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
    this.worker,
  });

  factory Order.fromDB(Map<dynamic, dynamic> db) {
    return Order(
      key: db['key'],
      address: db['address'],
      id: db['id'].toString(),
      cashierId: db['cashier_id'],
      cashierName: db['cashier_name'],
      clientPhone: db['client_phone'],
      delivered: db['delivered'] == 0 ? false : true,
      sent: db['sent'] == 0 ? false : true,
      orderedTime: db['delivered_time'],
      guide: db['guide'],
      products: db['products'],
      total: db['total'],
      uniqueId: db['unique_id'],
      worker: db['worker'],
    );
  }

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
        key: json['key'],
        address: json['address'],
        id: json['id'],
        cashierId: json['cashier_id'],
        cashierName: json['cashier_name'],
        clientPhone: json['client_phone'],
        delivered: json['delivered'],
        sent: json['sent'],
        orderedTime: json['dt'],
        guide: json['guide'],
        products: json['products'],
        total: json['total'],
        uniqueId: json['unique_id'],
        worker: json['worker'],
      );

  Map<dynamic, dynamic> toJsonWithoutWorker() {
    return {
      'address': this.address,
      'cashier_id': this.cashierId,
      'cashier_name': this.cashierName,
      'client_phone': this.clientPhone,
      'delivered': this.delivered,
      'dt': this.orderedTime,
      'guide': this.guide,
      'id': this.id,
      'key': this.key,
      'products': this.products,
      'sent': this.sent,
      'total': this.total,
      'unique_id': this.uniqueId,
    };
  }

  Map<dynamic, dynamic> toJson() => {
        'address': this.address,
        'cashier_id': this.cashierId,
        'cashier_name': this.cashierName,
        'client_phone': this.clientPhone,
        'delivered': this.delivered,
        'dt': this.orderedTime,
        'guide': this.guide,
        'id': this.id,
        'key': this.key,
        'products': this.products,
        'sent': this.sent,
        'total': this.total,
        'unique_id': this.uniqueId,
        'worker': this.worker,
      };
}
