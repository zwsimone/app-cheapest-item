import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? id;
  DatabaseService([this.id]);

  // collection reference
  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection("items");

  Future addItemData(String category, String name, double units, String uom, double price) async {
    return await itemsCollection.add({
      'Category': category,
      'Name': name,
      'Units': units,
      'UoM': uom,
      'Price': price,
    });
  }

  Future updateItemData(String category, String name, double units, String uom, double price) async {
    return await itemsCollection.doc(id).set({
      'Category': category,
      'Name': name,
      'Units': units,
      'UoM': uom,
      'Price': price,
    });
  }

  // get items stream
  Stream<QuerySnapshot> get items {
    return itemsCollection.snapshots();
  }

}