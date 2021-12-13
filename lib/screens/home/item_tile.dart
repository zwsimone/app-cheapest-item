import 'package:cheapest_item_calculator/models/item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    String priceValue = (item.priceperuom).toStringAsFixed(2);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(item.name),
          subtitle: Text('R $priceValue / ${item.uom}'),
        ),
      ),
    );
  }
}
