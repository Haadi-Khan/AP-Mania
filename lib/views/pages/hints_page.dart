import 'dart:io';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/util/google_drive.dart';
import 'package:image_picker/image_picker.dart';

class HintsPage extends StatefulWidget {
  const HintsPage({Key? key}) : super(key: key);

  @override
  State<HintsPage> createState() => _HintsPageState();
}

class _HintsPageState extends State<HintsPage> {
  late final TextEditingController _hintBody;
  List<DataSnapshot> hints = [];
  late final StreamSubscription _hintSubscription;
  bool adminMode = false;
  late DatabaseReference hintsRef;
  final ImagePicker _picker = ImagePicker();
  File? image;
  bool loaded = false;
  bool overFileSize = false;

  @override
  void initState() {
    _hintBody = TextEditingController();
    loadHints();
    super.initState();
  }

  @override
  void dispose() {
    _hintSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loaded
        ? Stack(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  ListView.builder(
                    itemCount: hints.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: size.width * 0.8,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: hints[index]
                                                  .child('photo_url')
                                                  .value
                                                  .toString() !=
                                              ''
                                          ? SizedBox(
                                              height: size.height * 0.3,
                                              child: CachedNetworkImage(
                                                imageUrl: hints[index]
                                                    .child('photo_url')
                                                    .value as String,
                                                placeholder: (context, url) =>
                                                    Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    CircularProgressIndicator(
                                                      color: kCyanColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                    hints[index]
                                                .child('text')
                                                .value
                                                .toString() !=
                                            ''
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: hints[index]
                                                        .child('text')
                                                        .value as String,
                                                    style: generalText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                                Visibility(
                                  visible: adminMode,
                                  child: Positioned(
                                    top: 0,
                                    right: 0,
                                    child: CupertinoButton(
                                      minSize: double.minPositive,
                                      padding: const EdgeInsets.all(5),
                                      child: const FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 15,
                                        color: kRedColor,
                                      ),
                                      onPressed: () {
                                        for (int i = index;
                                            i < hints.length - 1;
                                            i++) {
                                          hintsRef.child('$i').set({
                                            'text': hints[i + 1]
                                                .child('text')
                                                .value!,
                                            'photo_url': hints[i + 1]
                                                .child('photo_url')
                                                .value!
                                          });
                                        }
                                        hintsRef
                                            .child('${hints.length - 1}')
                                            .remove();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
              Visibility(
                visible: adminMode,
                child: Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      CupertinoButton(
                        minSize: double.minPositive,
                        padding: const EdgeInsets.all(5),
                        child: const FaIcon(
                          FontAwesomeIcons.plus,
                          size: 30,
                          color: kRedColor,
                        ),
                        onPressed: () {
                          _hintBody.clear();
                          image = null;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: kBlackColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      20.0,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                content: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return SizedBox(
                                    height: size.height * 0.5,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.65,
                                              height: size.height * 0.1,
                                              child: TextField(
                                                keyboardAppearance:
                                                    Brightness.dark,
                                                style: generalText,
                                                controller: _hintBody,
                                                expands: true,
                                                maxLines: null,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: textHintMessage,
                                                  hintStyle: hintText,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.4,
                                              height: size.height * 0.04,
                                              child: OutlinedButton(
                                                onPressed: () async {
                                                  var temp =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (temp != null) {
                                                    final imageFile =
                                                        File(temp.path);
                                                    if (imageFile.lengthSync() <
                                                        3000000) {
                                                      setState(() {
                                                        overFileSize = false;
                                                        image = imageFile;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        overFileSize = true;
                                                      });
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(kGreyColor),
                                                  side: MaterialStateProperty
                                                      .all<BorderSide>(
                                                          BorderSide.none),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    FaIcon(
                                                        FontAwesomeIcons.images,
                                                        color: kWhiteColor),
                                                    Text(textChoosePhoto,
                                                        style: generalText),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            SizedBox(
                                              height: size.height * 0.25,
                                              width: size.width * 0.8,
                                              child: !overFileSize
                                                  ? image == null
                                                      ? null
                                                      : Image.file(
                                                          image!,
                                                          fit: BoxFit.contain,
                                                        )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .circleExclamation,
                                                            color:
                                                                kOrangeColor),
                                                        Text(
                                                            'File size must be < 3 MB',
                                                            style: TextStyle(
                                                                color:
                                                                    kOrangeColor)),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: ElevatedButton(
                                            style: redButton,
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              String imageURL = '';
                                              if (image != null) {
                                                imageURL =
                                                    await uploadFileToGoogleDrive(
                                                        image!);
                                              }

                                              hintsRef
                                                  .child('${hints.length}')
                                                  .update({
                                                'photo_url': imageURL,
                                                'text': _hintBody.text
                                              });
                                            },
                                            child: const Text(textSaveButton),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(
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

  loadHints() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameEvent =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameEvent.snapshot.value;

    final usersEvent =
        await FirebaseDatabase.instance.ref('games/$game/users/$id').once();
    final userSnapshot = usersEvent.snapshot;
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    setState(() {
      adminMode = admin && verified;
    });

    hintsRef = FirebaseDatabase.instance.ref('games/$game/hints');
    if (!mounted) return;
    _hintSubscription = hintsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> hintsRefs = List.from(List.from(data).reversed);
      setState(() {
        hints = hintsRefs;
      });
    });

    setState(() {
      loaded = true;
    });
  }
}

AppBar hintsBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Hints', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
