import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'dart:developer' as devtools show log;

import 'package:uuid/uuid.dart';

class KillsPage extends StatefulWidget {
  const KillsPage({Key? key}) : super(key: key);

  @override
  State<KillsPage> createState() => _KillsPageState();
}

class _KillsPageState extends State<KillsPage> {
  bool adminMode = false;
  List<DataSnapshot> kills = [];
  late final StreamSubscription _killSubscription;
  late DatabaseReference killsRef;
  late DataSnapshot usersSnapshot;
  late DataSnapshot userSnapshot;

  // Video Uploading
  final ImagePicker _picker = ImagePicker();
  File? video;
  String? errorMessage;
  late CachedVideoPlayerController controller;

  @override
  void initState() {
    loadKills();
    super.initState();
  }

  @override
  void dispose() {
    _killSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            Visibility(
              visible:
                  true, //DateTime.now().isAfter(DateTime.parse(openingDays[0])),
              child: SizedBox(
                width: size.width * 0.9,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(children: [
                      TextSpan(text: "Round 1", style: killHeadings),
                    ]),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.5,
              child: ListView.builder(
                itemCount: kills.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: size.height * 0.03,
                    child: OutlinedButton(
                      onPressed: () {
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
                              title: const Text(
                                "ELIMINATION",
                                style: popupTitle,
                                textAlign: TextAlign.center,
                              ),
                              content: SizedBox(
                                height: size.height * 0.4,
                                child: Center(
                                    child: FutureBuilder(
                                        future: getController(index),
                                        builder: (context, snapshot) {
                                          return controller.value.isInitialized
                                              ? AspectRatio(
                                                  aspectRatio: controller
                                                      .value.aspectRatio,
                                                  child: CachedVideoPlayer(
                                                      controller))
                                              : const CircularProgressIndicator();
                                        })
                                    // getController(index)
                                    //         .value

                                    ),
                              ),
                            );
                          },
                        );
                      },
                      style: rectButton,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: usersSnapshot
                                  .child(kills[index].child("killer").value
                                      as String)
                                  .child('name')
                                  .value as String,
                              style: buttonInfo,
                            ),
                            WidgetSpan(
                              child: SizedBox(width: size.width * 0.03),
                            ),
                            const WidgetSpan(
                              child: FaIcon(
                                FontAwesomeIcons.personRifle,
                                size: 20,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: size.width * 0.03),
                            ),
                            TextSpan(
                              text: usersSnapshot
                                  .child(kills[index].child("killed").value
                                      as String)
                                  .child('name')
                                  .value as String,
                              style: buttonInfo,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
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
                onPressed: () async {
                  var temp =
                      await _picker.pickVideo(source: ImageSource.gallery);
                  if (temp != null) {
                    setState(() {
                      video = File(temp.path);
                    });
                    final storageRef = FirebaseStorage.instance.ref();
                    final videosRef = storageRef.child('videos');
                    final videoRef = videosRef.child(const Uuid().v4());
                    await videoRef.putFile(video!);
                    final videoURL = await videoRef.getDownloadURL();

                    final killRef = killsRef.child('${kills.length}');
                    await killRef.update({
                      'killer': userSnapshot.key!,
                      'killed': userSnapshot.child('target').value as String,
                      'video_url': videoURL,
                      'time': DateTime.now().toUtc().toIso8601String()
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  loadKills() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameEvent =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameEvent.snapshot.value;

    final usersEvent =
        await FirebaseDatabase.instance.ref('games/$game/users').once();
    usersSnapshot = usersEvent.snapshot;
    userSnapshot = usersSnapshot.child(id);
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    adminMode = admin && verified;

    killsRef = FirebaseDatabase.instance.ref('games/$game/kills');
    if (!mounted) return;
    _killSubscription = killsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> killsRefs = [];
      for (DataSnapshot kill in data) {
        killsRefs.add(kill);
      }
      setState(() {
        kills = killsRefs;
      });
    });
  }

  getController(int index) {
    controller = CachedVideoPlayerController.network(
        kills[index].child("video_url").value.toString());
    return controller.initialize().then((value) {
      controller.play();
      setState(() {});
    });
  }
}
