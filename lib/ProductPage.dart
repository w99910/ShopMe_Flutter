import 'dart:convert';
import 'dart:developer';

import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Cart.dart';
import 'models/Product.dart';
import 'models/User.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage(@required this.product);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  createCart(Product product, BuildContext context) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    String stored_user = await store.getString('user');
    String token = await store.getString('token');
    if (stored_user != null && token != null) {
      User user = User.fromJson(json.decode(stored_user));
      inspect(user);
      inspect(product);
      try {
        final response =
            await http.post('http://10.0.2.2:8000/api/create/cart', headers: {
          'Authorization': 'Bearer ' + token,
        }, body: {
          'product_id': product.id.toString(),
          'user_id': user.id.toString(),
          'price': product.price.toString(),
        });
        print(response.body);
        var resp = json.decode(response.body);
        if (response.statusCode == 201) {
          print(resp);
          SnackBar mysnackbar = SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          MediaQuery.of(context).size.height * 0.03),
                      topRight: Radius.circular(
                          MediaQuery.of(context).size.height * 0.03))),
              elevation: 0,
              backgroundColor: soft_pink,
              content: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(

                      // borderRadius: BorderRadius.circular(heigh),
                      ),
                  child: Center(
                      child: BuildText(
                    text: resp,
                    color: cello,
                    fontsize: 17,
                  ))));
          Scaffold.of(context).showSnackBar(mysnackbar);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: soft_pink,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: cello),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: BuildText(
            text: widget.product.name,
            color: cello,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: Icon(
                  Icons.shopping_cart,
                  color: cello,
                ),
              ),
            )
          ],
        ),
        body: Builder(builder: (context) {
          return Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.05),
                  height: height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(widget.product.image_path))),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.03),
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(height * 0.04),
                            topRight: Radius.circular(height * 0.04)),
                        color: cello),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BuildText(
                              text: widget.product.name,
                              color: alert,
                              fontsize: 20,
                              bold: FontWeight.bold,
                            ),
                            BuildText(
                              text: "\$${widget.product.price}",
                              color: alert,
                              fontsize: 20,
                              bold: FontWeight.bold,
                            )
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  BuildText(
                                    text: 'Review :',
                                    color: soft_pink,
                                    fontsize: 19,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: alert,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: alert,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: alert,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: alert,
                                  ),
                                  Icon(
                                    Icons.star_half,
                                    color: alert,
                                  ),
                                ],
                              ),
                              BuildText(
                                  color: soft_pink,
                                  fontsize: 18,
                                  text:
                                      "Nobody wants to see an engagement photo with you in your ratty jeans and t-shirt. Go for layers, and you're always going to look like you made more of an effort.")
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: FlatButton(
                                  color: cello_600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(height * 0.03)),
                                  onPressed: () async {
                                    await createCart(widget.product, context);
                                  },
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Center(
                                      child: BuildText(
                                    text: 'Add to Cart',
                                    fontsize: 18,
                                    color: soft_pink,
                                  ))),
                            ),
                            FlatButton(
                                color: alert,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.03)),
                                onPressed: () async {},
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Center(
                                    child: BuildText(
                                  text: 'Checkout',
                                  fontsize: 18,
                                  color: soft_pink,
                                ))),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
