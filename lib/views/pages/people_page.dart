import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ShowTypes { alive, all, admin, unverified }

enum SortTypes { aToZ, zToA, mostKills }

enum AdminSortTypes { aToZ, zToA, mostKills, unverified }

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<DataSnapshot> people = [];
  List<DataSnapshot> showPeople = [];
  late final StreamSubscription _testSubscription;
  late DatabaseReference usersRef;
  bool adminMode = false;
  bool loaded = false;

  ShowTypes showType = ShowTypes.alive;
  SortTypes sortType = SortTypes.aToZ;

  @override
  void initState() {
    loadPeople();
    super.initState();
  }

  @override
  void dispose() {
    people = [];
    _testSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loaded
        ? Column(
            children: [
              SizedBox(
                width: size.width * 0.9,
                child: Row(
                  children: [
                    DropdownButton<ShowTypes>(
                      dropdownColor: kBlackColor,
                      value: showType,
                      alignment: Alignment.center,
                      style: buttonInfo,
                      items: adminMode
                          ? const [
                              DropdownMenuItem(
                                value: ShowTypes.alive,
                                child: Text(textShowAlive),
                              ),
                              DropdownMenuItem(
                                value: ShowTypes.all,
                                child: Text(textShowAll),
                              ),
                              DropdownMenuItem(
                                value: ShowTypes.admin,
                                child: Text(textShowAdmin),
                              ),
                              DropdownMenuItem(
                                value: ShowTypes.unverified,
                                child: Text(textShowUnverified),
                              ),
                            ]
                          : const [
                              DropdownMenuItem(
                                value: ShowTypes.alive,
                                child: Text(textShowAlive),
                              ),
                              DropdownMenuItem(
                                value: ShowTypes.all,
                                child: Text(textShowAll),
                              ),
                              DropdownMenuItem(
                                value: ShowTypes.admin,
                                child: Text(textShowAdmin),
                              ),
                            ],
                      onChanged: (ShowTypes? newValue) {
                        setState(() {
                          showType = newValue!;
                          switch (showType) {
                            case ShowTypes.admin:
                              showPeople = [];
                              for (DataSnapshot person in people) {
                                if (person.child('admin').value == true &&
                                    person.child('verified').value == true) {
                                  showPeople.add(person);
                                }
                              }
                              break;
                            case ShowTypes.alive:
                              showPeople = [];
                              for (DataSnapshot person in people) {
                                if (person.child('admin').value == false &&
                                    person.child('alive').value == true &&
                                    person.child('verified').value == true) {
                                  showPeople.add(person);
                                }
                              }
                              break;
                            case ShowTypes.all:
                              showPeople = [];
                              for (DataSnapshot person in people) {
                                if (person.child('admin').value == false &&
                                    person.child('verified').value == true) {
                                  showPeople.add(person);
                                }
                              }
                              break;
                            case ShowTypes.unverified:
                              showPeople = [];
                              for (DataSnapshot person in people) {
                                if (person.child('verified').value == false) {
                                  showPeople.add(person);
                                }
                              }
                              break;
                          }
                          switch (sortType) {
                            case SortTypes.aToZ:
                              showPeople.sort((a, b) {
                                String nameA = a.child('name').value as String;
                                String nameB = b.child('name').value as String;
                                return nameA
                                    .toLowerCase()
                                    .compareTo(nameB.toLowerCase());
                              });
                              break;
                            case SortTypes.zToA:
                              showPeople.sort((a, b) {
                                String nameA = a.child('name').value as String;
                                String nameB = b.child('name').value as String;
                                return nameB
                                    .toLowerCase()
                                    .compareTo(nameA.toLowerCase());
                              });
                              break;
                            case SortTypes.mostKills:
                              if (showType != ShowTypes.admin) {
                                showPeople.sort((a, b) {
                                  int killsA = a.child('kills').value as int;
                                  int killsB = b.child('kills').value as int;
                                  return killsA - killsB;
                                });
                              }
                              break;
                          }
                        });
                      },
                    ),
                    const Spacer(),
                    DropdownButton<SortTypes>(
                      dropdownColor: kBlackColor,
                      value: sortType,
                      alignment: Alignment.center,
                      style: buttonInfo,
                      items: const [
                        DropdownMenuItem(
                          value: SortTypes.aToZ,
                          child: Text(textSortAZ),
                        ),
                        DropdownMenuItem(
                          value: SortTypes.zToA,
                          child: Text(textSortZA),
                        ),
                        DropdownMenuItem(
                          value: SortTypes.mostKills,
                          child: Text(textSortKills),
                        ),
                      ],
                      onChanged: (SortTypes? newValue) {
                        setState(() {
                          sortType = newValue!;
                          switch (sortType) {
                            case SortTypes.aToZ:
                              showPeople.sort((a, b) {
                                String nameA = a.child('name').value as String;
                                String nameB = b.child('name').value as String;
                                return nameA
                                    .toLowerCase()
                                    .compareTo(nameB.toLowerCase());
                              });
                              break;
                            case SortTypes.zToA:
                              showPeople.sort((a, b) {
                                String nameA = a.child('name').value as String;
                                String nameB = b.child('name').value as String;
                                return nameB
                                    .toLowerCase()
                                    .compareTo(nameA.toLowerCase());
                              });
                              break;
                            case SortTypes.mostKills:
                              showPeople.sort((a, b) {
                                int killsA = a.child('kills').value as int;
                                int killsB = b.child('kills').value as int;
                                return killsA - killsB;
                              });
                              break;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: showPeople.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OutlinedButton(
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
                              title: Text(
                                showPeople[index].child('name').value as String,
                                style: popupTitle,
                                textAlign: TextAlign.center,
                              ),
                              content: FittedBox(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            child: CachedNetworkImage(
                                              height: size.height * 0.4,
                                              imageUrl: showPeople[index]
                                                  .child('photo_url')
                                                  .value as String,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.05,
                                          child: Center(
                                            child: showType != ShowTypes.admin
                                                ? Text(
                                                    'Kills: ${showPeople[index].child('kills').value as int}',
                                                    style: popupText,
                                                    textAlign: TextAlign.left,
                                                  )
                                                : const Text(
                                                    'Coordinator',
                                                    style: popupText,
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Visibility(
                                        visible: adminMode,
                                        child: showPeople[index]
                                                .child('admin')
                                                .value as bool
                                            ? const SizedBox()
                                            : showPeople[index]
                                                    .child('alive')
                                                    .value as bool
                                                ? CupertinoButton(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: const FaIcon(
                                                      FontAwesomeIcons.skull,
                                                      size: 20,
                                                      color: kWhiteColor,
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      usersRef
                                                          .child(
                                                              showPeople[index]
                                                                  .key!)
                                                          .update(
                                                              {'alive': false});
                                                    },
                                                  )
                                                : CupertinoButton(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: const FaIcon(
                                                      FontAwesomeIcons.heart,
                                                      size: 20,
                                                      color: kWhiteColor,
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      usersRef
                                                          .child(
                                                              showPeople[index]
                                                                  .key!)
                                                          .update(
                                                              {'alive': true});
                                                    },
                                                  ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Visibility(
                                        visible: adminMode,
                                        child: showPeople[index]
                                                .child('verified')
                                                .value as bool
                                            ? CupertinoButton(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.x,
                                                  size: 20,
                                                  color: kWhiteColor,
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  usersRef
                                                      .child(showPeople[index]
                                                          .key!)
                                                      .update(
                                                          {'verified': false});
                                                },
                                              )
                                            : CupertinoButton(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 20,
                                                  color: kWhiteColor,
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  usersRef
                                                      .child(showPeople[index]
                                                          .key!)
                                                      .update(
                                                          {'verified': true});
                                                },
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                            child: CachedNetworkImage(
                              imageUrl: showPeople[index]
                                  .child('photo_url')
                                  .value as String,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: kCyanColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              child: Text(
                                  showPeople[index]
                                      .child('name')
                                      .value
                                      .toString(),
                                  style: popupText),
                            ),
                          )
                        ],
                      ),
                    );
                  },
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

  loadPeople() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

    final adminSnapshot =
        await FirebaseDatabase.instance.ref('games/$game/users/$id').once();
    final admin = adminSnapshot.snapshot.child('admin').value as bool;
    final verified = adminSnapshot.snapshot.child('verified').value as bool;
    setState(() {
      adminMode = admin && verified;
    });

    usersRef = FirebaseDatabase.instance.ref('games/$game/users');

    DatabaseReference gameUsersRef =
        FirebaseDatabase.instance.ref('games/$game/users');
    if (!mounted) return;
    _testSubscription = gameUsersRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> peopleRefs = [];
      for (DataSnapshot user in data) {
        peopleRefs.add(user);
      }
      setState(() {
        people = peopleRefs;
        showPeople = [];
        switch (showType) {
          case ShowTypes.admin:
            showPeople = [];
            for (DataSnapshot person in people) {
              if (person.child('admin').value == true &&
                  person.child('verified').value == true) {
                showPeople.add(person);
              }
            }

            break;
          case ShowTypes.alive:
            showPeople = [];
            for (DataSnapshot person in people) {
              if (person.child('admin').value == false &&
                  person.child('alive').value == true &&
                  person.child('verified').value == true) {
                showPeople.add(person);
              }
            }
            break;
          case ShowTypes.all:
            showPeople = [];
            for (DataSnapshot person in people) {
              if (person.child('admin').value == false &&
                  person.child('verified').value == true) {
                showPeople.add(person);
              }
            }
            break;
          case ShowTypes.unverified:
            showPeople = [];
            for (DataSnapshot person in people) {
              if (person.child('verified').value == false) {
                showPeople.add(person);
              }
            }
            break;
        }
        switch (sortType) {
          case SortTypes.aToZ:
            showPeople.sort((a, b) {
              String nameA = a.child('name').value as String;
              String nameB = b.child('name').value as String;
              return nameA.toLowerCase().compareTo(nameB.toLowerCase());
            });
            break;
          case SortTypes.zToA:
            showPeople.sort((a, b) {
              String nameA = a.child('name').value as String;
              String nameB = b.child('name').value as String;
              return nameB.toLowerCase().compareTo(nameA.toLowerCase());
            });
            break;
          case SortTypes.mostKills:
            if (showType != ShowTypes.admin) {
              showPeople.sort((a, b) {
                int killsA = a.child('kills').value as int;
                int killsB = b.child('kills').value as int;
                return killsA - killsB;
              });
            }
            break;
        }
      });
    });

    setState(() {
      loaded = true;
    });
  }
}

AppBar peopleBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Players', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
