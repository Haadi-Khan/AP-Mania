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
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';

enum MenuAction { logout, edit, leave }

///This displays the home page of the app.
/// If a user is not verified, they are shown the [VerifyPage].
/// If a user is verified, they are shown the [HomePage].
///  - If the user is an admin, they are shown the admin view.
/// - If the user is not an admin, they are shown the time remaining for the next round w/ their target
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  AssassinState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AssassinState<HomePage> {
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
              ? HomeViewAdmin(
                  dates: dates, size: size, now: now, datesRef: datesRef)
              : HomeViewUser(
                  size: size,
                  context: context,
                  nextRound: nextRound,
                  roundNumber: roundNumber,
                  isAlive: isAlive,
                  targetName: targetName,
                  userSnapshot: userSnapshot,
                  usersSnapshot: usersSnapshot)
          : super.loadingMenu(context),
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

    // Display user's target for the round if they're alive
    if (!admin) {
      usersRef.child('$id/alive').onValue.listen((DatabaseEvent event) {
        setState(() {
          isAlive = event.snapshot.value.runtimeType == Null
              ? false
              : event.snapshot.value as bool;
        });
      });
    }

    // Setting the targets for the round
    datesRef = FirebaseDatabase.instance.ref('games/$game/rounds');
    if (!mounted) return;
    _testSubscription = datesRef.onValue.listen(
      (event) {
        setRoundTargets(event, usersRef, game);
      },
    );
    targetName = usersSnapshot
        .child(userSnapshot.child('target').value.toString())
        .child('name')
        .value
        .toString();
    setState(() {
      loaded = true;
    });
  }

  setRoundTargets(DatabaseEvent event, DatabaseReference usersRef, game) {
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

    // Setting the targets for the round
    for (DataSnapshot date in dates) {
      nextRoundTemp = DateTime.parse(date.child('time').value as String);
      if (now.isBefore(nextRoundTemp)) {
        setState(() {
          nextRound = nextRoundTemp;
          roundNumber = dates.indexOf(date);
        });

        // If it's the first round or if there was a previous round from the current
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
            usersRef.child(uuids[i]).update({'target': uuids[permutation[i]]});
          }

          datesRef.child(dates[roundNumber - 1].key!).update({'started': true});
          FirebaseDatabase.instance.ref('games/$game/started').set(true);

          for (DataSnapshot user in usersSnapshot.children) {
            usersRef.child(user.key!).update({'killed_this_round': false});
          }

        }
        break;
      }
    }
  }
}

/// Home view for user
/// If the game hasn't started, it shows a message showing the time remaining
/// If the game has ended, it shows a message saying the game has ended
/// If the user is alive, they are shown the time remaining for the next round w/ their target
/// If the user is dead, it shows a message saying they are dead
class HomeViewUser extends AssassinStatelessWidget {
  const HomeViewUser({
    super.key,
    required this.size,
    required this.context,
    required this.nextRound,
    required this.roundNumber,
    required this.isAlive,
    required this.targetName,
    required this.userSnapshot,
    required this.usersSnapshot,
  });

