import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/4993156/pexels-photo-4993156.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(115, 0, 0, 0)),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              //extendBodyBehindAppBar: true,
              appBar: AppBar(
                leadingWidth: 50,
                toolbarHeight: 35,
                iconTheme: IconThemeData(
                  color: Colors.grey.shade200,
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Email Address",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey))),
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 40.0),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: Colors.grey.shade700,
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {},
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 40.0),
                          const Text(
                            "Already have an account ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                              onPressed: () {
                                context.go("/login");
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 119, 242, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
