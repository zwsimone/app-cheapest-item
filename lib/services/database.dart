import 'package:cheapest_item_calculator/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? id;

  DatabaseService([this.id]);

  // collection reference
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection("items");
  final CollectionReference dashboardCollection =
      FirebaseFirestore.instance.collection("dashboard");

  Future updateItemData(String category, String name, double units, String uom,
      double price, double priceperuom) async {
    return await itemsCollection.doc(id).set({
      'category': category,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
      'priceperuom': priceperuom,
    });
  }

  Future updateDashboardItemData(String category, String name, double units,
      String uom, double price, double priceperuom) async {
    return await dashboardCollection.doc(id).set({
      'category': category,
      'name': name,
      'units': units,
      'uom': uom,
      'price': price,
      'priceperuom': priceperuom,
    });
  }

  Future clearCollection(String collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future deleteDocument() async {
    return dashboardCollection.doc(id).delete();
  }

  Future<bool> checkDocument() async {
    bool present = false;

    List<Item> items = _itemListfromSnapshot(await itemsCollection.get());

    for (Item item in items) {
      if (item.barcode.toString() == id) {
        return present = true;
      }
    }

    return present;
  }

  Future<Item> getDocument() async {
    Item emptyItem = Item(
        barcode: int.parse(id!),
        category: "",
        name: "",
        units: 0,
        uom: "",
        price: 0,
        priceperuom: 0);

    List<Item> items = _itemListfromSnapshot(await itemsCollection.get());

    for (Item item in items) {
      if (item.barcode.toString() == id) {
        return item;
      }
    }

    return emptyItem;
  }

  // get items stream
  Stream<List<Item>>? get items {
    return itemsCollection.snapshots().map(_itemListfromSnapshot);
  }

  // item list from snapshot
  List<Item> _itemListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Item(
        barcode: int.parse(doc.id),
        category: doc.get('category') ?? '',
        name: doc.get('name') ?? '',
        units: doc.get('units') ?? 0,
        uom: doc.get('uom') ?? '',
        price: doc.get('price') ?? 0,
        priceperuom: doc.get('priceperuom') ?? 0,
      );
    }).toList();
  }

  // get items stream
  Stream<List<Item>>? get dashboardItems {
    return dashboardCollection.snapshots().map(_dasboardListfromSnapshot);
  }

  // item list from snapshot
  List<Item> _dasboardListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Item(
        barcode: int.parse(doc.id),
        category: doc.get('category') ?? '',
        name: doc.get('name') ?? '',
        units: doc.get('units') ?? 0,
        uom: doc.get('uom') ?? '',
        price: doc.get('price') ?? 0,
        priceperuom: doc.get('priceperuom') ?? 0,
      );
    }).toList();
  }
}
