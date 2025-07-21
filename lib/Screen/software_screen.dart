import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/add_software_screen.dart';
import 'package:game_launcher_windows/bloc/softwareBloc/software_bloc.dart';

// ignore: must_be_immutable
class SoftwareScreen extends StatelessWidget {
  SoftwareScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: BlocBuilder<SoftwareBloc, SoftwareState>(
        builder: (context, state) {
          if (state.software.isEmpty && _searchController.text.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text('No Software'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSoftwareScreen(software: null),
                      ),
                    );
                  },
                  child: Text('Add new Software'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SearchBar(
                  controller: _searchController,
                  hintText: 'Search App',
                  onChanged: (search) {
                    context.read<SoftwareBloc>().add(
                      SearchSoftware(softwareName: search),
                    );
                  },
                ),
                Row(
                  children: [
                    PopupMenuButton(
                      itemBuilder: (_) {
                        return [
                          PopupMenuItem(
                            value: 'Date New',
                            child: Text('Date New'),
                            onTap:
                                () => context.read<SoftwareBloc>().add(
                                  SortSofware(sort: 'Date New'),
                                ),
                          ),
                          PopupMenuItem(
                            value: 'Date Old',
                            child: Text('Date Old'),
                            onTap:
                                () => context.read<SoftwareBloc>().add(
                                  SortSofware(sort: 'Date Old'),
                                ),
                          ),
                          PopupMenuItem(
                            value: 'Name',
                            child: Text('Name'),
                            onTap:
                                () => context.read<SoftwareBloc>().add(
                                  SortSofware(sort: 'Name'),
                                ),
                          ),
                        ];
                      },
                    ),
                    Text(state.sort ?? 'Date Old'),
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
                                (context) => AddSoftwareScreen(software: null),
                          ),
                        );
                      },
                      child: Text('Add new Software'),
                    ),
                  ],
                ),
                Wrap(
                  children:
                      state.software.asMap().entries.map((entry) {
                        var software = entry.value;
                        var index = entry.key;
                        return GestureDetector(
                          onTap: () {
                            context.read<SoftwareBloc>().add(
                              RunSoftware(software: software),
                            );
                          },
                          child: Tooltip(
                            message: software.name,
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
                                            software.iconPath ??
                                            'https://img.freepik.com/free-vector/yellow-folder-flat-style_78370-6671.jpg?semt=ais_hybrid&w=740',
                                        placeholder:
                                            (context, url) =>
                                                CircularProgressIndicator(),
                                        errorWidget:
                                            (context, url, error) => Card(
                                              color: Colors.blueAccent,
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(software.name!),
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 164,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (builder) =>
                                                          AddSoftwareScreen(
                                                            software: software,
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
                                              context.read<SoftwareBloc>().add(
                                                DeleteSoftware(
                                                  software: software,
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context.read<SoftwareBloc>().add(
                                                RunSoftware(software: software),
                                              );
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
          );
        },
      ),
    );
  }
}
