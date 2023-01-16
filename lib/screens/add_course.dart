import 'dart:io';

import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/course_model.dart';
import 'package:courses/logic/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  static final formKey = GlobalKey<FormState>();
  File _image, _insImg;
  List<File> lectures = [];
  final picker = ImagePicker();
  int lectureNumber = 1;

  pickImageFromGallery() async {
    PickedFile pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    File image = File(pickedFile.path);

    setState(() {
      _image = image;
    });
  }

  pickVideoFromGallery(index) async {
    PickedFile pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
    );

    File video = File(pickedFile.path);

    setState(() {
      if (lectures.length > index) {
        lectures[index] = video;
      } else {
        lectures.add(video);
      }
    });
  }

  String _title, _instructorName, _desc;
  FileImage instructorImageFile;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      Fluttertoast.showToast(
          msg: "Uploading might take a few minutes depending on size",
          toastLength: Toast.LENGTH_LONG);
      String id = courseDB.doc().id;
      StorageFunction storageFunction = StorageFunction();
      String courseImg = await storageFunction.uploadFile(
          _image, user.uid + "/$_title/logo.png");
      String insImg = await storageFunction.uploadFile(
          _insImg, user.uid + "/$_title/instructorImg.png");
      List<String> lectureURLS = [];
      for (int i = 0; i < lectures.length; i++) {
        String url = await storageFunction.uploadFile(
            lectures[i], user.uid + "/$_title/lectures/$i.mp4");
        lectureURLS.add(url);
      }
      CourseModel newCourse = CourseModel(
        _title,
        _desc,
        _instructorName,
        (insImg != null) ? insImg : placeHolderImg,
        (courseImg != null) ? courseImg : placeHolderImg,
        lectureURLS,
        id,
      );
      courses.add(newCourse);
      courseIDs.add(id);
      courseDB.doc(id).set(newCourse.toJSON());
      userDB.doc(user.uid).update({
        "courses": courseIDs,
      });
      Fluttertoast.showToast(msg: "Uploaded");
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: Text(
          "Kourse",
          style: kBaseFont.copyWith(
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Add Course",
                  style: kBaseFont.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      padded(
                        TextFormField(
                          key: Key('title'),
                          decoration: InputDecoration(labelText: 'Course Name'),
                          autocorrect: false,
                          validator: (val) =>
                              val.isEmpty ? 'Title can\'t be empty.' : null,
                          onSaved: (val) => _title = val,
                        ),
                      ),
                      padded(
                        TextFormField(
                          key: Key('desc'),
                          decoration:
                              InputDecoration(labelText: 'Course Description'),
                          autocorrect: false,
                          keyboardType: TextInputType.multiline,
                          validator: (val) => val.isEmpty
                              ? 'Description can\'t be empty.'
                              : null,
                          onSaved: (val) => _desc = val,
                        ),
                      ),
                      padded(
                        TextFormField(
                          key: Key('instructorName'),
                          decoration:
                              InputDecoration(labelText: 'Instructor Name'),
                          autocorrect: false,
                          validator: (val) => val.isEmpty
                              ? 'Instructor Name can\'t be empty.'
                              : null,
                          onSaved: (val) => _instructorName = val,
                        ),
                      ),
                      padded(
                        GestureDetector(
                          onTap: pickImageFromGallery,
                          child: Container(
                            color: Colors.grey.shade200,
                            width: MediaQuery.of(context).size.width - 40,
                            child: (_image == null)
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Center(
                                        child: Text(
                                          "Upload Course Banner",
                                          style: kBaseFont,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  )
                                : Image.file(_image),
                          ),
                        ),
                      ),
                      padded(
                        GestureDetector(
                          onTap: () async {
                            PickedFile pickedFile = await picker.getImage(
                                source: ImageSource.gallery, imageQuality: 50);

                            File image = File(pickedFile.path);

                            setState(() {
                              _insImg = image;
                            });
                          },
                          child: Container(
                            color: Colors.grey.shade200,
                            width: MediaQuery.of(context).size.width - 40,
                            child: (_insImg == null)
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Center(
                                        child: Text(
                                          "Upload Instructor Image",
                                          style: kBaseFont,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  )
                                : Image.file(_insImg),
                          ),
                        ),
                      ),
                      padded(
                        TextFormField(
                          key: Key('lectureNumber'),
                          decoration: InputDecoration(
                              labelText: 'Number of Lectures (Atleast 1)'),
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          validator: (val) => val.isEmpty
                              ? 'Specify number of lectures (atleast 1)'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              lectureNumber = int.parse(val);
                            });
                          },
                        ),
                      ),
                      Column(
                        children: List.generate(
                            (lectureNumber >= 1) ? lectureNumber : 1, (index) {
                          return padded(
                            GestureDetector(
                              onTap: () {
                                pickVideoFromGallery(index);
                              },
                              child: Container(
                                color: Colors.grey.shade200,
                                width: MediaQuery.of(context).size.width - 40,
                                child: (lectures.length <= index)
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Center(
                                            child: Text(
                                              "Upload Lecture Video",
                                              style: kBaseFont,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Center(
                                            child: Text(
                                              "Uploaded, click again to replace",
                                              style: kBaseFont,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StarterButton.name(
                        btnColor: kPurple,
                        textColor: Colors.white,
                        text: "Add Course",
                        textSize: 16,
                        onPressed: validateAndSubmit,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget x) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: x,
    );
  }
}
