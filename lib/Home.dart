import 'dart:convert';
import 'dart:developer';

import 'package:ShopMe/AllProduct.dart';
import 'package:ShopMe/Cart.dart';
import 'package:ShopMe/Login.dart';
import 'package:ShopMe/Profile.dart';
import 'package:ShopMe/api/Api.dart';
import 'package:ShopMe/models/Cart.dart';
import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductPage.dart';
import 'intro.dart';
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
    inspect(widget.user);
  }

  Future<List<Product>> _getProducts() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = await storage.getString('token');

    try {
      final response = await http
          .get('http://10.0.2.2:8000/api/home/lastest_products', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
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

  Future<List<Product>> _get5products() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = await storage.getString('token');

    try {
      final response =
          await http.get('http://10.0.2.2:8000/api/home/products', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
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

  bool isOpen = false;
  Widget buildSideBar(double width, double height, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: height * 0.8,
        width: width * 0.5,

        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        // decoration: BoxDecoration(
        //     color: soft_pink,
        //     borderRadius: BorderRadius.only(
        //         topRight: Radius.circular(24),
        //         bottomRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(children: [
                Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.person,
                      color: soft_pink,
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(widget.user)));
                  },
                  child: BuildText(
                    text: "Profile",
                    fontsize: 20,
                    color: soft_pink,
                    bold: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(children: [
                Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.shopping_cart,
                      color: soft_pink,
                    )),
                BuildText(
                  text: "Checkout",
                  fontsize: 20,
                  color: soft_pink,
                  bold: FontWeight.bold,
                ),
              ]),
            ),
            GestureDetector(
              onTap: () {
                logout(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Row(children: [
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.exit_to_app,
                        color: soft_pink,
                      )),
                  BuildText(
                    text: "Logout",
                    fontsize: 20,
                    color: soft_pink,
                    bold: FontWeight.bold,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CartNoti>.value(
      value: CartNoti(),
      child: Scaffold(
          backgroundColor: cello,
          body: Stack(children: [
            buildSideBar(width, height, context),
            AnimatedPositioned(
              curve: Curves.easeOut,
              top: isOpen ? height * 0.10 : 0,
              bottom: isOpen ? height * 0.10 : 0,
              left: isOpen ? width * 0.6 : 0,
              right: isOpen ? -width * 0.6 : 0,
              duration: Duration(milliseconds: 300),
              child: Material(
                color: soft_pink,
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      Container(
                          height: height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: cello,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          padding: EdgeInsets.only(
                              right: width * 0.03,
                              left: width * 0.03,
                              top: isOpen ? 0 : height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOpen = !isOpen;
                                  });
                                },
                                child: Icon(
                                  Icons.menu,
                                  color: soft_pink,
                                ),
                              ),
                              Text(
                                'ShopMe',
                                style: GoogleFonts.dancingScript(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        color: soft_pink)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartPage()));
                                },
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: soft_pink,
                                ),
                              )
                            ],
                          )),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Column(children: [
                            Container(
                              width: width,
                              height: height * 0.025,
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: BuildText(
                                        text: 'Lastest Arrival Products',
                                        color: cello,
                                        fontsize: 16,
                                        bold: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllProduct()));
                                    },
                                    child: Container(
                                      child: BuildText(
                                        text: 'View All',
                                        fontsize: 16,
                                        color: cello,
                                        bold: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
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
                                                        ProductPage(snapshot
                                                            .data[index])))
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
                                                    BorderRadius.circular(
                                                        height * 0.03)),
                                            height: height * 0.28,
                                            width: height * 0.25,
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BuildText(
                                  text: "Popular Products",
                                  fontsize: 16,
                                  color: cello,
                                  bold: FontWeight.w900,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllProduct()));
                                  },
                                  child: BuildText(
                                    text: "View All",
                                    fontsize: 16,
                                    color: cello,
                                    bold: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              child: Expanded(
                                child: FutureBuilder(
                                  future: _get5products(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductPage(snapshot
                                                                .data[index])));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: height * 0.01),
                                                height: height * 0.2,
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.04,
                                                    vertical: height * 0.01),
                                                decoration: BoxDecoration(
                                                    color: cello,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height * 0.02)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        BuildText(
                                                          text: snapshot
                                                              .data[index].name,
                                                          fontsize: 20,
                                                          color: soft_pink,
                                                        ),
                                                        BuildText(
                                                          text:
                                                              "\$${snapshot.data[index].price}",
                                                          fontsize: 20,
                                                          color: alert,
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: double.infinity,
                                                      width: width * 0.3,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: NetworkImage(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .image_path))),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            )
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}

logout(BuildContext context) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  var token = await storage.getString('token');
  var user = await storage.getString('user');
  if (token != null) {
    await storage.remove('token');
  }
  if (user != null) {
    await storage.remove('user');
  }
  if (storage.getBool('remember') != null) {
    await storage.remove('remember');
  }
  Navigator.push(context, MaterialPageRoute(builder: (context) => IntroPage()));
}
