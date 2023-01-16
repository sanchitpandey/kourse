import 'package:courses/components/button.dart';
import 'package:courses/constants.dart';
import 'package:courses/screens/onboarding.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  authState state;
  VoidCallback onSignIn;

  Authentication.name(this.state, this.onSignIn);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  authState _authState;
  String title;

  @override
  void initState() {
    super.initState();
    _authState = widget.state;
    auth.currentUser().then(
      (value) {
        if (user != null) widget.onSignIn();
      },
    );
  }

  String _authHint = '';

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
      try {
        if (_authState == authState.LOGIN) {
          await auth.signIn(_email, _password);
        } else {
          await auth.createUser(_email, _password);
          await userDB.doc(user.uid).set(
            {
              "name": user.displayName,
              "email": _email,
              "uid": user.uid,
              "type": userType.toString().split('.').last,
              "courses": [],
            },
          );
        }
        setState(() {
          _authHint = 'Signed In\n';
        });
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _authState = authState.SIGNUP;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _authState = authState.LOGIN;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
      padded(
        child: TextFormField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
          onSaved: (val) => _email = val,
        ),
      ),
      padded(
        child: TextFormField(
          key: Key('password'),
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          autocorrect: false,
          validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
          onSaved: (val) => _password = val,
        ),
      ),
    ];
  }

  List<Widget> typeButtons() {
    if (_authState == authState.LOGIN)
      return [
        SizedBox(
          height: 20,
        ),
      ];
    return [
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  userType = userState.STUDENT;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: (userType == userState.STUDENT)
                      ? Colors.orange
                      : Colors.orange.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text("Student"),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  userType = userState.INSTRUCTOR;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: (userType == userState.INSTRUCTOR)
                      ? Colors.orange
                      : Colors.orange.shade200,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text("Instructor"),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 18,
      ),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_authState) {
      case authState.LOGIN:
        return [
          StarterButton.name(
            text: 'Log in',
            btnColor: kPurple,
            textColor: Colors.white,
            onPressed: validateAndSubmit,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(onPressed: moveToRegister, child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Need an account? ",
                  style: kBaseFont.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: "Register",
                  style: kBaseFont.copyWith(
                    color: kLightPurple,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),),
        ];
      case authState.SIGNUP:
        return [
          StarterButton.name(
            text: 'Create account',
            btnColor: kPurple,
            textColor: Colors.white,
            onPressed: validateAndSubmit,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Have an account? ",
                    style: kBaseFont.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "Log in",
                    style: kBaseFont.copyWith(
                      color: kLightPurple,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: moveToLogin,
          ),
        ];
    }
    return null;
  }

  Widget hintText() {
    return Container(
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_authState == authState.LOGIN)
      title = "Log In";
    else
      title = "Sign Up";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Onboarding(),
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: usernameAndPassword() +
                              typeButtons() +
                              submitWidgets(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              hintText()
            ],
          ),
        ),
      ),
    );
  }
}
