import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? id;
  DatabaseService([this.id]);

  // collection reference
  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection("items");

  Future addItemData(String category, String name, double units, String uom, double price) async {
    return await itemsCollection.add({
      'category': category,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
    });
  }

  Future updateItemData(String category, String name, double units, String uom, double price) async {
    return await itemsCollection.doc(id).set({
      'category': category,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
    });
  }

  // get items stream
  Stream<List<Item>>? get items {
    return itemsCollection.snapshots().map(_itemListfromSnapshot);
  }

  // item list from snapshot
  List<Item> _itemListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Item(
        category: doc.get('category') ?? '',
        name: doc.get('name') ?? '',
        units: doc.get('units') ?? 0,
        uom: doc.get('uom') ?? '',
        price: doc.get('price') ?? 0,
      );
    }).toList();
  }
}