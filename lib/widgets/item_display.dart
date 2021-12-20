import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cheapest_item_calculator/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheapest_item_calculator/widgets/item_tile.dart';

class ItemDisplay extends StatefulWidget {
  const ItemDisplay({Key? key}) : super(key: key);

  @override
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {

  @override
  void initState() {
    super.initState();
    DatabaseService().clearCollection('dashboard');
  }

  @override
  Widget build(BuildContext context) {

    final items = Provider.of<List<Item>>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemTile(item: items[index]);
      },
    );
  }
}
