import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hse_assassin/constants/constants.dart';

abstract class AssassinState<T extends StatefulWidget> extends State {
  Widget thunderbird_icon(BuildContext context, size) {
    return SizedBox(
      height: size.height * 0.2,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

  Widget loading_menu(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: textLoading,
                  style: TextStyle(
                    color: kCyanColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          const CircularProgressIndicator(
            color: kCyanColor,
          )
        ],
      ),
    );
  }
}
