class Worker {
  int id;
  String name;
  String position;
  bool status;
  String token;
  String code;

  Worker({
    required this.id,
    required this.name,
    required this.position,
    required this.status,
    required this.token,
    required this.code,
  });

  factory Worker.fromJson(Map<dynamic, dynamic> json) => Worker(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        status: json['status'],
        token: json['token'],
        code: json['code'],
      );

  Map<dynamic, dynamic> toJson() => {
        'code': this.code,
        'id': this.id,
        'name': this.name,
        'position': this.position,
        'status': this.status,
        'token': this.token,
      };

  @override
  String toString() {
    return id.toString() +
        ' ' +
        name.toString() +
        ' ' +
        position.toString() +
        ' ' +
        status.toString() +
        ' ' +
        token.toString() +
        ' ' +
        code.toString();
  }
}
