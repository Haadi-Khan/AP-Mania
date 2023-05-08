import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/util/google_drive.dart';
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

/// This page shows the live kill feed. Admins are able to remove kills from the feed. Users
/// upload their kills to the feed.
class KillsPage extends StatefulWidget {
  const KillsPage({Key? key}) : super(key: key);

  @override
  AssassinState<KillsPage> createState() => _KillsPageState();
}

class _KillsPageState extends AssassinState<KillsPage> {
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
  bool loaded = false;
  bool overFileSize = false;

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
    return loaded
        ? Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.8,
                    child: ListView.builder(
                      itemCount: kills.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            SizedBox(
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
                                        content: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Column(
                                            children: [
                                              kills[index]
                                                          .child("video_url")
                                                          .value !=
                                                      null
                                                  ? SizedBox(
                                                      height: size.height * 0.4,
                                                      child: Center(
                                                        child: VideoDialog(
                                                            url: kills[index]
                                                                .child(
                                                                    "video_url")
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
                                              SizedBox(
                                                height: size.height * 0.05,
                                                child: Center(
                                                  child: Text(
                                                    DateTime.parse(kills[index]
                                                            .child("time")
                                                            .value as String)
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: generalText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      const BeveledRectangleBorder(),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(0)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kWhiteColor),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kDarkGreyColor),
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide.none)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          usersSnapshot
                                              .child(kills[index]
                                                  .child("killer")
                                                  .value as String)
                                              .child('name')
                                              .value as String,
                                          style: const TextStyle(
                                              color: kBlueColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    const FaIcon(
                                      FontAwesomeIcons.gun,
                                      size: 17,
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: Text(
                                        usersSnapshot
                                            .child(kills[index]
                                                .child("killed")
                                                .value as String)
                                            .child('name')
                                            .value as String,
                                        style: const TextStyle(
                                            color: kRedColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                  onPressed: () async {
                                    DatabaseReference killerRef =
                                        usersRef.child(kills[index]
                                            .child('killer')
                                            .value! as String);
                                    DatabaseReference killedRef =
                                        usersRef.child(kills[index]
                                            .child('killed')
                                            .value! as String);
                                    final killer = await killerRef.once();
                                    final numKills = killer.snapshot
                                        .child('kills')
                                        .value as int;
                                    await killerRef.update(
                                      {
                                        'kills': numKills - 1,
                                        'killed_this_round': false,
                                        'target':
                                            kills[index].child('killed').value!
                                      },
                                    );
                                    await killedRef.update(
                                      {
                                        'alive': true,
                                      },
                                    );
                                    for (int i = index;
                                        i < kills.length - 1;
                                        i++) {
                                      killsRef.child('$i').update({
                                        'killer':
                                            kills[i + 1].child('killer').value!,
                                        'killed':
                                            kills[i + 1].child('killed').value!,
                                        'video_url': kills[i + 1]
                                            .child('video_url')
                                            .value,
                                        'time':
                                            kills[i + 1].child('time').value!
                                      });
                                    }
                                    killsRef
                                        .child('${kills.length - 1}')
                                        .remove();
                                  },
                                ),
                              ),
                            )
                          ],
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
                                  builder: (BuildContext context,
                                      StateSetter setState) {
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
                                                            source: ImageSource
                                                                .gallery);
                                                    if (temp != null) {
                                                      final videoFile =
                                                          File(temp.path);
                                                      if (videoFile
                                                              .lengthSync() <
                                                          200000000) {
                                                        setState(() {
                                                          overFileSize = false;
                                                          video = videoFile;
                                                        });
                                                        var thumbnailTemp =
                                                            await VideoThumbnail
                                                                .thumbnailFile(
                                                          video: video!.path,
                                                          thumbnailPath:
                                                              tempDir!.path,
                                                          imageFormat:
                                                              ImageFormat.PNG,
                                                          maxHeight: 100,
                                                          quality: 75,
                                                        );
                                                        setState(() {
                                                          thumbnail =
                                                              thumbnailTemp;
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
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                kGreyColor),
                                                    side: MaterialStateProperty
                                                        .all<BorderSide>(
                                                            BorderSide.none),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      FaIcon(
                                                          FontAwesomeIcons
                                                              .images,
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
                                                    ? thumbnail == null
                                                        ? null
                                                        : Image.file(
                                                            File(thumbnail!),
                                                            fit: BoxFit.cover)
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
                                                              'File size must be < 200 MB',
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

                                                String? videoURL;

                                                if (video != null) {
                                                  videoURL =
                                                      await uploadFileToGoogleDrive(
                                                          video!);
                                                }

                                                final target = userSnapshot
                                                    .child('target')
                                                    .value as String;
                                                final killRef = killsRef
                                                    .child('${kills.length}');
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
                                                    usersRef.child(
                                                        userSnapshot.key!);
                                                final numKills = userSnapshot
                                                    .child('kills')
                                                    .value as int;
                                                final newTarget = usersSnapshot
                                                    .child(target)
                                                    .child('target')
                                                    .value as String;
                                                await userRef.update(
                                                  {
                                                    'kills': numKills + 1,
                                                    'killed_this_round': true,
                                                    'target': newTarget
                                                  },
                                                );

                                                DatabaseReference targetRef =
                                                    usersRef.child(target);
                                                targetRef.update(
                                                  {
                                                    'alive': false,
                                                  },
                                                );
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
          )
        : super.loadingMenu(context);
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
    setState(() {
      loaded = true;
    });
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
        : const Center(
            child: CircularProgressIndicator(
              color: kCyanColor,
            ),
          );
  }
}

AppBar killBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Kill Feed', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
