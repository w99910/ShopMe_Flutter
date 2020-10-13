import 'dart:convert';
import 'dart:developer';

import 'package:ShopMe/models/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Product.dart';

class Cart {
  int id;
  int product_id;
  int quantity;
  int price;
  int user_id;
  Product product;
  Cart(
      {this.id,
      this.product_id,
      this.user_id,
      this.quantity,
      this.price,
      this.product});
  factory Cart.fromJson(Map<String, dynamic> json) {
    return new Cart(
      id: json['id'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      user_id: json['user_id'],
      product: Product.fromJson(json['product']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "product_id": this.product_id,
      "user_id": this.user_id,
      "price": this.price,
      "quantity": this.quantity,
      "product": this.product,
    };
  }
}

class CartNoti extends ChangeNotifier {
  List<Cart> carts = [];
  getCarts() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = await store.getString('token');
    var user = await store.getString('user');
    print(user);
    if (user != null) {
      User authuser = User.fromJson(json.decode(user));
      print(authuser);

      try {
        final response =
            await http.post('http://10.0.2.2:8000/api/all/carts', headers: {
          'Authorization': 'Bearer ' + token,
        }, body: {
          'id': authuser.id.toString()
        });

        print(response.statusCode);
        if (response.body != null) {
          List<Cart> carts = [];
          var json_res = json.decode(response.body);
          for (var v in json_res) {
            Cart cart = Cart.fromJson(v);
            carts.add(cart);
            inspect(cart);
          }

          return carts;
        } else {
          return null;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  List<Cart> get getCart => getCarts();
}
