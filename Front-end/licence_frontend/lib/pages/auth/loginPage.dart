import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:licence_frontend/services/authenticate.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";
  String passwd = "";

  bool loginIncorrect = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email address field can't be empty";
                    } else if (!value.contains("@") || value.length < 5) {
                      return "Please enter a valid email address";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  onChanged: (val) {
                    email = val;
                  },
                ),
                SizedBox(height: 35.0),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password field can't be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  onChanged: (val) {
                    passwd = val;
                  },
                ),
                loginIncorrect
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Column(
                          children: [
                            Text(
                              "❗Incorrect email address or password",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Please try again",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 55.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50)),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    context.go("/home");

                    if (_formKey.currentState!.validate()) {
                      print("${email} - ${passwd}");
                      if (Authentication.TryLogIn(email, passwd)) {
                        context.go("/home");
                      } else {
                        setState(() {
                          loginIncorrect = true;
                        });
                        ;
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password ? ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Divider(
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 40.0),
                Text(
                  "Don't have an account ?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      context.go("/register");
                    },
                    child: Text("Register"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
