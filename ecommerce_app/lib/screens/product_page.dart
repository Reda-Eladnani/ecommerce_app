import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/widgets/custom_action_bar.dart';
import 'package:flutter_app/widgets/image_swipe.dart';
import 'package:flutter_app/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference _productsRef =
    FirebaseFirestore.instance.collection("Products");

  final CollectionReference _usersRef = FirebaseFirestore
      .instance
      .collection(
      "Users");

  User _user = FirebaseAuth.instance.currentUser;

  String _selectedProductSize = "0";

  Future _addToCard() {
    return _usersRef
        .doc(_user.uid)
        .collection("Card")
        .doc(widget.productId)
        .set(
      {
        "size": _selectedProductSize
      }
    );
  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to the card"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if(snapshot.connectionState == ConnectionState.done) {
                //FireBase Doc data Map
                Map<String, dynamic> documentData = snapshot.data.data();

                //List of images
                List imageList = documentData['image'];
                List productSize = documentData['size'];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    // Container(
                    //   height: 400.0,
                    //   child: PageView(
                    //     children: [
                    //       Container(
                    //         child: Image.network(
                    //             "${documentData['image']}",
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${documentData['name']}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                        ),
                      child: Text(
                        "${documentData['price']}\DH",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                      child: Text(
                        "${documentData['description']}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                          "Select size",
                          style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSize: productSize,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFDCDCDC),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                "assets/images/tab_saved.png",
                              ),
                              //width: 13.0,
                              height: 22.0,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCard();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                    "Add to card",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );

              }

              //Loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