  final Size size;
  final BuildContext context;
  final DateTime? nextRound;
  final int roundNumber;
  final bool isAlive;
  final String targetName;
  final DataSnapshot userSnapshot;
  final DataSnapshot usersSnapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        ? winView(context, size)
                        : loseView(context, size),
                  )
                : roundNumber == 0
                    ? waitingView(context, size)
                    : isAlive
                        ? assassinView()
                        : loseView(context, size),
          ),
        ),
        timeRemaining()
      ],
    );
  }

  Align assassinView() {
    return Align(
      // Player is alive
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            child: FittedBox(
              child: RichText(
                text: TextSpan(text: 'Round $roundNumber', style: heading),
              ),
            ),
          ),
          SizedBox(
            child: FittedBox(
              child: RichText(
                text: TextSpan(
                    text: 'Current Target: $targetName', style: redOptionText),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.4,
            child: CachedNetworkImage(
              imageUrl: usersSnapshot
                          .child(userSnapshot.child('target').value.toString())
                          .child('photo_url')
                          .value
                          .runtimeType ==
                      Null
                  ? ''
                  : usersSnapshot
                      .child(userSnapshot.child('target').value.toString())
                      .child('photo_url')
                      .value as String,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: kCyanColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<int> timeRemaining() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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
    );
  }

  SizedBox waitingView(BuildContext context, Size size) {
    return SizedBox(
      // Player is dead,
      child: Column(
        children: [
          FittedBox(
            child: RichText(
              text: const TextSpan(
                  text: 'Wait for the game to begin', style: heading),
            ),
          ),
          super.thunderbirdIconLarge(context, size),
        ],
      ),
    );
  }

  SizedBox loseView(context, size) {
    return SizedBox(
      // Player is dead,
      child: Column(
        children: [
          FittedBox(
            child: RichText(
              text: const TextSpan(
                  text: 'You have been eliminated', style: heading),
            ),
          ),
          super.thunderbirdIconLarge(context, size),
        ],
      ),
    );
  }

  SizedBox winView(context, size) {
    return SizedBox(
      // Player is alive
      child: Column(
        children: [
          FittedBox(
            child: RichText(
              text: const TextSpan(
                  text: 'Congratulations you won!', style: heading),
            ),
          ),
          super.thunderbirdIconLarge(context, size),
        ],
      ),
    );
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

/// Home view for admin
/// Displays all the dates and times of the rounds
/// Allows admin to add new rounds
class HomeViewAdmin extends AssassinStatelessWidget {
  const HomeViewAdmin({
    super.key,
    required this.dates,
    required this.size,
    required this.now,
    required this.datesRef,
  });

  final List<DataSnapshot> dates;
  final Size size;
  final DateTime now;
  final DatabaseReference datesRef;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    DateTime.parse(dates[index].child('time').value as String)
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
                          for (int i = index; i < dates.length - 1; i++) {
                            datesRef.child('$i').set({
                              'time': dates[i + 1].child('time').value!,
                              'started': dates[i + 1].child('started').value!
                            });
                          }
                          datesRef.child('${dates.length - 1}').remove();
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
                      initialTime: const TimeOfDay(hour: 00, minute: 00),
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
    );
  }
}

/// 
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

Future<bool> showLogoutDialog(BuildContext context, String text) {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: kBlackColor,
        title: Text(capitalize(text), style: heading),
        content: Text(textLogoutCheck + text, style: generalText),
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
            child: Text(capitalize(text), style: redOptionText),
          )
        ],
      );
    },
  ).then(((value) => value ?? false));
}

AppBar homeBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Welcome to Hills Mania!', style: smallerHeading),
    backgroundColor: kBlackColor,
    actions: [
      PopupMenuButton<MenuAction>(
        color: kBlackColor,
        icon: const Icon(
          Icons.more_horiz,
          color: kWhiteColor,
        ),
        onSelected: (value) async {
          switch (value) {
            case MenuAction.logout:
              final shouldLogout = await showLogoutDialog(context, "logout");
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                if (!state.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  welcomeRoute,
                  (_) => false,
                );
              }
              break;
            case MenuAction.edit:
              Navigator.of(context).pushNamed(
                editRoute,
                arguments: true,
              );
              break;
            case MenuAction.leave:
              final shouldLeave = await showLogoutDialog(context, "leave");
              if (shouldLeave) {
                String id = FirebaseAuth.instance.currentUser!.uid;
                final userRef = FirebaseDatabase.instance.ref('users/$id');
                final game = await userRef
                    .child('game')
                    .get()
                    .then((value) => value.value);
                final gameRef =
                    FirebaseDatabase.instance.ref('games/$game/users/');

                await userRef.update({
                  "has_chosen_game": false,
                });
                await userRef.child('game').remove();
                await gameRef.child(id).remove();

                if (!state.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  gameChoiceRoute,
                  (_) => false,
                );
              }
              break;
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem<MenuAction>(
              value: MenuAction.edit,
              child: Text('Edit Account', style: generalText),
            ),
            const PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out', style: generalText),
            ),
            const PopupMenuItem<MenuAction>(
              value: MenuAction.leave,
              child: Text('Leave Game', style: redOptionText),
            ),
          ];
        },
      ),
    ],
  );
}
