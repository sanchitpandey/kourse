import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/logic/auth.dart';
import 'package:courses/screens/home.dart';
import 'package:courses/screens/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    auth = Auth();
    auth.currentUser().then(
      (value) {
        if (user != null)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
      },
    );
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * .17,
                ),
                SvgPicture.asset(
                  "assets/study.svg",
                  height: size.height * .22,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Kourse",
                  style: kBaseFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Learn a skill for free.\nForever.",
                  style: TextStyle(
                    fontFamily: "DINRoundPro",
                    fontSize: 21,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                StarterButton.name(
                  text: "Get Started",
                  btnColor: kPurple,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authentication.name(
                        authState.SIGNUP,
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                StarterButton.name(
                  text: "I already have an account",
                  btnColor: Colors.white,
                  textColor: kPurple,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authentication.name(
                        authState.LOGIN,
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
