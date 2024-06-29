import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app/model/course.dart';

class CoursesProvider {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Course>?> getData(String collection) async {
    try {
      QuerySnapshot documentSnapshot =
          await _firestore.collection(collection).get();
      print(documentSnapshot.docs
          .map((e) => Course.fromJson((e.data() as Map<String, dynamic>)))
          .toList());
      return documentSnapshot.docs
          .map((e) => Course.fromJson((e.data() as Map<String, dynamic>)))
          .toList();
    } catch (e) {
      print('Error getting data: $e');
      rethrow;
    }
  }
}
