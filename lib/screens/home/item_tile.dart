import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cheapest_item_calculator/screens/home/item_display.dart';
import 'package:cheapest_item_calculator/services/database.dart';
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
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              DatabaseService().deleteDocument(item.barcode.toString());
              ItemDisplay();
            },
          ),
        ),
      ),
    );
  }
}
