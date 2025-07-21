import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/add_games_screen.dart';
import 'package:game_launcher_windows/bloc/gamesBloc/launcher_bloc.dart';

class GamesScreen extends StatelessWidget {
  GamesScreen({super.key});
  final TextEditingController _searchGame = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final launcherBloc = context.read<LauncherBloc>();

    return BlocListener<LauncherBloc, LauncherState>(
      listener: (context, state) {
        if (state.launchGame) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                  title: Text('Starting Game'),
                  content: Center(
                    heightFactor: 1,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
          );
        }
      },
      child: BlocBuilder<LauncherBloc, LauncherState>(
        builder: (context, state) {
          return launcherBloc.state.games.isEmpty && _searchGame.text.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      'You dont have any Games😢',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AddGamesScreen(gameModel: null),
                          ),
                        );
                      },
                      child: Text('Add Games'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20,
                    children: [
                      SearchBar(
                        hintText: "Search Game",
                        controller: _searchGame,
                        onChanged: (value) {
                          launcherBloc.add(SearchGame(value));
                        },
                      ),
                      Row(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'Date New',
                                  onTap: () {
                                    launcherBloc.add(SortGame('Date New'));
                                  },
                                  child: Text('Date New'),
                                ),
                                PopupMenuItem(
                                  value: 'Date Old',
                                  onTap: () {
                                    launcherBloc.add(SortGame('Date Old'));
                                  },
                                  child: Text('Date Old'),
                                ),
                                PopupMenuItem(
                                  value: 'Name',
                                  onTap: () {
                                    launcherBloc.add(SortGame('Name'));
                                  },
                                  child: Text('Name'),
                                ),
                              ];
                            },
                          ),
                          Text(launcherBloc.state.sort!),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          AddGamesScreen(gameModel: null),
                                ),
                              );
                            },
                            child: Text('Add new Games'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children:
                            state.games.asMap().entries.map((entry) {
                              var game = entry.value;
                              var index = entry.key;
                              return GestureDetector(
                                onTap: () {
                                  launcherBloc.add(LaunchGame(game));
                                },
                                child: Tooltip(
                                  message: game.name,
                                  waitDuration: Duration(milliseconds: 500),
                                  preferBelow: true,
                                  child: SizedBox(
                                    width: 154,
                                    child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  game.iconPath ??
                                                  'https://i.pinimg.com/736x/13/99/96/139996638662345f34ad4f39895be5f7.jpg',
                                              placeholder:
                                                  (context, url) =>
                                                      CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) => Card(
                                                    color: Colors.blueAccent,
                                                    child: Container(
                                                      margin: EdgeInsets.all(
                                                        10,
                                                      ),
                                                      child: Text(game.name!),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: 164,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AddGamesScreen(
                                                                  gameModel:
                                                                      game,
                                                                  index: index,
                                                                ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.settings,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    launcherBloc.add(
                                                      DeleteGame(game),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<LauncherBloc>()
                                                        .add(LaunchGame(game));
                                                  },
                                                  icon: Icon(
                                                    size: 40,
                                                    Icons.play_arrow_rounded,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
