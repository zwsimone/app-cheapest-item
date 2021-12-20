import 'package:cheapest_item_calculator/services/database.dart';
import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ItemEntry extends StatefulWidget {

  const ItemEntry({Key? key}) : super(key: key);

  @override
  _ItemEntryState createState() => _ItemEntryState();
}

class _ItemEntryState extends State<ItemEntry> {
  final double tableCellPadding = 10.0;
  String categoryValue = 'Cheese';
  String uomDisplay = 'grams (g)';
  String uomValue = 'g';
  String barcodeValue = "";

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
    //_controller.dispose();
    super.dispose();
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
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: SizedBox(
                                              width: (MediaQuery.of(context).size.width)*0.8,
                                              height: ((MediaQuery.of(context).size.height)/2)*0.8,
                                              child: QrCamera(
                                                onError: (context, error) => Text(
                                                  error.toString(),
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                qrCodeCallback: (code) {
                                                  setState(() {
                                                    barcodeValue = code!;
                                                    barcodeController.text = barcodeValue;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        color: Colors.orange,
                                                        width: 10.0,
                                                        style: BorderStyle.solid),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'))),
                                        ),
                                      ],
                                    );
                                  });
                            },
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
}