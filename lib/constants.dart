import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/logic/auth.dart';
import 'package:courses/logic/course_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//Color kPurple = Color(0xFF581b98);
Color kLightPurple = Color(0xFF3d5af1);
Color kPurple = Color(0xFF0e153a);
Color kYellow = Color(0xFFfaee1c);

TextStyle kBaseFont = TextStyle(fontFamily: "DINRoundPro");

BaseAuth auth;
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference userDB = firestore.collection("users"),
    courseDB = firestore.collection("courses");
User user;
var pageIndex = 0;
userState userType = userState.STUDENT;
Reference firebaseStorage = FirebaseStorage.instance.ref();
Map<String, dynamic> userData;

List<CourseModel> discoveredCourses = [];
List<CourseModel> courses = [];
List<dynamic> courseIDs = [];
String placeHolderImg =
    "https://cdn141.picsart.com/305306343606201.jpg?type=webp&to=crop&r=256";

enum authState {
  LOGIN,
  SIGNUP,
}
enum userState {
  INSTRUCTOR,
  STUDENT,
}
