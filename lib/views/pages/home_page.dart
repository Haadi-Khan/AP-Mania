import 'dart:async';

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
    DateTime now = DateTime.now();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarColorScroll,
      child: adminMode
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
                            DateTime.parse(
                                    dates[index].child('time').value as String)
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
                                  for (int i = index;
                                      i < dates.length - 1;
                                      i++) {
                                    datesRef.child('$i').set({
                                      'time': dates[i + 1].child('time').value!,
                                      'started':
                                          dates[i + 1].child('started').value!
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
              children: [
                SizedBox(height: size.height * 0.5),
              ],
            ),
    );
  }

  loadRules() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

    final userEvent =
        await FirebaseDatabase.instance.ref('games/$game/users/$id').once();
    userSnapshot = userEvent.snapshot;
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    adminMode = admin && verified;

    datesRef = FirebaseDatabase.instance.ref('games/$game/rounds');
    if (!mounted) return;
    _testSubscription = datesRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> datesRefs = [];
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
    });
  }
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
      )
    ],
  );
}
