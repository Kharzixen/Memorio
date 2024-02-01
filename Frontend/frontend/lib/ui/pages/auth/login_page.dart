import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginPage> {
  String email = "";
  String passwd = "";

  bool loginIncorrect = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/1537636/pexels-photo-1537636.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(115, 0, 0, 0)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
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
              body: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    loginIncorrect = true;
                  }
                  if (state is AuthSuccess) {
                    return context.go("/home");
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Username field can not be empty";
                                        } else if (value.length < 6 ||
                                            value.length > 30) {
                                          return "Please enter a valid username";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Username",
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey))),
                                      onChanged: (val) {
                                        email = val;
                                      },
                                    ),
                                    const SizedBox(height: 35.0),
                                    TextFormField(
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Password field can not be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey))),
                                      onChanged: (val) {
                                        passwd = val;
                                      },
                                    ),
                                    const SizedBox(height: 55.0),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          backgroundColor: Colors.grey.shade700,
                                        ),
                                        child: const Text(
                                          'Log In',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                                LoginRequestedEvent(
                                                    username: email.trim(),
                                                    password: passwd.trim()));
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Forgot Password ? ",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 119, 242, 1),
                                        //backgroundColor: Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 25.0),
                              const Text(
                                "Don't have an account ?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go("/register");
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Color.fromRGBO(24, 119, 242, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Authentication {
  static bool tryLogIn(String email, String passwd) {
    String correctMail = "mellau.mark@gmail.com";
    String correctPasswd = "123456";
    if (correctMail == email && correctPasswd == passwd) {
      return true;
    } else {
      return false;
    }
  }
}
