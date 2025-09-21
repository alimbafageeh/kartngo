class Item {
  final int? id;
  final String name;
  final double price;
  final String image;
  final String category;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      category: map['category'],
    );
  }
}
