import 'package:flutter/widgets.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';

/// This page is shown when the user is not verified.
class VerifyPage extends AssassinStatelessWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: const TextSpan(
              text: "You are not verified.",
              style: smallerHeading,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: const TextSpan(
              text: "Your coordinator will admit you soon.",
              style: smallerHeading,
            ),
          ),
        ),
        super.thunderbirdIconLarge(context, size),
      ],
    );
  }
}
