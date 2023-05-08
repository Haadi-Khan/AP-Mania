import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/util/google_drive.dart';
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

/// Allow user to update their information.
class EditView extends StatefulWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  AssassinState<EditView> createState() => _EditViewState();
}

class _EditViewState extends AssassinState<EditView> {
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
            homeRoute,
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
                    text: "Edit Profile",
                    style: heading,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            nameInput(size, border),
            SizedBox(
              height: size.height * 0.01,
            ),
            phoneInput(size, border),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              height: size.height * 0.01,
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
                galleryUpload(size),
                SizedBox(width: size.width * 0.07),
                cameraUpload(size),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            imagePreview(size),
            SizedBox(
              height: size.height * 0.05,
              width: size.width * 0.8,
              child:
                  errorMessage == null ? null : super.errorIcon(errorMessage),
            ),
            submissionButton(size, context),
          ],
        ),
      ),
    );
  }

  SizedBox nameInput(Size size, OutlineInputBorder border) {
    return SizedBox(
      width: size.width * 0.8,
      child: FutureBuilder(
          future: FirebaseDatabase.instance.ref().child('users').get(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              DataSnapshot values = snapshot.data as DataSnapshot;
              final user = FirebaseAuth.instance.currentUser!;
              String name =
                  values.child(user.uid).child('name').value as String;
              _fullName.text = name;
            }

            return TextField(
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
              keyboardAppearance: Brightness.dark,
              onChanged: (value) => {},
            );
          }),
    );
  }

  SizedBox phoneInput(Size size, OutlineInputBorder border) {
    return SizedBox(
      width: size.width * 0.8,
      child: FutureBuilder(
          future: FirebaseDatabase.instance.ref().child('users').get(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              DataSnapshot values = snapshot.data as DataSnapshot;
              final user = FirebaseAuth.instance.currentUser!;
              String phone =
                  values.child(user.uid).child('phone').value as String;
              _phoneNumber.text = phone;
            }
            return TextField(
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
                keyboardAppearance: Brightness.dark);
          }),
    );
  }

  Future<void> cropImage(File file) async {
    final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (cropped != null) {
      setState(() {
        image = File(cropped.path);
      });
    }
  }

  SizedBox galleryUpload(Size size) {
    return SizedBox(
      width: size.width * 0.4,
      child: OutlinedButton(
        onPressed: () async {
          try {
            var temp = await _picker.pickImage(source: ImageSource.gallery);
            if (temp != null) {
              final imageFile = File(temp.path);
              cropImage(imageFile);
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
          } catch (e) {
            setState(() {
              errorMessage = '  Image is corrupt';
            });
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.images, color: kWhiteColor),
            Text(textChoosePhoto, style: generalText),
          ],
        ),
      ),
    );
  }

  SizedBox cameraUpload(Size size) {
    return SizedBox(
      width: size.width * 0.4,
      child: OutlinedButton(
        onPressed: () async {
          var temp = await _picker.pickImage(source: ImageSource.camera);
          if (temp != null) {
            final imageFile = File(temp.path);
            cropImage(imageFile);
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
          backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.camera, color: kWhiteColor),
            Text(textTakePhoto, style: generalText),
          ],
        ),
      ),
    );
  }

  SizedBox imagePreview(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      width: size.width * 0.8,
      child: image == null
          ? null
          : Image.file(
              image!,
              fit: BoxFit.contain,
            ),
    );
  }

  SizedBox submissionButton(Size size, BuildContext context) {
    return SizedBox(
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
            print(fullName);
            await userRef.update({
              "name": fullName,
              "phone": phoneNumber,
              "photo_url": imageURL,
            });

            // sync the user's info in 'user's and the user's profile in their current game
            final game =
                await userRef.child('game').get().then((value) => value.value);
            final gameRef =
                FirebaseDatabase.instance.ref('games/$game/users/${user.uid}');
            await gameRef.update({
              "name": fullName,
              "phone": phoneNumber,
              "photo_url": imageURL,
            });

            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              homeRoute,
              (_) => false,
            );
          }
        },
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),
            backgroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
        child: const Text("Save Changes"),
      ),
    );
  }
}
