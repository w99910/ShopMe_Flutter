import 'dart:convert';

import 'package:ShopMe/Cart.dart';
import 'package:ShopMe/ProductPage.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/Product.dart';

class AllProduct extends StatefulWidget {
  @override
  _AllProductState createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  String searchQuery = "Search query";
  TextEditingController _search = TextEditingController();

  Future<List<Product>> getAll() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var token = storage.getString('token');
    print(token);
    try {
      final response =
          await http.get('http://10.0.2.2:8000/api/all/products', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      });
      var json_res = json.decode(response.body);
      List<Product> products = [];
      for (var p in json_res) {
        Product product = Product.fromJson(p);
        products.add(product);
      }
      print(products);
      return products;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: soft_pink,
      appBar: AppBar(
        backgroundColor: cello,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Icon(
                Icons.shopping_cart,
                color: soft_pink,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: width,
        height: double.infinity,
        child: FutureBuilder(
            future: getAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(snapshot.data.length, (int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(snapshot.data[index])));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.025,
                                vertical: height * 0.01),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(height * 0.025),
                                color: cello,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${snapshot.data[index].image_path}")))),
                      );
                    }));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
