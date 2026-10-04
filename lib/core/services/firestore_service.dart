import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garrib_app/data/models/product_model.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  Stream<List<ProductModel>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Stream<List<ProductModel>> streamProductsByCategory(String categoryName) {
    return _db
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
}