import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_launcher_windows/Screen/home_screen.dart';
import 'package:game_launcher_windows/bloc/gamesBloc/launcher_bloc.dart';
import 'package:game_launcher_windows/bloc/softwareBloc/software_bloc.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  windowManager.setMinimumSize(const Size(800, 600));
  await dotenv.load(fileName: ".env");

  WindowOptions windowOptions = WindowOptions(
    center: true,
    size: const Size(1200, 800),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LauncherBloc()),
        BlocProvider(create: (context) => SoftwareBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      title: 'Stoka Launcher',
      home: HomeScreen(),
    );
  }
}
