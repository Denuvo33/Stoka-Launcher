import 'package:flutter/material.dart';
import 'package:game_launcher_windows/Screen/games_screen.dart';
import 'package:game_launcher_windows/Screen/software_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> page = [
    GamesScreen(),
    SoftwareScreen(),
    Container(child: Text('Not available')),
    Container(child: Text('Not available')),
  ];
  int index = 0;
  List<Color> colors = [
    Colors.green,
    Colors.blueAccent,
    Colors.blueGrey,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: ListTile(
                    tileColor: index == 0 ? colors[0] : null,
                    title: Text('Games'),
                    leading: Icon(Icons.games_rounded),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: ListTile(
                    tileColor: index == 1 ? colors[1] : null,
                    title: Text('Software'),
                    leading: Icon(Icons.folder),
                  ),
                ),
                InkWell(
                  onTap: () {
                    index = 2;
                    setState(() {});
                  },
                  child: ListTile(
                    tileColor: index == 2 ? colors[2] : null,
                    title: Text('Theme'),
                    leading: Icon(Icons.data_saver_off_outlined),
                  ),
                ),
                InkWell(
                  onTap: () {
                    index = 3;
                    setState(() {});
                  },
                  child: ListTile(
                    tileColor: index == 3 ? colors[3] : null,
                    title: Text('Buy me a Coffe'),
                    leading: Icon(Icons.coffee),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(color: Colors.white),
          Expanded(child: page[index]),
        ],
      ),
    );
  }
}
