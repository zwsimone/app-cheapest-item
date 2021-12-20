import 'package:cheapest_item_calculator/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemResult extends StatelessWidget {
  const ItemResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<Item>>(context);

    Item cheapestItem = calcCheapestItem(items);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Colors.green,
        child: ListTile(
          title: Text('Cheapest Item:'),
          subtitle: Text('${cheapestItem.name}\nR ${cheapestItem.priceperuom} / ${cheapestItem.uom}'),
        ),
      ),
    );
  }

  Item calcCheapestItem(List<Item> items) {
    Item cheapestItem;

    if (items.isEmpty) {
      cheapestItem = Item(barcode: 0, category: "", name: "", units: 0, uom: "", price: 0, priceperuom: 0);
    } else {
      int index = 1;
      cheapestItem = items.first;

      while (index < items.length) {
        Item item = items[index];
        if (cheapestItem.priceperuom > item.priceperuom) {
          cheapestItem = item;
        }
        index++;
      }
    }

    return cheapestItem;
  }
}
