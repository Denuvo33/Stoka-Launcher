import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/bloc/gamesBloc/launcher_bloc.dart';
import 'package:game_launcher_windows/model/game_model.dart';

class AddGamesScreen extends StatefulWidget {
  final GameModel? gameModel;
  final int? index;
  const AddGamesScreen({super.key, required this.gameModel, this.index});

  @override
  State<AddGamesScreen> createState() => _AddGamesScreenState();
}

class _AddGamesScreenState extends State<AddGamesScreen> {
  final TextEditingController title = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.gameModel != null) {
      title.text = widget.gameModel!.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameModel != null ? 'Edit Games' : 'Add Games'),
      ),
      body: BlocBuilder<LauncherBloc, LauncherState>(
        builder: (context, state) {
          state.copyWith();
          return Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Please press Enter after type Game Name to get the Image Cover of the Game',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:
                                  state.tempIconPath == 'none' ||
                                          state.tempIconPath == null
                                      ? widget.gameModel == null
                                          ? 'https://i.pinimg.com/736x/13/99/96/139996638662345f34ad4f39895be5f7.jpg'
                                          : widget.gameModel!.iconPath!
                                      : state.tempIconPath!,
                              placeholder:
                                  (context, url) => CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        Text(
                          'Game Image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      state.tempGamePath == 'none' || state.tempGamePath == null
                          ? widget.gameModel == null
                              ? 'Game Path'
                              : widget.gameModel!.path!
                          : state.tempGamePath!,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<LauncherBloc>().add(PickGamePath());
                      },
                      icon: Icon(Icons.folder),
                    ),
                  ),
                  TextField(
                    controller: title,
                    onSubmitted: (value) {
                      context.read<LauncherBloc>().add(
                        FetchGameImage(gameName: value, context: context),
                      );
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Game Name',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (title.text.isEmpty && state.tempGamePath == null ||
                          state.tempGamePath == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter Game name or Game Path',
                            ),
                          ),
                        );
                        return;
                      } else if (widget.gameModel != null) {
                        context.read<LauncherBloc>().add(
                          EditGame(
                            index: widget.index!,
                            gameModel: GameModel(
                              path:
                                  state.tempGamePath == 'none' ||
                                          state.tempGamePath == null
                                      ? widget.gameModel!.path
                                      : state.tempGamePath,
                              name: title.text,
                              iconPath:
                                  state.tempIconPath == 'none' ||
                                          state.tempIconPath == null
                                      ? widget.gameModel!.iconPath
                                      : state.tempIconPath,
                            ),
                          ),
                        );
                      } else {
                        context.read<LauncherBloc>().add(
                          PickAndAddGame(title.text),
                        );
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Game Saved')));
                    },
                    child: Text(
                      widget.gameModel != null ? 'Update Game' : 'Save Game',
                    ),
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
