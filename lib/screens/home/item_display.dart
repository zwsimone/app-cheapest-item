import 'package:cheapest_item_calculator/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cheapest_item_calculator/screens/home/item_tile.dart';

class ItemDisplay extends StatefulWidget {
  const ItemDisplay({Key? key}) : super(key: key);

  @override
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {
  @override
  Widget build(BuildContext context) {

    final items = Provider.of<List<Item>>(context);

    // items.forEach((item) {
    //   print(item.category);
    //   print(item.name);
    //   print(item.units);
    //   print(item.uom);
    //   print(item.price);
    //   print(item.priceperuom);
    // });

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemTile(item: items[index]);
      },
    );
  }
}
