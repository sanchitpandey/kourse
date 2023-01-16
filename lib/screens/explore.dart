import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/components/course_widget.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/course_model.dart';
import 'package:courses/screens/view_course.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  var statement = "courses";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          discoveredCourses.length.toString() + " $statement found",
          style: kBaseFont.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: List.generate(discoveredCourses.length, (index) {
            return CourseWidget(
              courseModel: discoveredCourses[index],
              buttonText: "View Course",
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseView(
                      courseModel: discoveredCourses[index],
                    ),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
            );
          }),
        ),
      ],
    );
  }

  @override
  void initState() {
    courseDB.get().then((value) {
      discoveredCourses = [];
      for (DocumentSnapshot i in value.docs) {
        CourseModel x = CourseModel.fromJson(i.data());
        setState(() {
          discoveredCourses.add(x);
        });
      }
      statement = (discoveredCourses.length == 1) ? "course" : "courses";
    });
  }
}
