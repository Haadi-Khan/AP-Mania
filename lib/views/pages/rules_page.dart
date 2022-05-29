import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hse_assassin/constants/constants.dart';
import 'dart:developer' as devtools show log;

class RulesPage extends StatefulWidget {
  const RulesPage({Key? key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  List<bool> showing = [];

  @override
  void initState() {
    for (int i = 0; i < 9; i++) {
      showing.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarColorScroll,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[0] = !showing[0];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle1,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[0],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent1,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[1] = !showing[1];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle2,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[1],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent2,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[2] = !showing[2];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle3,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[2],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent3,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[3] = !showing[3];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle4,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[3],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent4,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[4] = !showing[4];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle5,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[4],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent5,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[5] = !showing[5];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle6,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[5],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent6,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[6] = !showing[6];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle7,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[6],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent7,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[7] = !showing[7];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle8,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[7],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent8,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
                width: size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: kDarkGreyColor))),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showing[8] = !showing[8];
                      });
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(kBlackColor),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: textRulesTitle9,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showing[8],
                child: SizedBox(
                  width: size.width * 0.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: textRulesContent9,
                            style: TextStyle(color: kBlackColor, fontSize: 15),
                          ),
                        ],
                      ),
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
}

AppBar rulesBar() {
  return AppBar();
}
