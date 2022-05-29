import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';

class KillsPage extends StatefulWidget {
  const KillsPage({Key? key}) : super(key: key);

  @override
  State<KillsPage> createState() => _KillsPageState();
}

class _KillsPageState extends State<KillsPage> {
  final List<String> openingDays = const ['2022-05-29 09:00:00Z'];
  bool adminMode = false;
  List<DataSnapshot> kills = [];
  late final StreamSubscription _killSubscription;
  late DatabaseReference killRef;

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
    return Column(
      children: [
        Visibility(
          visible: DateTime.now().isAfter(DateTime.parse(openingDays[0])),
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
                            child: Column(
                                /*
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
                            ],*/
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
                          text: kills[index].child("killer").value.toString(),
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
                          text: kills[index].child("killed").value.toString(),
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
    );
  }

  loadKills() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

    final adminSnapshot =
        await FirebaseDatabase.instance.ref('games/$game/users/$id').once();
    final admin = adminSnapshot.snapshot.child('admin').value as bool;
    final verified = adminSnapshot.snapshot.child('verified').value as bool;
    adminMode = admin && verified;

    killRef = FirebaseDatabase.instance.ref('games/$game/kills');
    if (!mounted) return;
    _killSubscription = killRef.onValue.listen((DatabaseEvent event) {
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
}
