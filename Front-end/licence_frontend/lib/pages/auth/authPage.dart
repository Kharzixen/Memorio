import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Valami név"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: screenHeight,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                ),
                Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 70),
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50)),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    return context.go("/login");
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    color: Colors.grey.shade400,
                  )),
                  Text(
                    " or ",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.grey.shade400,
                  )),
                ]),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 70),
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50)),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    context.go("/register");
                  },
                ),
                SizedBox(
                  height: 100,
                ),
                TextButton(
                    onPressed: () {}, child: Text("Terms and Conditions"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
