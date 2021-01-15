import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom_action_bar.dart';
import 'package:flutter_app/widgets/product_card.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef.get(),
            builder: (context, snaphsot) {
              if (snaphsot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snaphsot.error}"),
                  ),
                );
              }

              //collection data ready to display
              if(snaphsot.connectionState == ConnectionState.done) {
                //Display the data inside the list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snaphsot.data.docs.map((document) {
                    return ProductCard(
                      title: document.data()['name'],
                      imageUrl: document.data()['image'][0],
                      price: "${document.data()['price']}\DH",
                      productId: document.id,
                    );
                  }).toList(),
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
            title: "Home",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
