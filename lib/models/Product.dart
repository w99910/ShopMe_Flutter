import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  String category;
  int price;
  String image_path;
  String size;
  int quantity;
  Product(
      {this.id,
      @required this.name,
      this.category,
      this.price,
      this.image_path,
      this.size,
      this.quantity});
  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      image_path: json['image_path'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "category": this.category,
      "price": this.price,
      "image_path": this.image_path,
      "size": this.size,
      "quantity": this.quantity,
    };
  }
}
