import 'dart:convert';

class Product {
  final int? id;
  final String name;
  final String price;
  final String category;
  final String description;
  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  Product copyWith({
    int? id,
    String? name,
    String? price,
    String? category,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: int.parse(map['id']),
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.category == category &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        category.hashCode ^
        description.hashCode;
  }
}
