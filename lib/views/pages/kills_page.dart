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
  List<List<String>> kills = [
    ["Daniel", "Haadi", "https://girlswithbigfeet.com"],
    ["Mark", "Alice", "https://girlswithbigfeet.com"]
  ];

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
                    setState(() {
                      // isNewGame = false;
                      // gameName = matches[index];
                      // _gameSearch.text = matches[index];
                    });
                  },
                  style: rectButton,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: kills[index][0],
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
                          text: kills[index][1],
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
}
