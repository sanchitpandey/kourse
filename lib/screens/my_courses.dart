import 'package:courses/components/course_widget.dart';
import 'package:courses/constants.dart';
import 'package:courses/screens/learn_course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCoursePage extends StatefulWidget {
  @override
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    auth.getCourses();
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
    });
    _refreshController.refreshCompleted();
  }

  void _onLoad() async {
    auth.getCourses();
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "My Courses",
          style: kBaseFont.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(children: List.generate(
          courses.length,
              (index) {
            return CourseWidget(
              courseModel: courses[index],
              buttonText: "Learn Course",
              onClick: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseView(
                    courseModel: courses[index],
                  ),
                ),
              ),
            );
          },
        ),),
        /*SmartRefresher(controller: _refreshController,
        enablePullDown: true,
          onLoading: _onLoad,
          onRefresh: _onRefresh,

          child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (BuildContext context, int index) {
          return CourseWidget(
          courseModel: courses[index],
          buttonText: "Learn Course",
          onClick: () => Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => CourseView(
          courseModel: courses[index],
          ),
          ),
          ),
          );
          },
          ),),*/
      ],
    );
  }
}

