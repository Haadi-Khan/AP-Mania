import 'package:flutter/material.dart';
import 'package:hse_assassin/constants/constants.dart';

class HintsPage extends StatelessWidget {
  const HintsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Hints Page",
                style: heading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
