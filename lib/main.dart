// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.light().copyWith(
          useMaterial3: true,
          textTheme:
              GoogleFonts.pressStart2pTextTheme(ThemeData.light().textTheme)),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          textTheme:
              GoogleFonts.pressStart2pTextTheme(ThemeData.dark().textTheme)),
      home: const Hangman(),
    );
  }
}

class Hangman extends StatefulWidget {
  const Hangman({Key? key}) : super(key: key);

  @override
  State<Hangman> createState() => _HangmanState();
}

class _HangmanState extends State<Hangman> {
  var alphabets = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  var pics = [
    "assets/hang6.gif",
    "assets/hang5.gif",
    "assets/hang4.gif",
    "assets/hang3.gif",
    "assets/hang2.gif",
    "assets/hang1.gif",
    "assets/hang0.gif"
  ];
  String secretword = "";
  String guessword = "";
  // ignore: unnecessary_new, prefer_collection_literals
  var guessedletters = [];
  int lives = 6;
  var pic = "";
  bool notdisablebtn = true;
  bool mute = false;
  bool start = true;
  final dropdownlist = ["Original", "Easy", "Medium", "Hard"];
  String dropdownvalue = "Original";
 
  void sound() {
    setState(() {
      mute = !mute;
      if (mute) {
        FlameAudio.bgm.stop();
      } else {
        FlameAudio.bgm.play('Bycicle.mp3');
      }
      // refresh();
    });
  }

  void navigate() {
    setState(() {
      start = !start;
    });
    reload();
  }


  Widget Startscreen() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(),
          Image.asset("assets/hang6.gif"),
          const Divider(),
          DropdownButton<String>(
            items: dropdownlist
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            value: dropdownvalue,
            onChanged: (val) {
              setState(() {
                dropdownvalue = val as String;
              });
            },
          ),
          TextButton(
              onPressed: () {
                navigate();
              },
              child: const Text(
                "Start",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  void showword() {
    for (var i in secretword.split('')) {
      guessedletters.add(i);
    }
    refresh();
  }

  void reload() {
    alphabets = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];
    guessword = "";
    pic = "";
    guessedletters = [];
    notdisablebtn = true;
    while (true) {
      secretword = nouns[Random().nextInt(nouns.length)];
      if (dropdownvalue == "Original") {
        lives = 6;
        refresh();
        break;
      } else if (dropdownvalue == "Easy" && secretword.length > 6) {
        guessedletters = [];
        guessedletters.add(alphabets[Random().nextInt(alphabets.length)]);
        alphabets[alphabets.indexOf(guessedletters[0])] = ' ';
        lives = 6;
        refresh();
        break;
      } else if (dropdownvalue == "Medium" &&
          (secretword.length == 6 || secretword.length == 5)) {
        lives = 6;
        refresh();
        break;
      } else if (dropdownvalue == "Hard" && secretword.length < 5) {
        lives = 5;
        refresh();
        break;
      }
    }
  }

  void refresh() {
    setState(() {
      guessword = "";
      for (int i = 0; i < secretword.length; i++) {
        String elem = secretword[i];
        if (guessedletters.contains(elem)) {
          guessword += elem;
        } else {
          guessword += "?";
        }
      }
      pic = pics[6 - lives];
      if (lives == 0 && notdisablebtn) {
        notdisablebtn = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("You Lost!"),
                content: const Text("Such a pity..."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        reload();
                      },
                      child: const Text("Play again")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showword();
                      },
                      child: const Text("Show word"))
                ],
              );
            });
      }
      if (guessword == secretword && notdisablebtn) {
        notdisablebtn = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("You Won!"),
                content: const Text("Great Job..."),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        reload();
                      },
                      child: const Text("Play again")),
                ],
              );
            });
      }
    });
  }

  void buttonpress(buttontext) {
    guessedletters.add(buttontext);
    alphabets[alphabets.indexOf(buttontext)] = ' ';
    if (secretword.contains(buttontext)) {
    } else {
      lives -= 1;
    }
    refresh();
  }

  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('Bycicle.mp3');
    reload();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FlameAudio.bgm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: start
                ? null
                : IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: () {
                      reload();
                    },
                  ),
            title: const Text("hangman"),
            centerTitle: true,
            actions: start
                ? <Widget>[
                    IconButton(
                        onPressed: () {
                          sound();
                        },
                        icon: Icon(mute
                            ? Icons.volume_off_sharp
                            : Icons.volume_up_sharp))
                  ]
                : <Widget>[
                    IconButton(
                        onPressed: () {
                          navigate();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    IconButton(
                        onPressed: () {
                          sound();
                        },
                        icon: Icon(mute
                            ? Icons.volume_off_sharp
                            : Icons.volume_up_sharp))
                  ]),
        body: start
            ? Startscreen()
            : Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Center(
                              child: Text(
                        "$lives chances",
                        style: const TextStyle(fontSize: 20),
                      ))),
                      Image(
                        image: AssetImage(pic),
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        guessword,
                        style: const TextStyle(fontSize: 30),
                      ))),
                      const Divider(
                        thickness: 2,
                      ),
                      Expanded(
                        flex: 2,
                        child: GridView.count(
                          crossAxisCount: 9,
                          shrinkWrap: true,
                          children: List.generate(alphabets.length, (i) {
                            bool isDisabled =
                                !notdisablebtn || alphabets[i] == ' ';
                            return InkWell(
                              radius: 50,
                              onTap: isDisabled
                                  ? null
                                  : () => buttonpress(alphabets[i]),
                              child: Center(
                                  child: Text(
                                alphabets[i],
                                style: const TextStyle(fontSize: 17),
                              )),
                            );
                          }),
                        ),
                      ),
                    ]),
              ));
  }
}
