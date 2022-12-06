class Order {
  String? id, phoneNumber, deliveryAddress,status;
  bool? isCOD;
  Map? orderBy;
  int? total,orderNumber;
  List products;

  Order(this.phoneNumber, this.deliveryAddress, this.isCOD, this.orderBy,this.status,
      this.products, this.total);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'orderNumber': orderNumber,
        'phoneNumber': phoneNumber,
        'deliveryAddress': deliveryAddress,
        'isCOD': isCOD,
        'orderBy': orderBy,
        'products': products,
        'total': total,
        'status': status
      };

  Order.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        orderNumber = jsonData['orderNumber'],
        phoneNumber = jsonData['phoneNumber'],
        deliveryAddress = jsonData['deliveryAddress'],
        isCOD = jsonData['isCOD'],
        orderBy = jsonData['orderBy'],
        status = jsonData['status'],
        total = jsonData['total'],
        products = jsonData['products'];
}
