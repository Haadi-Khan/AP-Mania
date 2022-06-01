import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

enum MenuAction { logout }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DataSnapshot> dates = [];
  late final StreamSubscription _testSubscription;
  bool adminMode = false;
  late DatabaseReference datesRef;
  late DataSnapshot userSnapshot;
  late DataSnapshot usersSnapshot;
  late String targetName;
  late String remainingTime;
  DateTime? nextRound;
  DateTime now = DateTime.now();
  int roundNumber = 0;
  bool isAlive = false;
  bool loaded = false;

  @override
  void initState() {
    loadRules();
    super.initState();
  }

  @override
  void dispose() {
    _testSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarColorMain,
      child: loaded
          ? adminMode
              ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ListView.builder(
                      itemCount: dates.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                              child: Text(
                                DateTime.parse(dates[index].child('time').value
                                        as String)
                                    .toLocal()
                                    .toIso8601String()
                                    .replaceAll('T', ' '),
                                style: buttonInfo,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 10,
                              child: Row(
                                children: [
                                  CupertinoButton(
                                    minSize: double.minPositive,
                                    padding: const EdgeInsets.all(5),
                                    child: const FaIcon(
                                      FontAwesomeIcons.pen,
                                      size: 15,
                                      color: kWhiteColor,
                                    ),
                                    onPressed: () async {
                                      final datePicked = await showDatePicker(
                                        context: context,
                                        initialDate: now,
                                        firstDate: now,
                                        lastDate: DateTime(
                                          now.year + 1,
                                          now.month,
                                          now.day,
                                        ),
                                      );
                                      if (datePicked != null) {
                                        final timePicked = await showTimePicker(
                                          context: context,
                                          initialTime: const TimeOfDay(
                                              hour: 00, minute: 00),
                                        );
                                        if (timePicked != null) {
                                          DateTime newTime = DateTime(
                                                  datePicked.year,
                                                  datePicked.month,
                                                  datePicked.day,
                                                  timePicked.hour,
                                                  timePicked.minute)
                                              .toUtc();
                                          datesRef.child('$index').update({
                                            'time': newTime.toIso8601String(),
                                            'started': false
                                          });
                                        }
                                      }
                                    },
                                  ),
                                  CupertinoButton(
                                    minSize: double.minPositive,
                                    padding: const EdgeInsets.all(5),
                                    child: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 15,
                                      color: kRedColor,
                                    ),
                                    onPressed: () {
                                      for (int i = index;
                                          i < dates.length - 1;
                                          i++) {
                                        datesRef.child('$i').set({
                                          'time':
                                              dates[i + 1].child('time').value!,
                                          'started': dates[i + 1]
                                              .child('started')
                                              .value!
                                        });
                                      }
                                      datesRef
                                          .child('${dates.length - 1}')
                                          .remove();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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
                              final datePicked = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now,
                                lastDate: DateTime(
                                  now.year + 1,
                                  now.month,
                                  now.day,
                                ),
                              );
                              if (datePicked != null) {
                                final timePicked = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 00, minute: 00),
                                );
                                if (timePicked != null) {
                                  DateTime newTime = DateTime(
                                          datePicked.year,
                                          datePicked.month,
                                          datePicked.day,
                                          timePicked.hour,
                                          timePicked.minute)
                                      .toUtc();
                                  datesRef.child('${dates.length}').set({
                                    'time': newTime.toIso8601String(),
                                    'started': false
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: size.width * 0.9,
                        height: size.height * 0.5,
                        child: nextRound == null
                            ? SizedBox(
                                // Game has ended
                                child: isAlive
                                    ? SizedBox(
                                        // Player is alive
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              child: RichText(
                                                text: const TextSpan(
                                                    text:
                                                        'Congratulations you won!',
                                                    style: heading),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.4,
                                              child: Image.asset(
                                                  'assets/images/thunderbirdCrosshair.png'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        // Player is dead,
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              child: RichText(
                                                text: const TextSpan(
                                                    text:
                                                        'You have been eliminated',
                                                    style: heading),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.4,
                                              child: Image.asset(
                                                  'assets/images/thunderbirdCrosshair.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                              )
                            : roundNumber == 0
                                ? SizedBox(
                                    // Player is dead,
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: RichText(
                                            text: const TextSpan(
                                                text:
                                                    'Wait for the game to begin',
                                                style: heading),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.4,
                                          child: Image.asset(
                                              'assets/images/thunderbirdCrosshair.png'),
                                        ),
                                      ],
                                    ),
                                  )
                                : isAlive
                                    ? Align(
                                        // Player is alive
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              child: FittedBox(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'Round $roundNumber',
                                                      style: heading),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: FittedBox(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          'Current Target: $targetName',
                                                      style: redOptionText),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.4,
                                              child: CachedNetworkImage(
                                                imageUrl: usersSnapshot
                                                    .child(userSnapshot
                                                        .child('target')
                                                        .value
                                                        .toString())
                                                    .child('photo_url')
                                                    .value as String,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: kCyanColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        // Player is dead,
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              child: RichText(
                                                text: const TextSpan(
                                                    text:
                                                        'You have been eliminated',
                                                    style: heading),
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.4,
                                              child: Image.asset(
                                                  'assets/images/thunderbirdCrosshair.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                      ),
                    ),
                    StreamBuilder(
                      stream:
                          Stream.periodic(const Duration(seconds: 1), (i) => i),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        var timeLeft = getTimeLeft();
                        return nextRound != null
                            ? Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                color: kDarkGreyColor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: roundNumber == 0
                                          ? RichText(
                                              text: const TextSpan(
                                                text: 'Time Until Start',
                                                style: smallerHeading,
                                              ),
                                            )
                                          : RichText(
                                              text: const TextSpan(
                                                text: 'Time Remaining In Round',
                                                style: smallerHeading,
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      child: RichText(
                                        text: TextSpan(
                                          text: timeLeft,
                                          style: heading,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      },
                    )
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
            ),
    );
  }

  loadRules() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

    final usersRef = FirebaseDatabase.instance.ref('games/$game/users');
    final usersEvent = await usersRef.once();
    usersSnapshot = usersEvent.snapshot;
    userSnapshot = usersSnapshot.child(id);
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    setState(() {
      adminMode = admin && verified;
    });

    if (!admin) {
      usersRef.child('$id/alive').onValue.listen((DatabaseEvent event) {
        setState(() {
          isAlive = event.snapshot.value as bool;
        });
      });
    }
    datesRef = FirebaseDatabase.instance.ref('games/$game/rounds');
    if (!mounted) return;
    _testSubscription = datesRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> datesRefs = [];
      DateTime? nextRoundTemp;
      for (DataSnapshot dateRef in data) {
        datesRefs.add(dateRef);
      }
      datesRefs.sort((a, b) {
        String timeA = a.child('time').value as String;
        String timeB = b.child('time').value as String;
        return timeA.compareTo(timeB);
      });
      setState(() {
        dates = datesRefs;
      });

      for (DataSnapshot date in dates) {
        nextRoundTemp = DateTime.parse(date.child('time').value as String);
        if (now.isBefore(nextRoundTemp)) {
          setState(() {
            nextRound = nextRoundTemp;
            roundNumber = dates.indexOf(date);
          });
          bool started = roundNumber == 0 ||
              dates[roundNumber - 1].child('started').value as bool;
          if (!started) {
            List uuids = [];
            for (DataSnapshot user in usersSnapshot.children) {
              if (user.child('killed_this_round').value == false) {
                usersRef.child(user.key!).update({'alive': false});
              } else if (user.child('alive').value == true) {
                uuids.add(user.key);
              }
            }
            List permutation = [];
            for (int i = 0; i < uuids.length; i++) {
              permutation.add(i);
            }
            while (getMinCycleLength(permutation) <
                min(uuids.length, max(3, uuids.length / 20))) {
              permutation.shuffle();
            }
            for (int i = 0; i < uuids.length; i++) {
              usersRef
                  .child(uuids[i])
                  .update({'target': uuids[permutation[i]]});
            }
            datesRef
                .child(dates[roundNumber - 1].key!)
                .update({'started': true});
            FirebaseDatabase.instance.ref('games/$game/started').set(true);
            for (DataSnapshot user in usersSnapshot.children) {
              usersRef.child(user.key!).update({'killed_this_round': false});
            }
          }
          break;
        }
      }
    });
    targetName = usersSnapshot
        .child(userSnapshot.child('target').value.toString())
        .child('name')
        .value
        .toString();
    setState(() {
      loaded = true;
    });
  }

  String getTimeLeft() {
    format(Duration d) {
      final days = d.inDays;
      final hours = d.inHours - 24 * d.inDays;
      final minutes = d.inMinutes - 60 * d.inHours;
      final seconds = d.inSeconds - 60 * d.inMinutes;
      return '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    if (nextRound != null) {
      return format(nextRound!.difference(DateTime.now().toUtc()));
    } else {
      return '';
    }
  }
}

int getMinCycleLength(List perms) {
  List<int> cycles = [];
  for (int i = 0; i < perms.length; i++) {
    int temp = perms[i];
    int count = 1;
    while (temp != i) {
      temp = perms[temp];
      count += 1;
    }
    cycles.add(count);
  }
  return cycles.reduce(min);
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kBlackColor,
        title: const Text(textLogout, style: heading),
        content: const Text(textLogoutCheck, style: generalText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(textCancel, style: redOptionText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(textLogout, style: redOptionText),
          )
        ],
      );
    },
  ).then(((value) => value ?? false));
}

AppBar homeBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Welcome to AP Assassin!', style: smallerHeading),
    backgroundColor: kBlackColor,
    actions: [
      PopupMenuButton<MenuAction>(
        color: kBlackColor,
        onSelected: (value) async {
          switch (value) {
            case MenuAction.logout:
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                if (!state.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  welcomeRoute,
                  (_) => false,
                );
              }
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out', style: generalText),
            ),
          ];
        },
      ),
    ],
  );
}
