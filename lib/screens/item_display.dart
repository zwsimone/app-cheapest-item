import 'package:cheapest_item_calculator/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDisplay extends StatefulWidget {
  const ItemDisplay({Key? key}) : super(key: key);

  @override
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {
  @override
  Widget build(BuildContext context) {

    final items = Provider.of<List<Item>>(context);

    items.forEach((item) {
      print(item.category);
      print(item.name);
      print(item.units);
      print(item.uom);
      print(item.price);
    });

    return Container(
      child: Text('list goes here'),
    );
  }
}
