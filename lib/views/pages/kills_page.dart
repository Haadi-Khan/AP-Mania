import 'package:flutter/material.dart';
import 'package:hse_assassin/constants/constants.dart';

class KillsPage extends StatelessWidget {
  const KillsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(text: 'Kill Page', style: myBoldStyle),
        ),
      ],
    );
  }
}
