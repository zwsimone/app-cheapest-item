import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cheapest_item_calculator/widgets/item_display.dart';
import 'package:cheapest_item_calculator/widgets/item_result.dart';
import 'package:cheapest_item_calculator/screens/item_entry.dart';
import 'package:cheapest_item_calculator/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Item>>.value(
      value: DatabaseService().dashboardItems,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const [
                  ItemDisplay(),
                  ItemResult(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemEntry()),
                    );
                  },
                  tooltip: 'Add Item',
                  heroTag: null,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: const Icon(Icons.clear_all),
                  onPressed: () => DatabaseService().clearCollection('dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
