import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hse_assassin/constants/routes.dart';
import 'package:hse_assassin/constants/constants.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBlackColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarColorMain,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/thunderbird.png"),
              SizedBox(height: size.height * 0.1),
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.04,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (_) => false,
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(kBlackColor),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kWhiteColor),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                  ),
                  child: const Text(textStart),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.04,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kGreyColor),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                  ),
                  child: const Text(
                    textLogin,
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
