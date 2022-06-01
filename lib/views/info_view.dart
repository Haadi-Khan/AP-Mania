import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/util/google_drive.dart';
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
      backgroundColor: kBlackColor,
      appBar: AppBar(
        backgroundColor: kBlackColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            loginRoute,
            (_) => false,
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarColorMain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: textInfoTitle,
                    style: heading,
                  ),
                ],
              ),
            ),
            const Text(
              textInfoSubtitle,
              style: hintText,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                  controller: _fullName,
                  decoration: InputDecoration(
                    hintStyle: hintText,
                    hintText: textHintFullName,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  style: generalText,
                  autocorrect: false,
                  keyboardAppearance: Brightness.dark),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                    hintStyle: hintText,
                    hintText: textHintPhoneNumber,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  autocorrect: false,
                  style: generalText,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.dark),
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
                color: kGreyColor,
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
                        final imageFile = File(temp.path);
                        if (imageFile.lengthSync() < 3000000) {
                          setState(() {
                            image = imageFile;
                            errorMessage = null;
                          });
                        } else {
                          setState(() {
                            errorMessage = '  File size must be < 3MB';
                          });
                        }
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
                        FaIcon(FontAwesomeIcons.images, color: kWhiteColor),
                        Text(textChoosePhoto, style: generalText),
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
                        final imageFile = File(temp.path);
                        if (imageFile.lengthSync() < 3000000) {
                          setState(() {
                            image = imageFile;
                            errorMessage = null;
                          });
                        } else {
                          setState(() {
                            errorMessage = '  File size must be < 3MB';
                          });
                        }
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
                        FaIcon(FontAwesomeIcons.camera, color: kWhiteColor),
                        Text(textTakePhoto, style: generalText),
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
                            color: kOrangeColor),
                        Text(errorMessage ?? '',
                            style: const TextStyle(color: kOrangeColor)),
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
                  } else if (phoneNumber.length < 10) {
                    setState(() {
                      errorMessage = '  Invalid phone number';
                      devtools.log(errorMessage!);
                    });
                  } else {
                    final user = FirebaseAuth.instance.currentUser!;

                    final imageURL = await uploadFileToGoogleDrive(image!);

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
                        MaterialStateProperty.all<Color>(kBlackColor),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kWhiteColor),
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
