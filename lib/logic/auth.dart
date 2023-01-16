import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'course_model.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
  void getCourses();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void getCourses() {
    userDB.doc(user.uid).get().then((DocumentSnapshot value) {
      courseIDs = ((value.data() as Map<String, dynamic>)['courses']);
      courses = [];
      for (String id in courseIDs) {
        courseDB.doc(id).get().then((value) {
          CourseModel x = CourseModel.fromJson(value.data());
          courses.add(x);
        });
      }
    });
  }

  Future<String> signIn(String email, String password) async {
    user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> currentUser() async {
    user = _firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
