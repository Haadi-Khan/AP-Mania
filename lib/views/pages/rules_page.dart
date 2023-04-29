import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/wrapper/assassin_wrapper.dart';

/// This page displays the rules of the game.
class RulesPage extends StatefulWidget {
  const RulesPage({Key? key}) : super(key: key);

  @override
  AssassinState<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends AssassinState<RulesPage> {
  late final TextEditingController _ruleTitle;
  late final TextEditingController _ruleBody;

  List<DataSnapshot> rules = [];
  List<bool> showing = [];
  late final StreamSubscription _testSubscription;
  bool adminMode = false;
  late DatabaseReference rulesRef;
  bool loaded = false;

  @override
  void initState() {
    _ruleTitle = TextEditingController();
    _ruleBody = TextEditingController();
    loadRules();
    super.initState();
  }

  @override
  void dispose() {
    _ruleTitle.dispose();
    _ruleBody.dispose();
    _testSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarColorMain,
      child: loaded
          ? Stack(
              alignment: Alignment.topCenter,
              children: [
                ListView.builder(
                  itemCount: rules.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.9,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 1.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2.0, color: kDarkGreyColor))),
                            child: Stack(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      showing[index] = !showing[index];
                                    });
                                  },
                                  style: underlinedButton,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: showing[index]
                                                ? const FaIcon(
                                                    FontAwesomeIcons.chevronUp,
                                                    size: 17,
                                                  )
                                                : const FaIcon(
                                                    FontAwesomeIcons
                                                        .chevronDown,
                                                    size: 17,
                                                  ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: size.width * 0.03),
                                          ),
                                          TextSpan(
                                            text: rules[index]
                                                .child('title')
                                                .value as String,
                                            style: buttonInfo,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: adminMode,
                                  child: Positioned(
                                    bottom: 5,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        CupertinoButton(
                                          minSize: double.minPositive,
                                          padding: const EdgeInsets.all(5),
                                          child: const FaIcon(
                                            FontAwesomeIcons.caretUp,
                                            size: 20,
                                            color: kWhiteColor,
                                          ),
                                          onPressed: () async {
                                            if (index > 0) {
                                              final oldCurrentText =
                                                  rules[index]
                                                      .child('text')
                                                      .value as String;
                                              final oldCurrentTitle =
                                                  rules[index]
                                                      .child('title')
                                                      .value as String;
                                              final oldPrevText =
                                                  rules[index - 1]
                                                      .child('text')
                                                      .value as String;
                                              final oldPrevTitle =
                                                  rules[index - 1]
                                                      .child('title')
                                                      .value as String;
                                              await rulesRef
                                                  .child('$index')
                                                  .update({
                                                'text': oldPrevText,
                                                'title': oldPrevTitle,
                                              });
                                              await rulesRef
                                                  .child('${index - 1}')
                                                  .update({
                                                'text': oldCurrentText,
                                                'title': oldCurrentTitle,
                                              });
                                            }
                                          },
                                        ),
                                        CupertinoButton(
                                          minSize: double.minPositive,
                                          padding: const EdgeInsets.all(5),
                                          child: const FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            size: 20,
                                            color: kWhiteColor,
                                          ),
                                          onPressed: () async {
                                            if (index < rules.length - 1) {
                                              final oldCurrentText =
                                                  rules[index]
                                                      .child('text')
                                                      .value as String;
                                              final oldCurrentTitle =
                                                  rules[index]
                                                      .child('title')
                                                      .value as String;
                                              final oldNextText =
                                                  rules[index + 1]
                                                      .child('text')
                                                      .value as String;
                                              final oldNextTitle =
                                                  rules[index + 1]
                                                      .child('title')
                                                      .value as String;
                                              await rulesRef
                                                  .child('$index')
                                                  .update({
                                                'text': oldNextText,
                                                'title': oldNextTitle,
                                              });
                                              await rulesRef
                                                  .child('${index + 1}')
                                                  .update({
                                                'text': oldCurrentText,
                                                'title': oldCurrentTitle,
                                              });
                                            }
                                          },
                                        ),
                                        CupertinoButton(
                                          minSize: double.minPositive,
                                          padding: const EdgeInsets.all(5),
                                          child: const FaIcon(
                                            FontAwesomeIcons.pen,
                                            size: 20,
                                            color: kWhiteColor,
                                          ),
                                          onPressed: () {
                                            _ruleTitle.text = rules[index]
                                                .child('title')
                                                .value as String;
                                            _ruleBody.text = rules[index]
                                                .child('text')
                                                .value as String;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: kBlackColor,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        20.0,
                                                      ),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  title: TextField(
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    style: buttonInfo,
                                                    controller: _ruleTitle,
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                  content: Stack(
                                                    children: [
                                                      SizedBox(
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.6,
                                                        child: TextField(
                                                          keyboardAppearance:
                                                              Brightness.dark,
                                                          style: generalText,
                                                          controller: _ruleBody,
                                                          expands: true,
                                                          maxLines: null,
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 10,
                                                        right: 10,
                                                        child: ElevatedButton(
                                                          style: redButton,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            rulesRef
                                                                .child(
                                                                    rules[index]
                                                                        .key!)
                                                                .update({
                                                              'title':
                                                                  _ruleTitle
                                                                      .text,
                                                              'text':
                                                                  _ruleBody.text
                                                            });
                                                          },
                                                          child: const Text(
                                                              'SAVE'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        CupertinoButton(
                                          minSize: double.minPositive,
                                          padding: const EdgeInsets.all(5),
                                          child: const FaIcon(
                                            FontAwesomeIcons.trash,
                                            size: 20,
                                            color: kRedColor,
                                          ),
                                          onPressed: () {
                                            for (int i = index;
                                                i < rules.length - 1;
                                                i++) {
                                              rulesRef.child('$i').set({
                                                'text': rules[i + 1]
                                                    .child('text')
                                                    .value!,
                                                'title': rules[i + 1]
                                                    .child('title')
                                                    .value!
                                              });
                                            }
                                            rulesRef
                                                .child('${rules.length - 1}')
                                                .remove();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showing[index],
                          child: SizedBox(
                            width: size.width * 0.9,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: rules[index].child('text').value
                                          as String,
                                      style: generalText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Visibility(
                  visible: adminMode,
                  child: Positioned(
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
                          onPressed: () {
                            _ruleTitle.clear();
                            _ruleBody.clear();
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
                                  title: TextField(
                                    style: smallerHeading,
                                    keyboardAppearance: Brightness.dark,
                                    controller: _ruleTitle,
                                    decoration: const InputDecoration(
                                      hintStyle: hintText,
                                      filled: true,
                                      fillColor: kBlackColor,
                                      border: InputBorder.none,
                                      hintText: textRulesSectionTemp,
                                    ),
                                  ),
                                  content: Stack(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.8,
                                        height: size.height * 0.6,
                                        child: TextField(
                                          style: generalText,
                                          keyboardAppearance: Brightness.dark,
                                          controller: _ruleBody,
                                          expands: true,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            hintStyle: hintText,
                                            filled: true,
                                            fillColor: kBlackColor,
                                            border: InputBorder.none,
                                            hintText: textRulesBodyTemp,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: ElevatedButton(
                                          style: redButton,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            rulesRef
                                                .child('${rules.length}')
                                                .update({
                                              'title': _ruleTitle.text,
                                              'text': _ruleBody.text
                                            });
                                          },
                                          child: const Text('SAVE'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : super.loading_menu(context),
    );
  }

  loadRules() async {
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

    rulesRef = FirebaseDatabase.instance.ref('games/$game/rules');
    if (!mounted) return;
    _testSubscription = rulesRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<DataSnapshot> rulesRefs = List.from(data);
      setState(() {
        rules = rulesRefs;
        for (int i = 0; i < rules.length; i++) {
          showing.add(false);
        }
      });
    });

    setState(() {
      loaded = true;
    });
  }
}

AppBar rulesBar(BuildContext context, State state) {
  return AppBar(
    title: const Text('Rules', style: smallerHeading),
    backgroundColor: kBlackColor,
  );
}
