class StoreProduct {
  String? id, title, articleId, productPhoto;
  bool isAvailable, isDisable;
  int? quantity, price;
  List? reviews,totalOrders;

  StoreProduct(this.title, this.articleId, this.productPhoto,
      this.quantity, this.isAvailable, this.price, this.isDisable,this.reviews);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        // 'category': category,
        'articleId': articleId,
        'productPhoto': productPhoto,
        'quantity': quantity,
        'isAvailable': isAvailable,
        'isDisable': isDisable,
        'price': price,
        'reviews':reviews
      };

  StoreProduct.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        title = jsonData['title'],
        // category = jsonData['category'],
        articleId = jsonData['articleId'],
        productPhoto = jsonData['productPhoto'],
        quantity = jsonData['quantity'],
        isAvailable = jsonData['isAvailable'] ?? false,
        isDisable = jsonData['isDisable'] ?? false,
        price = jsonData['price'],
        totalOrders = jsonData['totalOrders'] ?? [],
        reviews = jsonData['reviews'];
}
