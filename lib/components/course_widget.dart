import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/course_model.dart';
import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  CourseModel courseModel;
  String buttonText = "View Course";
  VoidCallback onClick = () {};

  CourseWidget({
    this.courseModel,
    this.buttonText,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 3.0,
            offset: Offset(
              0.0,
              3.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              courseModel.courseImg,
              width: MediaQuery.of(context).size.width - 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseModel.title,
                    style: kBaseFont.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    courseModel.desc,
                    style: kBaseFont.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.green,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StarterButton.name(
                    text: buttonText,
                    btnColor: kPurple.withOpacity(.8),
                    textColor: Colors.white,
                    onPressed: onClick,
                    textSize: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
