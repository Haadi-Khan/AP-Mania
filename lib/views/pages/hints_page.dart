import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_assassin/constants/constants.dart';

class HintsPage extends StatefulWidget {
  const HintsPage({Key? key}) : super(key: key);

  @override
  State<HintsPage> createState() => _HintsPageState();
}

class _HintsPageState extends State<HintsPage> {
  List<DataSnapshot> hints = [];
  late final StreamSubscription _hintSubscription;
  bool adminMode = false;
  late DatabaseReference hintsRef;

  @override
  void initState() {
    loadHints();
    super.initState();
  }

  @override
  void dispose() {
    _hintSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarColorScroll,
      child: adminMode
          ? Stack(children: const [Text('hello')])
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                ListView.builder(
                  itemCount: hints.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.8,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: hints[index]
                                            .child('photo_url')
                                            .value
                                            .toString() !=
                                        ''
                                    ? SizedBox(
                                        height: size.height * 0.3,
                                        child: CachedNetworkImage(
                                          imageUrl: hints[index]
                                              .child('photo_url')
                                              .value as String,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              hints[index].child('text').value.toString() != ''
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: hints[index]
                                                  .child('text')
                                                  .value as String,
                                              style: generalText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }

  loadHints() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameEvent =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameEvent.snapshot.value;

    final usersEvent =
        await FirebaseDatabase.instance.ref('games/$game/users/$id').once();
    final userSnapshot = usersEvent.snapshot;
    final admin = userSnapshot.child('admin').value as bool;
    final verified = userSnapshot.child('verified').value as bool;
    adminMode = admin && verified;

    hintsRef = FirebaseDatabase.instance.ref('games/$game/hints');
    if (!mounted) return;
    _hintSubscription = hintsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> hintsRefs = [];
      for (DataSnapshot hint in data) {
        hintsRefs.add(hint);
      }
      setState(() {
        hints = hintsRefs;
      });
    });
  }
}

AppBar hintsBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Hints', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
