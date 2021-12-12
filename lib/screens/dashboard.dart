import 'package:cheapest_item_calculator/screens/item_entry.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
                    MaterialPageRoute(builder: (context) => const ItemEntry()),
                  );
                },
                tooltip: 'Add Item',
                heroTag: null,
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: Icon(Icons.camera_alt),
                onPressed: null,
                tooltip: 'Scan Barcode',
                heroTag: null,
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                label: Text('Calculate'),
                onPressed: null,
                heroTag: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
