import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';

abstract class AssassinState<T extends StatefulWidget> extends State {
  Widget thunderbirdIcon(BuildContext context, size) {
    return SizedBox(
      height: size.height * 0.2,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

<<<<<<< HEAD
  Widget thunderbirdIconLarge(BuildContext context, size) {
=======
  Widget thunderbird_icon_large(BuildContext context, size) {
>>>>>>> d8a221d157e4e22ffaab6c3dced52610a731cd25
    return SizedBox(
      height: size.height * 0.4,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

  Widget loadingMenu(BuildContext context) {
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
<<<<<<< HEAD

=======
>>>>>>> d8a221d157e4e22ffaab6c3dced52610a731cd25
  Widget errorIcon(String? errorMessage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(FontAwesomeIcons.circleExclamation, color: kOrangeColor),
        Text(errorMessage ?? '', style: generalText),
      ],
    );
  }
}

abstract class AssassinStatelessWidget extends StatelessWidget {
  const AssassinStatelessWidget({Key? key}) : super(key: key);

  Widget thunderbirdIcon(BuildContext context, size) {
    return SizedBox(
      height: size.height * 0.2,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

<<<<<<< HEAD
  Widget thunderbirdIconLarge(BuildContext context, size) {
=======
  Widget thunderbird_icon_large(BuildContext context, size) {
>>>>>>> d8a221d157e4e22ffaab6c3dced52610a731cd25
    return SizedBox(
      height: size.height * 0.4,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

  Widget loadingMenu(BuildContext context) {
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

  Widget errorIcon(String? errorMessage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FaIcon(FontAwesomeIcons.circleExclamation, color: kOrangeColor),
        Text(errorMessage ?? '', style: generalText),
      ],
    );
  }
}
