import 'dart:io';

import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final formKey = GlobalKey<FormState>();
  File _image;
  String profileUrl, name;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (userData != null) {
      if (userData['profilePic'] != "" && userData['profilePic'] != null)
        profileUrl = userData['profilePic'];
      if (userData['name'] != "" && userData['name'] != null)
        name = userData['name'];
    }
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () async {
              PickedFile pickedFile = await picker.getImage(
                  source: ImageSource.gallery, imageQuality: 50);
              File image = File(pickedFile.path);
              setState(() {
                _image = image;
              });
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 5.0,
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (_image != null)
                      ? FileImage(_image)
                      : NetworkImage(
                          (profileUrl == null) ? placeHolderImg : profileUrl,
                        ),
                  fit: BoxFit.cover,
                ),
              ),
              child: (profileUrl == null)
                  ? Center(
                      child: Text(
                        "Upload Pic",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            (name != null) ? name : "Name hasn't been set",
            style: kBaseFont.copyWith(fontSize: 18),
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: Key('name'),
                  initialValue: (name != null) ? name : "",
                  validator: (val) => val.isEmpty ? "Can't be empty" : null,
                  onSaved: (val) => name = val,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                StarterButton.name(
                  btnColor: kPurple,
                  textColor: Colors.white,
                  text: "Update Info",
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      StorageFunction storage = StorageFunction();
                      String url = "";
                      if (_image != null)
                        url = await storage.uploadFile(
                            _image, "/" + user.uid + "/pic.png");
                      if (name != null)
                        userDB.doc(user.uid).update({
                          "profilePic": url,
                          "name": name,
                        });
                      userData['profilePic'] = url;
                      userData['name'] = name;
                      Fluttertoast.showToast(msg: "Uploaded");
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(msg: "Loading Data");
    userDB.doc(user.uid).get().then((value) {
      userData = value.data();
      profileUrl = userData['profilePic'];
      name = userData['name'];
    });
    setState(() {});
  }
}
