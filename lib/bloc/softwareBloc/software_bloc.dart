// ignore: depend_on_referenced_packages
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_launcher_windows/model/software_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'software_event.dart';
part 'software_state.dart';

class SoftwareBloc extends Bloc<SoftwareEvent, SoftwareState> {
  late Box<SoftwareModel> box;
  SoftwareBloc() : super(const SoftwareState()) {
    _init();

    on<RunSoftware>((event, emit) async {
      emit(state.copyWith(launchSoftware: true));
      Process.run(event.software.path!, []);
    });

    on<DeleteSoftware>((event, emit) async {
      final updatedList = List<SoftwareModel>.from(state.software)
        ..remove(event.software);
      await event.software.delete();
      emit(state.copyWith(software: updatedList));
    });

    on<AddSoftware>((event, emit) {
      var software = SoftwareModel(
        path: state.tempSoftwarePath,
        name: event.name,
        iconPath: state.tempIconPath,
      );
      box.add(software);
      emit(
        state.copyWith(
          tempSoftwarePath: 'none',
          tempIconPath: 'none',
          software: box.values.toList(),
        ),
      );
    });

    on<SearchSoftware>((event, emit) {
      var software = box.values.toList();
      var searchGame =
          software
              .where(
                (app) => app.name.toString().toLowerCase().contains(
                  event.softwareName.toLowerCase(),
                ),
              )
              .toList();

      emit(state.copyWith(software: searchGame));
    });

    on<SortSofware>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('sortSoftware', event.sort);
      switch (event.sort) {
        case 'Date Old':
          state.software.sort((a, b) => a.key.compareTo(b.key));
        case 'Date New':
          state.software.sort((a, b) => b.key.compareTo(a.key));
        default:
          state.software.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
          );
      }
      emit(state.copyWith(sort: event.sort));
    });

    on<UpdateSoftware>((event, emit) async {
      var software = state.software[event.index];

      software
        ..name = event.software.name!
        ..iconPath = event.software.iconPath
        ..path = event.software.path;

      await software.save();
      emit(
        state.copyWith(
          software: List.from(state.software),
          tempSoftwarePath: 'none',
          tempIconPath: 'none',
        ),
      );
    });

    on<PickSoftwarePath>((event, emit) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['exe'],
      );
      if (result != null && result.files.single.path != null) {
        final softwarePath = result.files.single.path!;
        emit(state.copyWith(tempSoftwarePath: softwarePath));
      }
    });
    on<FetchSoftwareImage>((event, emit) async {
      final dio = Dio();
      debugPrint('start seacrh software');
      try {
        final response = await dio.get(
          'https://www.steamgriddb.com/api/v2/search/autocomplete/${event.name}',
          options: Options(
            headers: {'Authorization': 'Bearer ${dotenv.env['STEAM_API']}'},
          ),
        );

        if (response.statusCode == 200) {
          var id = response.data['data'][0]['id'];

          final response2 = await dio.get(
            'https://www.steamgriddb.com/api/v2/grids/game/$id',
            options: Options(
              headers: {'Authorization': 'Bearer ${dotenv.env['STEAM_API']}'},
            ),
          );
          if (response2.statusCode == 200) {
            var image = response2.data['data'][0]['url'];
            emit(state.copyWith(tempIconPath: image));
          }
        }
      } catch (e) {
        debugPrint('error $e');
        ScaffoldMessenger.of(event.context!).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to get image, please make sure the App Name is correct or Check your connection',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SoftwareModelAdapter());
    box = await Hive.openBox<SoftwareModel>('software');
    List<SoftwareModel> software = box.values.toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (prefs.getString('sortSoftware') ?? 'Date Old') {
      case 'Date Old':
        software.sort((a, b) => a.key.compareTo(b.key));
      case 'Date New':
        software.sort((a, b) => b.key.compareTo(a.key));
      default:
        software.sort((a, b) => a.name!.compareTo(b.name!));
    }
    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      state.copyWith(
        software: software,
        sort: prefs.getString('sortSoftware') ?? 'Date Old',
      ),
    );
  }
}
