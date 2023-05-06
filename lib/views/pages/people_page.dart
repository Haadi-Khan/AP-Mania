import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';

/**
 * TODO: 
 * - Finish cleaning the alert dialog
 * - Add option to add extra coordinators
 * - Use theme to standardize theming
 */

enum ShowTypes { alive, all, admin, unverified }

enum SortTypes { aToZ, zToA, mostKills }

enum AdminSortTypes { aToZ, zToA, mostKills, unverified }

/// This page displays all the players in the game.
/// There are a variety of views:
/// - Users can see remaining players, all players, and coordinators
/// - Admins can see remaining players, all players, coordinators, and unverified players
class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  AssassinState<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends AssassinState<PeoplePage> {
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
                    showParticipantTypes(),
                    const Spacer(),
                    showSortTypes(),
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
                              // From here to the title shoud all be in theme data
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
                              title: playerNamePopup(index),
                              content: FittedBox(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Center(
                                          child: imagePopup(size, index),
                                        ),
                                        playerInfoPopup(size, index),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 10,
                                      child: Visibility(
                                        visible: adminMode,
                                        child: showPeople[index]
                                                .child('admin')
                                                .value as bool
                                            ? const SizedBox()
                                            : showPeople[index]
                                                    .child('alive')
                                                    .value as bool
                                                ? adminEliminateButton(
                                                    context, index)
                                                : adminReviveButton(
                                                    context, index),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 100,
                                      child: Visibility(
                                        visible: adminMode,
                                        child: showPeople[index]
                                                .child('admin')
                                                .value as bool
                                            ? adminDemote(context, index)
                                            : adminPromote(context, index),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 10,
                                      child: Visibility(
                                        visible: adminMode,
                                        child: showPeople[index]
                                                .child('verified')
                                                .value as bool
                                            ? adminUnverifyButton(
                                                context, index)
                                            :  adminVerifyButton(
                                                    context, index),
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
                          imagePreview(size, index),
                          namePreview(index)
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : super.loading_menu(context);
  }

  /// Button to verify a player
  CupertinoButton adminVerifyButton(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.check,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'verified': true});
      },
    );
  }

  /// Button to promote a player from  player to admin
  CupertinoButton adminPromote(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.circleChevronUp,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'admin': true});
        usersRef
            .child(showPeople[index].key!)
            .update({'killed_this_round': true});
        usersRef.child(showPeople[index].key!).update({'alive': true});
      },
    );
  }
  /// Button to demote a player from admin to player
  CupertinoButton adminDemote(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.circleChevronDown,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'admin': false});
        usersRef
            .child(showPeople[index].key!)
            .update({'killed_this_round': true});
        usersRef.child(showPeople[index].key!).update({'kills': 0});
        usersRef.child(showPeople[index].key!).update({'alive': true});
      },
    );
  }

  /// Button to unverify a player
  CupertinoButton adminUnverifyButton(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.x,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'verified': false});
      },
    );
  }

  /// Button to revive player
  CupertinoButton adminReviveButton(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.heart,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'alive': true});
      },
    );
  }

  /// Button to eliminate player
  CupertinoButton adminEliminateButton(BuildContext context, int index) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      child: const FaIcon(
        FontAwesomeIcons.skull,
        size: 20,
        color: kWhiteColor,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        usersRef.child(showPeople[index].key!).update({'alive': false});
      },
    );
  }

  /// Displays the player name in the popup
  Text playerNamePopup(int index) {
    return Text(
      showPeople[index].child('name').value as String,
      style: popupTitle,
      textAlign: TextAlign.center,
    );
  }

  /// If the user is an admin, show the kills + phone number
  /// If the user is a player, show the kills
  SizedBox playerInfoPopup(Size size, int index) {
    return SizedBox(
      height: size.height * 0.07,
      child: Center(
        child: showType != ShowTypes.admin
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showPeople[index].child('kills').value.runtimeType == Null
                        ? 'JOINING AS A COORDINATOR!'
                        : 'Kills: ${showPeople[index].child('kills').value as int}',
                    style: popupText,
                    textAlign: TextAlign.left,
                  ),
                  adminMode
                      ? Text(
                          showPeople[index].child('phone').value! as String,
                          style: popupText,
                          textAlign: TextAlign.left,
                        )
                      : const SizedBox(),
                ],
              )
            : Column(
                children: [
                  const Text(
                    'Coordinator',
                    style: popupText,
                  ),
                  Text(
                    showPeople[index].child('phone').value! as String,
                    style: popupText,
                  ),
                ],
              ),
      ),
    );
  }

  /// Displays an image of the player in the popup
  SizedBox imagePopup(Size size, int index) {
    return SizedBox(
      child: CachedNetworkImage(
        height: size.height * 0.4,
        imageUrl: showPeople[index].child('photo_url').value as String,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  /// Shows the participant's picture in the preview
  SizedBox imagePreview(Size size, int index) {
    return SizedBox(
      height: size.height * 0.1,
      child: CachedNetworkImage(
        imageUrl: showPeople[index].child('photo_url').value as String,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            color: kCyanColor,
          ),
        ),
      ),
    );
  }

  /// Shows the name of the participant in preview
  Expanded namePreview(int index) {
    return Expanded(
      child: FittedBox(
        child: Text(
          showPeople[index].child('name').value.toString(),
          style: popupText,
        ),
      ),
    );
  }

  /// Shows the sort types for the list of people
  DropdownButton<SortTypes> showSortTypes() {
    return DropdownButton<SortTypes>(
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
              showPeople.sort((a, b) {
                int killsA = a.child('kills').value as int;
                int killsB = b.child('kills').value as int;
                return killsA - killsB;
              });
              break;
          }
        });
      },
    );
  }

  /// Shows the types of people to show
  DropdownButton<ShowTypes> showParticipantTypes() {
    return DropdownButton<ShowTypes>(
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
      },
    );
  }

  /// Updates the list of people in the game according to firebase
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
