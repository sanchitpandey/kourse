import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/course_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseView extends StatelessWidget {
  CourseModel courseModel;
  CourseView({this.courseModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    courseModel.courseImg,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      top: 10,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseModel.title,
                      style: kBaseFont.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      courseModel.desc,
                      style: kBaseFont.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                courseModel.instructorImg,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseModel.instructorName,
                              style: kBaseFont.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Course Instructor",
                              style: kBaseFont.copyWith(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Lectures: " + courseModel.lectures.length.toString(),
                      style: kBaseFont.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StarterButton.name(
                      onPressed: () async {
                        int flag = 0;
                        for (CourseModel i in courses) {
                          if (i.id == courseModel.id) {
                            flag = 1;
                            Fluttertoast.showToast(msg: "Already Enrolled");
                          }
                        }
                        if (flag == 0) {
                          var jsonArray = [];
                          for (CourseModel i in courses) {
                            jsonArray.add(i.id);
                          }
                          jsonArray.add(courseModel.id);
                          userDB.doc(user.uid).update(
                            {
                              "courses": jsonArray,
                            },
                          );
                          Fluttertoast.showToast(msg: "You are now enrolled");
                          Navigator.pop(context);
                        }
                      },
                      btnColor: kPurple,
                      textColor: Colors.white,
                      text: "Enroll",
                      textSize: 16,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
