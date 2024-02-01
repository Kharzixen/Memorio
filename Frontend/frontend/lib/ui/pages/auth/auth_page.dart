import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/1942489/pexels-photo-1942489.jpeg?cs=srgb&dl=hand-holding-person-1942489.jpg&fm=jpg"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: const BoxDecoration(color: Color.fromARGB(76, 0, 0, 0)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Memorio",
                    style: GoogleFonts.singleDay(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    "\"Preserving Precious Moments\"",
                    style: GoogleFonts.alegreya(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      color: const Color.fromARGB(255, 222, 222, 222),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 10, 35, 20),
                    child: SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.grey.shade700,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () {
                          return context.go("/login");
                        },
                      ),
                    ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 35, 10),
                    child: SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.grey.shade700,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () {
                          return context.go("/register");
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                          color: Color.fromRGBO(24, 119, 242, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
