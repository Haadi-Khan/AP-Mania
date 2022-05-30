import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isPassObscure = true;
  String? errorMessage;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(color: kGreyColor, width: 3.0));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                    child: Image.asset('assets/images/thunderbird.png'),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: textLoginTitle,
                          style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    textLoginSubtitle,
                    style: TextStyle(
                      color: kDarkGreyColor,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.8,
                    child: errorMessage == null
                        ? null
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.circleExclamation,
                                  color: kOrangeColor),
                              Text(errorMessage ?? '',
                                  style: const TextStyle(color: kOrangeColor)),
                            ],
                          ),
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        style: generalText,
                        keyboardType: TextInputType.emailAddress,
                        keyboardAppearance: Brightness.dark),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextField(
                        controller: _password,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          enabledBorder: border,
                          focusedBorder: border,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassObscure = !isPassObscure;
                              });
                            },
                            icon: isPassObscure
                                ? const FaIcon(FontAwesomeIcons.eyeSlash,
                                    size: 17, color: kWhiteColor)
                                : const FaIcon(FontAwesomeIcons.eye,
                                    size: 17, color: kWhiteColor),
                          ),
                        ),
                        obscureText: isPassObscure,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardAppearance: Brightness.dark,
                        style: generalText),
                  ),
                ],
              ),
              Positioned(
                bottom: size.height * 0.04,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: OutlinedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            String route;
                            final userRef = FirebaseDatabase.instance.ref(
                                'users/${FirebaseAuth.instance.currentUser!.uid}');
                            final event = await userRef.once();
                            final userSnapshot = event.snapshot;
                            final hasInfo =
                                userSnapshot.child('has_info').value;
                            final hasChosenGame =
                                userSnapshot.child('has_chosen_game').value;
                            if (hasChosenGame == true) {
                              route = homeRoute;
                            } else if (hasInfo == true) {
                              route = gameChoiceRoute;
                            } else {
                              route = infoRoute;
                            }
                            if (!mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              route,
                              (_) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            devtools.log(e.code);
                            if (e.code == 'user-not-found' || password == '') {
                              setState(() {
                                errorMessage = textErrorWrongEmail;
                              });
                              _email.clear();
                            } else if (e.code == 'wrong-password') {
                              setState(() {
                                errorMessage = textErrorWrongPassword;
                              });
                              _password.clear();
                            }
                          }
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(kBlackColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kWhiteColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none)),
                        child: const Text(textLogin),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: textNoAcc,
                            style: generalText,
                          ),
                          TextSpan(
                            text: textSignUp,
                            style: redOptionText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  registerRoute,
                                  (_) => false,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
