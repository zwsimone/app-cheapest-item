import 'package:camera/camera.dart';
import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cheapest_item_calculator/screens/item_scanner.dart';
import 'package:cheapest_item_calculator/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemEntry extends StatefulWidget {
  const ItemEntry({Key? key}): super(key: key);

  @override
  _ItemEntryState createState() => _ItemEntryState();
}

class _ItemEntryState extends State<ItemEntry> {
  final double tableCellPadding = 10.0;
  String categoryValue = 'Cheese';
  String uomDisplay = 'grams (g)';
  String uomValue = 'g';
  String barcodeValue = "";

  late final List<CameraDescription> cameras;

  final name = TextEditingController();
  final units = TextEditingController();
  final price = TextEditingController();
  final barcodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    units.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Entry'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              border: null,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: <TableRow>[
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Category:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: DropdownButton(
                        value: categoryValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            categoryValue = newValue!;
                            uomUpdate();
                          });
                        },
                        items: <String>['Cheese', 'Milk', 'Eggs', 'Meat']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Barcode:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: TextField(
                        onChanged: (id) async {
                          Item item = await getItemFromBarcode(id);
                          setFields(item);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () async {
                              Item item = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      ItemScanner(cameras: cameras))
                              );
                              barcodeController.text = item.barcode.toString();
                              print('Item returned: ${item.barcode},${item.category},${item.name},${item.units},${item.uom},${item.priceperuom}');
                              setFields(item);
                            }
                          ),
                        ),
                        controller: barcodeController,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Name:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: TextField(
                        controller: name,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Units:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: TextField(
                        controller: units,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Unit of Measure:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: Text(uomDisplay),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: const Text('Price:'),
                    ),
                    Container(
                      padding: EdgeInsets.all(tableCellPadding),
                      child: TextField(
                        controller: price,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () => dbUpdate(),
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void dbUpdate() {
    double unitsValue = double.parse(units.text);
    double priceValue = double.parse(price.text);
    double pricePerUom = priceValue / unitsValue;
    DatabaseService(barcodeController.text).updateItemData(categoryValue,
        name.text, unitsValue, uomValue, priceValue, pricePerUom);
    DatabaseService(barcodeController.text).updateDashboardItemData(
        categoryValue,
        name.text,
        unitsValue,
        uomValue,
        priceValue,
        pricePerUom);
    Navigator.pop(context);
  }

  void uomUpdate() {
    switch (categoryValue) {
      case 'Cheese':
        uomDisplay = 'grams (g)';
        uomValue = 'g';
        break;
      case 'Milk':
        uomDisplay = 'liters (l)';
        uomValue = 'l';
        break;
      case 'Eggs':
        uomDisplay = 'each (ea)';
        uomValue = 'ea';
        break;
      case 'Meat':
        uomDisplay = 'kilograms (kg)';
        uomValue = 'kg';
        break;
      default:
    }
  }

  Future<Item> getItemFromBarcode (String barcode) async {
    bool itemPresent = await DatabaseService().checkDocument(barcode);
    Item returnItem;
    if (itemPresent) {
      print('Item is present in the database');
      returnItem = await DatabaseService().getDocument(barcode);
    } else {
      print('Item is NOT present in the database');
      returnItem = Item(barcode: int.parse(barcode), category: "", name: "", units: 0, uom: "", price: 0, priceperuom: 0);
    }

    return returnItem;
  }

  void setFields(Item item) {
    if (item.price != 0) {
      name.text = item.name;
      units.text = item.units.toString();
      price.text = item.price.toString();
      setState(() {
        categoryValue = item.category;
        uomUpdate();
      });
    }
  }
}
