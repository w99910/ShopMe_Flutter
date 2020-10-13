import 'dart:convert';
import 'dart:developer';

import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/Cart.dart';
import 'models/User.dart';

class CartPage extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> {
  Future<List<Cart>> getCarts() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = await store.getString('token');
    var user = await store.getString('user');

    if (user != null) {
      User authuser = User.fromJson(json.decode(user));

      try {
        final response =
            await http.post('http://10.0.2.2:8000/api/all/carts', headers: {
          'Authorization': 'Bearer ' + token,
        }, body: {
          'id': authuser.id.toString()
        });

        if (response.body != null) {
          List<Cart> carts = [];
          var json_res = json.decode(response.body);
          for (var v in json_res) {
            Cart cart = Cart.fromJson(v);
            carts.add(cart);
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

  increment(Cart cart) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = await store.getString('token');
    final resp =
        await http.post('http://10.0.2.2:8000/api/increment', headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      'id': cart.id.toString(),
    });
    print(resp.statusCode);
    if (resp.statusCode == 201) {
      return resp.body;
    } else
      return null;
  }

  decrement(Cart cart) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = await store.getString('token');
    final resp =
        await http.post('http://10.0.2.2:8000/api/decrement', headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      'id': cart.id.toString(),
    });
    print(resp.body);
    if (resp.statusCode == 201) {
      return resp.body;
    } else
      return null;
  }

  deleteCart(Cart cart) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = await store.getString('token');
    final _response =
        await http.post('http://10.0.2.2:8000/api/delete/cart', headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      'id': cart.id.toString()
    });
    print(_response.body);
    if (_response.statusCode == 201) {
      return 'success';
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: soft_pink,
      appBar: AppBar(
        backgroundColor: cello,
      ),
      body: FutureBuilder(
        future: getCarts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text('There is no product in your cart'),
            );
          } else {
            List<Cart> mycarts = snapshot.data;

            return ListView.builder(
                itemCount: mycarts.length,
                itemBuilder: (context, int index) {
                  int price = mycarts[index].price * mycarts[index].quantity;
                  return Container(
                    margin: EdgeInsets.only(
                        left: width * 0.02,
                        right: width * 0.02,
                        top: height * 0.07),
                    width: double.infinity,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cello,
                    ),
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          child: Container(
                            width: width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildText(
                                  text: mycarts[index].product.name,
                                  color: soft_pink,
                                  fontsize: 18,
                                  bold: FontWeight.bold,
                                ),
                                BuildText(
                                  text: '\$' + price.toString(),
                                  color: alert,
                                  fontsize: 17,
                                  bold: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: height * 0.01,
                          child: FlatButton(
                              color: Colors.redAccent,
                              onPressed: () async {
                                await deleteCart(mycarts[index]).then((res) {
                                  print(res);
                                  if (res == 'success') {
                                    setState(() {
                                      mycarts.remove(mycarts[index]);
                                      print(mycarts);
                                    });
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: BuildText(
                                  text: 'Delete',
                                  fontsize: 17,
                                  color: soft_pink,
                                ),
                              )),
                        ),
                        Positioned(
                          top: -height * 0.07,
                          child: Container(
                            height: height * 0.2,
                            width: width * 0.4,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        mycarts[index].product.image_path))),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            width: width * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await increment(mycarts[index]).then((res) {
                                      if (res != null) {
                                        setState(() {
                                          mycarts[index].quantity += 1;
                                        });
                                        print(mycarts[index].price.toString());
                                      }
                                    });
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: alert,
                                  ),
                                ),
                                BuildText(
                                  text: mycarts[index].quantity.toString(),
                                  color: soft_pink,
                                  fontsize: 18,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await decrement(mycarts[index])
                                          .then((res) {
                                        if (res != null &&
                                            mycarts[index].quantity > 1) {
                                          setState(() {
                                            mycarts[index].quantity -= 1;
                                          });
                                        }
                                      });
                                    },
                                    child: Icon(Icons.remove, color: alert)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
