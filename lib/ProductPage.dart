import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';

import 'models/Product.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage(@required this.product);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
            child: Icon(
              Icons.shopping_cart,
              color: cello,
            ),
          )
        ],
      ),
      body: Container(
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
                    horizontal: width * 0.035, vertical: height * 0.024),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03, vertical: height * 0.01),
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
                              onPressed: () {},
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
                            onPressed: () {},
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
      ),
    );
  }
}
