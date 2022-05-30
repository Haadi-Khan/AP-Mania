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
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as devtools show log;

import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  late DatabaseReference usersRef;
  bool started = false;
  Directory? tempDir;
  bool isAlive = false;

  // Video Uploading
  final ImagePicker _picker = ImagePicker();
  String? thumbnail;
  File? video;
  String? errorMessage;

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
                              content:
                                  kills[index].child("video_url").value != null
                                      ? SizedBox(
                                          height: size.height * 0.4,
                                          child: Center(
                                            child: VideoDialog(
                                                url: kills[index]
                                                    .child("video_url")
                                                    .value as String),
                                          ),
                                        )
                                      : SizedBox(
                                          height: size.height * 0.4,
                                          child: const Center(
                                            child: Text(
                                              'No Video Provided',
                                              style: generalText,
                                            ),
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
        Visibility(
          visible: !adminMode && started && isAlive,
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
                  onPressed: () async {
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
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return SizedBox(
                                height: size.height * 0.5,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.4,
                                          height: size.height * 0.04,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              var temp =
                                                  await _picker.pickVideo(
                                                      source:
                                                          ImageSource.gallery);
                                              if (temp != null) {
                                                setState(() {
                                                  video = File(temp.path);
                                                });
                                                var thumbnailTemp =
                                                    await VideoThumbnail
                                                        .thumbnailFile(
                                                  video: video!.path,
                                                  thumbnailPath: tempDir!.path,
                                                  imageFormat: ImageFormat.PNG,
                                                  maxHeight:
                                                      100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
                                                  quality: 75,
                                                );
                                                setState(() {
                                                  thumbnail = thumbnailTemp;
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(kGreyColor),
                                              side: MaterialStateProperty.all<
                                                  BorderSide>(BorderSide.none),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                FaIcon(FontAwesomeIcons.images,
                                                    color: kWhiteColor),
                                                Text(textChoosePhoto,
                                                    style: generalText),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        SizedBox(
                                          height: size.height * 0.25,
                                          width: size.width * 0.8,
                                          child: thumbnail == null
                                              ? null
                                              : Image.file(File(thumbnail!),
                                                  fit: BoxFit.cover),
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

                                          String? videoURL;

                                          if (video != null) {
                                            final storageRef =
                                                FirebaseStorage.instance.ref();
                                            final videosRef =
                                                storageRef.child('videos');
                                            final videoRef = videosRef
                                                .child(const Uuid().v4());
                                            await videoRef.putFile(video!);
                                            videoURL =
                                                await videoRef.getDownloadURL();
                                          }

                                          final target = userSnapshot
                                              .child('target')
                                              .value as String;
                                          final killRef =
                                              killsRef.child('${kills.length}');
                                          await killRef.update(
                                            {
                                              'killer': userSnapshot.key!,
                                              'killed': target,
                                              'video_url': videoURL,
                                              'time': DateTime.now()
                                                  .toUtc()
                                                  .toIso8601String()
                                            },
                                          );

                                          DatabaseReference userRef =
                                              usersRef.child(userSnapshot.key!);
                                          final numKills = userSnapshot
                                              .child('kills')
                                              .value as int;
                                          final newTarget = usersSnapshot
                                              .child(target)
                                              .child('target')
                                              .value as String;
                                          await userRef.update({
                                            'kills': numKills + 1,
                                            'killed_this_round': true,
                                            'target': newTarget
                                          });

                                          DatabaseReference targetRef =
                                              usersRef.child(target);
                                          targetRef.update({
                                            'alive': false,
                                          });
                                        },
                                        child: const Text(textSaveButton),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
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

    final startedEvent =
        await FirebaseDatabase.instance.ref('games/$game/started').once();
    started = startedEvent.snapshot.value == true;

    usersRef = FirebaseDatabase.instance.ref('games/$game/users');
    final usersEvent = await usersRef.once();
    usersSnapshot = usersEvent.snapshot;
    userSnapshot = usersSnapshot.child(id);
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    setState(() {
      adminMode = admin && verified;
    });

    if (!admin) {
      setState(() {
        isAlive = userSnapshot.child('alive').value as bool;
      });
    }

    killsRef = FirebaseDatabase.instance.ref('games/$game/kills');
    if (!mounted) return;
    _killSubscription = killsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> killsRefs = List.from(List.from(data).reversed);
      setState(() {
        kills = killsRefs;
      });
    });

    tempDir = await getTemporaryDirectory();
  }
}

class VideoDialog extends StatefulWidget {
  final String url;

  const VideoDialog({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  CachedVideoPlayerController? controller;

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(widget.url);
    controller!.initialize().then((value) {
      controller!.play();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: CachedVideoPlayer(controller!))
        : const CircularProgressIndicator();
  }
}

AppBar killBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Kill Feed', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
