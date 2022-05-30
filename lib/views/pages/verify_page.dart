import 'package:flutter/widgets.dart';
import 'package:hse_assassin/constants/constants.dart';

class VerifyPage extends StatelessWidget {
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
        SizedBox(
          height: size.height * 0.4,
          child: Image.asset('assets/images/thunderbird.png'),
        ),
      ],
    );
  }
}
