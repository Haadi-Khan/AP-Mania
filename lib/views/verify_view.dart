import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

enum MenuAction { logout }

class VerifyView extends StatefulWidget {
  const VerifyView({Key? key}) : super(key: key);

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarColor,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: textRegisterSuccess,
                          style: TextStyle(
                              color: kBlueGreenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.15),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: textVerification1,
                          style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: textVerification2,
                          style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: textVerification3,
                          style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.05,
              right: size.width * 0.05,
              child: PopupMenuButton<MenuAction>(
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogoutDialog(context);
                      if (shouldLogout) {
                        await FirebaseAuth.instance.signOut();
                        if (!mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          welcomeRoute,
                          (_) => false,
                        );
                      }
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Log out'),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(textLogout),
        content: const Text(textLogoutCheck),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(textCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(textLogout),
          )
        ],
      );
    },
  ).then(((value) => value ?? false));
}
