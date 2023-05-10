import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';

abstract class AssassinState<T extends StatefulWidget> extends State {
  Widget thunderbirdIcon(BuildContext context, size) {
    return SizedBox(
      height: size.height * 0.2,
      child: Image.asset('assets/images/thunderbird.png'),
    );
  }

  Widget thunderbirdIconLarge(BuildContext context, size) {
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

  Widget errorIcon(Size size, String? errorMessage) {
    return SizedBox(
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

  Widget thunderbirdIconLarge(BuildContext context, size) {
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
}
