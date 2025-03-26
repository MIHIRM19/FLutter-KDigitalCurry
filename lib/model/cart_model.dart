class CartItem {
  final String id;
  final String title;
  final String description;
  final String price;
  final String realPrice;
  final String image;
  final String size;
  final String color;

  CartItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.realPrice,
    required this.image,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'realPrice': realPrice,
        'image': image,
        'size': size,
        'color': color,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        realPrice: json['realPrice'],
        image: json['image'],
        size: json['size'],
        color: json['color'],
      );
}
