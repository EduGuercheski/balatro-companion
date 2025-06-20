import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getItemsForCategory(String collectionName) async {
    try {
      final querySnapshot = await _db.collection(collectionName).get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      final items = querySnapshot.docs.map((doc) => doc.data()).toList();
      return items;

    } catch (e) {
      // Em um app real, você usaria um sistema de log mais robusto
      print('Erro ao buscar dados: $e');
      // Relança o erro para que o FutureBuilder possa tratá-lo
      rethrow;
    }
  }
}