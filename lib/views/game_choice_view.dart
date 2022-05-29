import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hse_assassin/constants/constants.dart';
import 'package:hse_assassin/constants/routes.dart';

enum MenuAction { logout }

class GameChoiceView extends StatefulWidget {
  const GameChoiceView({Key? key}) : super(key: key);

  @override
  State<GameChoiceView> createState() => _GameChoiceViewState();
}

class _GameChoiceViewState extends State<GameChoiceView> {
  late final TextEditingController _gameSearch;
  late final TextEditingController _newGameName;
  List<String>? games;

  bool? isAdmin;
  String? gameName;
  bool isNewGame = false;
  String? errorMessage;

  @override
  void initState() {
    _gameSearch = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _newGameName = TextEditingController()
      ..addListener(() {
        setState(() {
          gameName = _newGameName.text;
          _gameSearch.text = _newGameName.text;
        });
      });
    loadGames();
    super.initState();
  }

  @override
  void dispose() {
    _gameSearch.dispose();
    _newGameName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(color: kGreyColor, width: 3.0));
    return Scaffold(
      backgroundColor: kBlackColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: statusBarColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.8,
                    child: errorMessage == null
                        ? null
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.circleExclamation,
                                  color: kErrorColor),
                              Text(errorMessage ?? '',
                                  style: const TextStyle(color: kErrorColor)),
                            ],
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.4,
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isAdmin = true;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: isAdmin == true
                                ? MaterialStateProperty.all<Color>(
                                    kDarkGreyColor)
                                : MaterialStateProperty.all<Color>(kGreyColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              FaIcon(FontAwesomeIcons.userGear,
                                  color: kWhiteColor),
                              Text(textAdmin, style: generalText),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.07),
                      SizedBox(
                        width: size.width * 0.4,
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isAdmin = false;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: isAdmin != null && isAdmin != true
                                ? MaterialStateProperty.all<Color>(
                                    kDarkGreyColor)
                                : MaterialStateProperty.all<Color>(kGreyColor),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              FaIcon(FontAwesomeIcons.user, color: kWhiteColor),
                              Text(textPlayer, style: generalText),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                          child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: _gameSearch,
                              style: generalText,
                              decoration: const InputDecoration(
                                hintStyle: hintText,
                                prefixIcon: Icon(Icons.search),
                                hintText: textSearch,
                              ),
                              keyboardAppearance: Brightness.dark),
                        ),
                        SizedBox(
                          height: size.height * 0.12,
                          child: games != null
                              ? getGamesList(size)
                              : const Text('loading...'),
                        ),
                        Visibility(
                          visible: isAdmin ?? false,
                          child: SizedBox(
                            height: size.height * 0.04,
                            width: size.width * 0.8,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  isNewGame = true;
                                });
                              },
                              style: fancyGreyButton,
                              child: const Text(textCreateGame),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isNewGame,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                                width: size.width * 0.8,
                                child: TextField(
                                    controller: _newGameName,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 10.0,
                                      ),
                                      hintStyle: hintText,
                                      hintText: textNewGameName,
                                      enabledBorder: border,
                                      focusedBorder: border,
                                    ),
                                    style: generalText,
                                    autocorrect: false,
                                    keyboardAppearance: Brightness.dark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: size.height * 0.04,
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (isAdmin == null) {
                          setState(() {
                            errorMessage = textErrorNoType;
                          });
                        } else if (gameName == null) {
                          setState(() {
                            errorMessage = textErrorNoGame;
                          });
                        } else {
                          String id = FirebaseAuth.instance.currentUser!.uid;
                          final userRef =
                              FirebaseDatabase.instance.ref('users/$id');
                          await userRef.update({
                            "game": gameName,
                            "has_chosen_game": true,
                          });

                          final userOnce = await userRef.once();
                          final userSnapshot = userOnce.snapshot;
                          final gameRef =
                              FirebaseDatabase.instance.ref('games/$gameName');
                          final gameUserRef = gameRef.child('users/$id');
                          if (isAdmin!) {
                            await gameUserRef.set({
                              "admin": true,
                              "verified": isNewGame,
                              "name": userSnapshot.child("name").value,
                              "phone": userSnapshot.child("phone").value,
                              "photo_url":
                                  userSnapshot.child("photo_url").value,
                            });
                          } else {
                            await gameUserRef.set({
                              "verified": false,
                              "admin": false,
                              "kills": 0,
                              "alive": true,
                              "name": userSnapshot.child("name").value,
                              "phone": userSnapshot.child("phone").value,
                              "photo_url":
                                  userSnapshot.child("photo_url").value,
                            });
                          }
                          if (!mounted) return;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute,
                            (_) => false,
                          );
                        }
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(kBlackColor),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(kWhiteColor),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                      child: gameName != null
                          ? isNewGame
                              ? Text('Create "$gameName"')
                              : Text('Join "$gameName"')
                          : const Text('Join Game'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadGames() async {
    final userRef = FirebaseDatabase.instance.ref('games');
    final event = await userRef.once();
    final gameSnapshot = event.snapshot;
    List<String> games = [];
    for (DataSnapshot element in gameSnapshot.children) {
      games.add(element.key.toString());
    }
    games.sort();
    setState(() {
      this.games = games;
    });
  }

  ListView getGamesList(Size size) {
    List<String> matches = [];
    for (String element in games!) {
      if (element.toLowerCase().contains(_gameSearch.text.toLowerCase())) {
        matches.add(element);
      }
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: size.height * 0.03,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                isNewGame = false;
                gameName = matches[index];
                _gameSearch.text = matches[index];
              });
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    const BeveledRectangleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                foregroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
                backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            child: Text(matches[index]),
          ),
        );
      },
    );
  }
}
