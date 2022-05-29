import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

class InfoView extends StatefulWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  late final TextEditingController _fullName;
  late final TextEditingController _phoneNumber;

  final ImagePicker _picker = ImagePicker();
  File? image;
  String? errorMessage;

  @override
  void initState() {
    _fullName = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(color: kGreyColor, width: 3.0));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: textInfoTitle,
                    style: TextStyle(
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ],
              ),
            ),
            const Text(
              textInfoSubtitle,
              style: TextStyle(
                color: kDarkGreyColor,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                controller: _fullName,
                decoration: InputDecoration(
                  hintText: textHintFullName,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                  enabledBorder: border,
                  focusedBorder: border,
                ),
                autocorrect: false,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                  hintText: textHintPhoneNumber,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                  enabledBorder: border,
                  focusedBorder: border,
                ),
                autocorrect: false,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            const Text(
              textInfoPhoto,
              style: TextStyle(
                color: kDarkGreyColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: OutlinedButton(
                    onPressed: () async {
                      var temp =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (temp != null) {
                        setState(() {
                          image = File(temp.path);
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kGreyColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(FontAwesomeIcons.images),
                        Text(textChoosePhoto),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.07),
                SizedBox(
                  width: size.width * 0.4,
                  child: OutlinedButton(
                    onPressed: () async {
                      var temp =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (temp != null) {
                        setState(() {
                          image = File(temp.path);
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kGreyColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(FontAwesomeIcons.camera),
                        Text(textTakePhoto),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              height: size.height * 0.3,
              width: size.width * 0.8,
              child: image == null
                  ? null
                  : Image.file(
                      image!,
                      fit: BoxFit.contain,
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
                            color: kErrorColor),
                        Text(errorMessage ?? '',
                            style: const TextStyle(color: kErrorColor)),
                      ],
                    ),
            ),
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {
                  final fullName = _fullName.text;
                  final phoneNumber = _phoneNumber.text;
                  if (image == null || fullName == '' || phoneNumber == '') {
                    setState(() {
                      errorMessage = textErrorMissingFields;
                      devtools.log(errorMessage!);
                    });
                  } else {
                    final user = FirebaseAuth.instance.currentUser!;
                    final storageRef = FirebaseStorage.instance.ref();
                    final imagesRef = storageRef.child('images');
                    final imageRef = imagesRef.child(user.uid);
                    await imageRef.putFile(image!);
                    final imageURL = await imageRef.getDownloadURL();

                    final databaseRef = FirebaseDatabase.instance.ref();
                    final usersRef = databaseRef.child('users');
                    final userRef = usersRef.child(user.uid);
                    await userRef.update({
                      "name": fullName,
                      "phone": phoneNumber,
                      "photo_url": imageURL,
                      "has_info": true,
                    });

                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      gameChoiceRoute,
                      (_) => false,
                    );
                  }
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(kPrimaryColor),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kBlackColor),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                child: const Text(textSignUp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
