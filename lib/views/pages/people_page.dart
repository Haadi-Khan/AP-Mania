import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ShowTypes { alive, all, admin }

enum SortTypes { aToZ, zToA, mostKills }

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<DataSnapshot> people = [];
  List<DataSnapshot> showPeople = [];
  late final StreamSubscription _testSubscription;

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
    return Column(
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
                items: const [
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
                          if (person.child('admin').value == true) {
                            showPeople.add(person);
                          }
                        }

                        break;
                      case ShowTypes.alive:
                        showPeople = [];
                        for (DataSnapshot person in people) {
                          if (person.child('admin').value == false) {
                            if (person.child('alive').value == true) {
                              showPeople.add(person);
                            }
                          }
                        }
                        break;
                      case ShowTypes.all:
                        showPeople = [];
                        for (DataSnapshot person in people) {
                          if (person.child('admin').value == false) {
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
                        content: SizedBox(
                          height: size.height * 0.4,
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: showPeople[index]
                                      .child('photo_url')
                                      .value as String,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              showType != ShowTypes.admin
                                  ? Text(
                                      'Kills: ${showPeople[index].child('kills').value as int}',
                                      style: popupText,
                                      textAlign: TextAlign.left,
                                    )
                                  : const Text(
                                      'Coordinator',
                                      style: popupText,
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
                        imageUrl: showPeople[index].child('photo_url').value
                            as String,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                            showPeople[index].child('name').value.toString(),
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
    );
  }

  loadPeople() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

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
        for (DataSnapshot person in people) {
          if (person.child('admin').value == false) {
            if (person.child('alive').value == true) {
              showPeople.add(person);
            }
          }
        }
      });
    });
  }
}
