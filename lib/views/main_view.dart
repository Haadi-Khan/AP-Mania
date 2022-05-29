import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';

import 'package:hse_assassin/views/pages/home_page.dart';
import 'package:hse_assassin/views/pages/kills_page.dart';
import 'package:hse_assassin/views/pages/people_page.dart';
import 'package:hse_assassin/views/pages/rules_page.dart';
import 'package:hse_assassin/views/pages/hints_page.dart';

enum Pages { rules, hints, home, people, kills }

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Pages page = Pages.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: getAppBar(page, context, this),
      body: getPage(page),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.rules;
                });
              },
              icon: page == Pages.rules
                  ? const FaIcon(FontAwesomeIcons.book, color: kErrorColor)
                  : const FaIcon(FontAwesomeIcons.book, color: kRedColor),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.hints;
                });
              },
              icon: page == Pages.hints
                  ? const FaIcon(FontAwesomeIcons.puzzlePiece,
                      color: kErrorColor)
                  : const FaIcon(FontAwesomeIcons.puzzlePiece,
                      color: kRedColor),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.home;
                });
              },
              icon: page == Pages.home
                  ? const FaIcon(FontAwesomeIcons.house, color: kErrorColor)
                  : const FaIcon(FontAwesomeIcons.house, color: kRedColor),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.people;
                });
              },
              icon: page == Pages.people
                  ? const FaIcon(FontAwesomeIcons.userGroup, color: kErrorColor)
                  : const FaIcon(FontAwesomeIcons.userGroup, color: kRedColor),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  page = Pages.kills;
                });
              },
              icon: page == Pages.kills
                  ? const FaIcon(FontAwesomeIcons.skull, color: kErrorColor)
                  : const FaIcon(FontAwesomeIcons.skull, color: kRedColor),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar getAppBar(Pages page, BuildContext context, State state) {
  switch (page) {
    case Pages.hints:
      return rulesBar();
    case Pages.rules:
      return rulesBar();
    case Pages.home:
      return homeBar(context, state);
    case Pages.people:
      return rulesBar();
    case Pages.kills:
      return rulesBar();
  }
}

Widget getPage(Pages page) {
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
}
