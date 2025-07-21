part of 'launcher_bloc.dart';

class LauncherState extends Equatable {
  final List<GameModel> games;
  final String? tempGamePath;
  final String? tempIconPath;
  final bool launchGame;
  final String? sort;

  const LauncherState({
    this.games = const [],
    this.tempGamePath,
    this.tempIconPath,
    this.launchGame = false,
    this.sort,
  });

  LauncherState copyWith({
    List<GameModel>? games,
    List<GameModel>? searchGames,
    String? tempGamePath,
    String? tempIconPath,
    bool? launchGame,
    String? sort,
  }) {
    return LauncherState(
      games: games ?? this.games,
      tempGamePath: tempGamePath ?? this.tempGamePath,
      tempIconPath: tempIconPath ?? this.tempIconPath,
      launchGame: launchGame ?? this.launchGame,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    games,
    tempGamePath,
    tempIconPath,
    launchGame,
    sort,
  ];
}
