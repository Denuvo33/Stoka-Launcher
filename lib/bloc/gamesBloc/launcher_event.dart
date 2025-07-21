part of 'launcher_bloc.dart';

abstract class LauncherEvent {}

class AddGames extends LauncherEvent {
  final GameModel gameModel;
  AddGames(this.gameModel);
}

class LaunchGame extends LauncherEvent {
  final GameModel gameModel;
  LaunchGame(this.gameModel);
}

class DeleteGame extends LauncherEvent {
  final GameModel gameModel;
  DeleteGame(this.gameModel);
}

class PickAndAddGame extends LauncherEvent {
  final String gameName;
  PickAndAddGame(this.gameName);
}

class EditGame extends LauncherEvent {
  final GameModel gameModel;
  final int index;
  EditGame({required this.gameModel, required this.index});
}

class PickGamePath extends LauncherEvent {}

class PickIconPath extends LauncherEvent {}

class FetchGameImage extends LauncherEvent {
  String? gameName;
  BuildContext? context;
  FetchGameImage({this.gameName, required this.context});
}

class SearchGame extends LauncherEvent {
  final String gameName;
  SearchGame(this.gameName);
}

class SortGame extends LauncherEvent {
  final String sort;
  SortGame(this.sort);
}
