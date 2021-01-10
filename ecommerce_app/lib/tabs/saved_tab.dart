import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom_action_bar.dart';

class SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Text("Saved Tabs"),
          ),
          CustomActionBar(
            title: "Saved Products",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
