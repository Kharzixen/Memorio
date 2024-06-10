import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage("assets/pexels-photo-1537636.jpeg"), context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/pexels-photo-1537636.jpeg"),
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
                    "Registration",
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              ),
              body: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is RegistrationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Something went wrong.."),
                    ));
                    usernameController.text = state.username;
                    nameController.text = state.name;
                    emailController.text = state.email;
                    phoneNumberController.text = state.phoneNumber;
                    passwordController.clear();
                    confirmPasswordController.clear();
                  }

                  if (state is RegistrationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Registration successful! Redirecting.."),
                    ));
                    if (context.mounted) {
                      context.go("/login");
                    }
                  }
                },
                builder: (context, state) {
                  if (state is RegistrationLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: usernameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(color: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Username field can not be empty";
                                      } else if (value.length < 6) {
                                        return "Username must be at least 6 characters long";
                                      } else if (value.length > 30) {
                                        return "Username must be at most 30 characters long";
                                      } else if (usernameController.text
                                          .contains(" ")) {
                                        return "Username must be a continuous word, please use \"_\" instead ";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        errorStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                        hintText: "Username",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: nameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        errorStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                        hintText: "Name",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Name field can not be empty";
                                      } else if (value.length < 6) {
                                        return "Name must be at least 6 characters long";
                                      } else if (value.length > 50) {
                                        return "Name must be at most 50 characters long";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        errorStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                        hintText: "Email Address",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email Address field can not be empty";
                                      } else if (value.length < 6 ||
                                          !value.contains("@") ||
                                          !value.contains(".")) {
                                        return "Invalid email address";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: phoneNumberController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                      ),
                                      hintText: "Phone Number",
                                      hintStyle: TextStyle(color: Colors.white),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      final RegExp phoneNumberRegex =
                                          RegExp(r'^\+?[0-9]{1,4}-?[0-9]+$');
                                      if (value == null || value.isEmpty) {
                                        return "Phone number field can not be empty";
                                      } else if (!phoneNumberRegex
                                          .hasMatch(value)) {
                                        return "Invalid phone number";
                                      } else if (!value.contains("+")) {
                                        return "Phone number must be provided with country code";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  // const SizedBox(height: 20.0),
                                  // const DatePicker(title: "pickdate"),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: passwordController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: true,
                                    validator: (value) {
                                      PasswordValidationRegexps
                                          validationRegexps =
                                          PasswordValidationRegexps();
                                      if (value == null || value.isEmpty) {
                                        return "Password field can not be empty";
                                      } else if (value.length < 6) {
                                        return "Password must be at least 6 characters long";
                                      } else if (!validationRegexps
                                          .uppercaseRegex
                                          .hasMatch(value)) {
                                        return "Password must contain at least 1 upper case letter [A-Z]";
                                      } else if (!validationRegexps
                                          .lowercaseRegex
                                          .hasMatch(value)) {
                                        return "Password must contain at least 1 lower case letter [a-z]";
                                      } else if (!validationRegexps.digitRegex
                                          .hasMatch(value)) {
                                        return "Password must contain at least 1 numeric character [0-9]";
                                      } else if (!validationRegexps
                                          .specialCharRegex
                                          .hasMatch(value)) {
                                        return "Password must contain at least 1 special character";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: const TextStyle(
                                        color: Colors.red,
                                      ),
                                      hintText: "Password",
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      suffixIcon: Tooltip(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.85),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        preferBelow: false,
                                        showDuration:
                                            const Duration(seconds: 10),
                                        textStyle: const TextStyle(
                                            color:
                                                Color.fromRGBO(24, 119, 242, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                        message:
                                            "Passwords must contain: \n   • a minimum of 1 lower case letter [a-z] \n   • a minimum of 1 upper case letter [A-Z] \n   • a minimum of 1 numeric character [0-9] \n   • a minimum of 1 special character: !@#\$%^&*(),_.?\":{}|<>",
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: const Icon(
                                          Icons.info,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    style: const TextStyle(color: Colors.white),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        errorMaxLines: 2,
                                        errorStyle: TextStyle(
                                          color: Colors.red,
                                        ),
                                        hintText: "Confirm Password",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    validator: (value) {
                                      print("${passwordController.text}");
                                      if (value == null || value.isEmpty) {
                                        return "Password field can not be empty";
                                      } else if (!(value ==
                                          passwordController.text)) {
                                        return "Passwords do not match";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 40.0),
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
                                        'Register',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                              RegistrationRequestedEvent(
                                                  username:
                                                      usernameController.text,
                                                  email: emailController.text,
                                                  name: nameController.text,
                                                  phoneNumber:
                                                      phoneNumberController
                                                          .text,
                                                  password:
                                                      passwordController.text,
                                                  confirmPassword:
                                                      confirmPasswordController
                                                          .text));
                                        }
                                      },
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
                                            color:
                                                Color.fromRGBO(24, 119, 242, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          )));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordValidationRegexps {
  final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp lowercaseRegex = RegExp(r'[a-z]');
  final RegExp digitRegex = RegExp(r'[0-9]');
  final RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),_.?":{}|<>]');
}
