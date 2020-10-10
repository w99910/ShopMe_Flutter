import 'dart:convert';

import 'package:ShopMe/api/api.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'ProductPage.dart';
import 'models/Product.dart';
import 'models/User.dart';

class Home extends StatefulWidget {
  final User user;
  const Home(this.user);
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Product>> _getProducts() async {
    try {
      final response =
          await http.get('http://10.0.2.2:8000/api/home/products', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 1|YmQ1ZMG8geYW1Gn3GHtDs3V7axpGjrPsMJrClkXB'
      });

      var jsondata = json.decode(response.body);

      List<Product> products = [];
      for (var u in jsondata) {
        Product product = Product.fromJson(u);

        products.add(product);
      }

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
          leading: Icon(
            Icons.menu,
            color: soft_pink,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.shopping_cart),
            )
          ],
          title: Text(
            'ShopMe',
            style: GoogleFonts.dancingScript(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: soft_pink)),
          ),
          backgroundColor: cello,
        ),
        body: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          height: height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.025,
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildText(
                      text: 'Lastest Arrival Products',
                      color: cello,
                      fontsize: 16,
                    ),
                    BuildText(
                      text: 'View All',
                      fontsize: 16,
                      color: cello,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                height: height * 0.28,
                child: FutureBuilder(
                  future: _getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductPage(snapshot.data[index])))
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: width * 0.025,
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${snapshot.data[index].image_path}")),
                                  color: cello,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.03)),
                              height: height * 0.28,
                              width: height * 0.25,
                              child: Center(
                                child: BuildText(
                                    text: snapshot.data[index].name,
                                    color: soft_pink),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
