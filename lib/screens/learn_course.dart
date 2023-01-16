import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses/components/video_view.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/course_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CourseView extends StatefulWidget {
  CourseModel courseModel;
  CourseView({this.courseModel});

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  List<dynamic> lectureURLS = [];

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
                    widget.courseModel.courseImg,
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
                      widget.courseModel.title,
                      style: kBaseFont.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.courseModel.desc,
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
                                widget.courseModel.instructorImg,
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
                              widget.courseModel.instructorName,
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
                      "Lectures: " +
                          widget.courseModel.lectures.length.toString(),
                      style: kBaseFont.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: List.generate(
                        lectureURLS.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lecture " + (index + 1).toString() + ":",
                              style: kBaseFont.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            VideoView(
                              videoPlayerController:
                                  VideoPlayerController.network(
                                lectureURLS[index],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  void initState() {
    super.initState();
    courseDB.doc(widget.courseModel.id).get().then((DocumentSnapshot value) {
      final data = value.data() as Map<String, dynamic>;
      lectureURLS = (data['lectures']);
      setState(() {});
    });
  }
}
