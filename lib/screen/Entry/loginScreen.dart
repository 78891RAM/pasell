// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recan/http/httpuser.dart';
import 'package:recan/screen/Entry/registerScreen.dart';
import 'package:recan/screen/HomeScreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // var title = "RECANAPP";
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
// login user
  Future<bool> login(String email, String password) async {
    var response = HttpUser().loginUser(email, password);
    return response;
  }

//notification
  void notify() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Logged in Successfully',
          body: 'Pasell For You',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture:
              'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
    );
  }

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: SafeArea(
        child: SingleChildScrollView(
          // ignore: avoid_unnecessary_containers
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "images/logoo.png",
                height: 70,
              ),
              // AssetImage(
              //     "images/logoo.png",

              // ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        key: const Key('email'),
                        // key: const ValueKey("email"),
                        onSaved: (val) {
                          email = val!;
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Email Required"),
                          EmailValidator(errorText: "Invalid Email")
                        ]).call,
                        decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        obscureText: _isObscured,
                        key: const Key('password'),
                        // key: const ValueKey('password'),
                        onSaved: (val) {
                          password = val!;
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Password Required")
                        ]).call,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          labelText: "Password",
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          prefixIcon: const Icon(
                            Icons.key,
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(_isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              // ignore: avoid_print
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color.fromARGB(255, 13, 155, 238)),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      ElevatedButton(
                        key: const Key('login'),
                        // key: const ValueKey('login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 13, 155, 238),
                          // primary: Colors.blueGrey.shade800,
                          minimumSize:
                              Size(MediaQuery.sizeOf(context).width, 52),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            var res = await login(email, password);
                            if (res) {
                              notify();
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType
                                          .leftToRightWithFade,
                                      child: const HomeScreen()));
                              // ignore: use_build_context_synchronously
                              MotionToast.success(
                                      description: const Text("Login success"))
                                  .show(context);
                            } else {
                              // ignore: use_build_context_synchronously
                              MotionToast.error(
                                      description: const Text("Login Failed"))
                                  .show(context);
                            }
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => RegisterPage(),
                              //   ),
                              // );
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const RegisterPage()));
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 13, 155, 238),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
