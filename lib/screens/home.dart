import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/constants.dart';
import 'package:courses/screens/add_course.dart';
import 'package:courses/screens/explore.dart';
import 'package:courses/screens/my_courses.dart';
import 'package:courses/screens/onboarding.dart';
import 'package:courses/screens/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget getPage() {
    switch (pageIndex) {
      case 0:
        return MyCoursePage();
        break;
      case 1:
        return (userType == userState.INSTRUCTOR) ? Profile() : Explore();
        break;
      case 2:
        return Profile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Onboarding(),
                ),
              );
            },
            child: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        title: Text(
          "Kourse",
          style: kBaseFont.copyWith(
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: getPage(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: kPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        showUnselectedLabels: false,
        iconSize: 26,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          if (userType == userState.STUDENT)
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Explore",
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
      floatingActionButton: (userType == userState.INSTRUCTOR)
          ? FloatingActionButton(
              backgroundColor: kPurple,
              onPressed: () {
                // Add course
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCourse(),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            )
          : Container(),
    );
  }

  @override
  void initState() {
    setState(() {
      auth.getCourses();
    });
    userDB.doc(user.uid).get().then((DocumentSnapshot value) {
      final data = value.data() as Map<String, dynamic>;
      if (data['type'] == "INSTRUCTOR")
        userType = userState.INSTRUCTOR;
      else
        userType = userState.STUDENT;
    });
    userDB.snapshots().listen((event) {
      setState(() {});
    });
  }
}
