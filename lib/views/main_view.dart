import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';

import 'package:hse_assassin/views/pages/home_page.dart';
import 'package:hse_assassin/views/pages/kills_page.dart';
import 'package:hse_assassin/views/pages/people_page.dart';
import 'package:hse_assassin/views/pages/rules_page.dart';
import 'package:hse_assassin/views/pages/hints_page.dart';
import 'package:hse_assassin/views/pages/verify_page.dart';

enum Pages { rules, hints, home, people, kills }

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool verified = false;
  Pages page = Pages.home;
  late final StreamSubscription _verifiedSubscription;

  @override
  void initState() {
    loadVerified();
    super.initState();
  }

  @override
  void dispose() {
    _verifiedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: getAppBar(page, context, this),
      body: getPage(page, verified),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: kBlackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: kBlackColor,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.rules;
                });
              },
              icon: page == Pages.rules
                  ? const FaIcon(FontAwesomeIcons.book, color: kRedColor)
                  : const FaIcon(FontAwesomeIcons.book, color: kGreyColor),
            ),
            IconButton(
              color: kBlackColor,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.hints;
                });
              },
              icon: page == Pages.hints
                  ? const FaIcon(FontAwesomeIcons.puzzlePiece, color: kRedColor)
                  : const FaIcon(FontAwesomeIcons.puzzlePiece,
                      color: kGreyColor),
            ),
            IconButton(
              color: kBlackColor,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.home;
                });
              },
              icon: page == Pages.home
                  ? const FaIcon(FontAwesomeIcons.house, color: kRedColor)
                  : const FaIcon(FontAwesomeIcons.house, color: kGreyColor),
            ),
            IconButton(
              color: kBlackColor,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.people;
                });
              },
              icon: page == Pages.people
                  ? const FaIcon(FontAwesomeIcons.userGroup, color: kRedColor)
                  : const FaIcon(FontAwesomeIcons.userGroup, color: kGreyColor),
            ),
            IconButton(
              color: kBlackColor,
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.kills;
                });
              },
              icon: page == Pages.kills
                  ? const FaIcon(FontAwesomeIcons.skull, color: kRedColor)
                  : const FaIcon(FontAwesomeIcons.skull, color: kGreyColor),
            ),
          ],
        ),
      ),
    );
  }

  loadVerified() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    final gameSnapshot =
        await FirebaseDatabase.instance.ref('users/$id/game').once();
    final game = gameSnapshot.snapshot.value;

    final verifiedRef =
        FirebaseDatabase.instance.ref('games/$game/users/$id/verified');
    _verifiedSubscription = verifiedRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        verified = event.snapshot.value as bool;
      });
    });
  }
}

AppBar getAppBar(Pages page, BuildContext context, State state) {
  switch (page) {
    case Pages.hints:
      return hintsBar(context, state);
    case Pages.rules:
      return rulesBar(context, state);
    case Pages.home:
      return homeBar(context, state);
    case Pages.people:
      return peopleBar(context, state);
    case Pages.kills:
      return killBar(context, state);
  }
}

Widget getPage(Pages page, bool verified) {
  if (verified) {
    switch (page) {
      case Pages.hints:
        return const HintsPage();
      case Pages.rules:
        return const RulesPage();
      case Pages.home:
        return const HomePage();
      case Pages.people:
        return const PeoplePage();
      case Pages.kills:
        return const KillsPage();
    }
  } else {
    switch (page) {
      case Pages.rules:
        return const RulesPage();
      default:
        return const VerifyPage();
    }
  }
}
