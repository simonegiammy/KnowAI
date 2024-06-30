import 'package:KnowAI/data_provider/auth_provider.dart';
import 'package:KnowAI/model/course.dart';
import 'package:KnowAI/model/lesson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CoursesProvider {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Course>?> getCourses(String collection) async {
    try {
      QuerySnapshot documentSnapshot =
          await _firestore.collection(collection).get();

      return documentSnapshot.docs
          .map((e) => Course.fromJson((e.data() as Map<String, dynamic>)))
          .toList();
    } catch (e) {
      print('Error getting data: $e');
    }
    return null;
  }

  static Future<List<Course>?> getSavedCourses() async {
    try {
      DocumentReference docRef = _firestore
          .collection('saved_courses')
          .doc(AuthenticationProvider.getCurrentUser()!.uid);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        List<dynamic> savedCourses = (documentSnapshot.data()
            as Map<String, dynamic>)['savedCourses'] as List<dynamic>;
        if (savedCourses.isEmpty) {
          return [];
        }
        // Inizializza una lista vuota per i corsi salvati
        List<Course> courses = [];

        // Effettua una query per ogni ID salvato
        for (String courseId in savedCourses) {
          QuerySnapshot querySnapshot = await _firestore
              .collection("tutorial_titles")
              .where('id', isEqualTo: courseId)
              .get();

          // Aggiungi i corsi ottenuti alla lista dei corsi salvati
          courses.addAll(querySnapshot.docs
              .map((e) => Course.fromJson(e.data() as Map<String, dynamic>))
              .toList());
        }

        return courses;
      }
      return null;
    } catch (e) {
      print('Error getting data: $e');
    }
    return null;
  }

  static Future<List<String>?> getCategories() async {
    try {
      QuerySnapshot documentSnapshot =
          await _firestore.collection("tutorial_titles").get();
      List<String> categories = [];
      for (DocumentSnapshot ds in documentSnapshot.docs) {
        Map data = ds.data() as Map<String, dynamic>;
        if (data.containsKey("category")) {
          if (!categories.contains(data['category'])) {
            categories.add(data['category']);
          }
        }
      }
      return categories;
    } catch (e) {
      print('Error getting data: $e');
    }
    return null;
  }

  static Future<void> addOrRemoveSavedCourse(String courseId) async {
    try {
      DocumentReference docRef = _firestore
          .collection('saved_courses')
          .doc(AuthenticationProvider.getCurrentUser()!.uid);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        List<dynamic> savedCourses = (documentSnapshot.data()
            as Map<String, dynamic>)['savedCourses'] as List<dynamic>;

        if (savedCourses.contains(courseId)) {
          savedCourses.remove(courseId);
        } else {
          savedCourses.add(courseId);
        }

        await docRef.update({'savedCourses': savedCourses});
      } else {
        await docRef.set({
          'savedCourses': [courseId]
        });
      }
    } catch (e) {
      print('Error updating saved courses: $e');
    }
  }

  static Future<bool?> isSaved(String courseId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('saved_courses')
          .doc(
            AuthenticationProvider.getCurrentUser()!.uid,
          )
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> savedCourses = (documentSnapshot.data()
            as Map<String, dynamic>)['savedCourses'] as List<dynamic>;

        if (savedCourses.contains(courseId)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error getting data: $e');
    }
    return null;
  }

  static Future<void> addOrRemoveCompletedLesson(
      String lessonId, String courseId) async {
    try {
      DocumentReference docRef = _firestore
          .collection('saved_courses')
          .doc(AuthenticationProvider.getCurrentUser()!.uid);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        List<dynamic> completedLessons = (documentSnapshot.data()
            as Map<String, dynamic>)['completedLessons'] as List<dynamic>;

        if (completedLessons.contains("$courseId:$lessonId")) {
          completedLessons.remove("$courseId:$lessonId");
        } else {
          completedLessons.add("$courseId:$lessonId");
        }

        await docRef.update({'completedLessons': completedLessons});
      } else {
        await docRef.set({
          'completedLessons': ["$courseId:$lessonId"]
        });
      }
    } catch (e) {
      print('Error updating saved courses: $e');
    }
  }

  static Future<bool?> isCompleted(String lessonId, String courseId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('saved_courses')
          .doc(
            AuthenticationProvider.getCurrentUser()!.uid,
          )
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> savedCourses = (documentSnapshot.data()
            as Map<String, dynamic>)['completedLessons'] as List<dynamic>;

        if (savedCourses.contains("$courseId:$lessonId")) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error getting data: $e');
    }
    return null;
  }

  static Future<String?> createCourse(Course c) async {
    try {
      return (await _firestore.collection("tutorial_titles").add(c.toJson()))
          .id;
    } catch (e) {
      print('Error getting data: $e');
      return null;
    }
  }

  static Future<bool> createLessons(
      List<Lesson> lessons, String courseId) async {
    try {
      Map<String, dynamic> map = {"lessons": []};
      for (Lesson l in lessons) {
        map['lessons'].add(l.toJson());
      }
      _firestore.collection("tutorial_lessons").doc(courseId).set(map);

      return true;
    } catch (e) {
      print('Error getting data: $e');
      return false;
    }
  }

  static Future<bool> updateLesson(Lesson lesson, String courseId) async {
    try {
      // Ottieni il documento corrente
      DocumentSnapshot docSnapshot =
          await _firestore.collection("tutorial_lessons").doc(courseId).get();

      // Controlla se il documento esiste
      if (docSnapshot.exists) {
        // Ottieni i dati del documento come mappa
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Ottieni l'array di lezioni dal documento
        List<dynamic> lessons = data['lessons'];

        // Controlla che l'ID della lezione sia valido
        if (lesson.id! - 1 < lessons.length) {
          // Sostituisci l'elemento nell'array alla posizione specificata
          lessons[lesson.id! - 1] = lesson.toJson();

          // Aggiorna il documento con l'array modificato
          await _firestore
              .collection("tutorial_lessons")
              .doc(courseId)
              .update({'lessons': lessons});

          return true;
        } else {
          print('Invalid lesson ID');
          return false;
        }
      } else {
        print('Document does not exist');
        return false;
      }
    } catch (e) {
      print('Error getting data: $e');
      return false;
    }
  }

  static Future<List<Lesson>?> getLessons(String courseId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection("tutorial_lessons").doc(courseId).get();
      List maps = (documentSnapshot.data() as Map<String, dynamic>)['lessons'];
      return maps.map((e) => Lesson.fromJson(e)).toList();
    } catch (e) {
      print('Error getting data: $e');
      rethrow;
    }
    return null;
  }
}
