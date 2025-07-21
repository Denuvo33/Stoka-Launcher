import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/bloc/softwareBloc/software_bloc.dart';
import 'package:game_launcher_windows/model/software_model.dart';

class AddSoftwareScreen extends StatefulWidget {
  final SoftwareModel? software;
  final int? index;
  const AddSoftwareScreen({super.key, required this.software, this.index});

  @override
  State<AddSoftwareScreen> createState() => _AddSoftwareScreenState();
}

class _AddSoftwareScreenState extends State<AddSoftwareScreen> {
  final TextEditingController title = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.software != null) {
      title.text = widget.software!.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.software != null ? 'Edit Software' : 'Add Software'),
      ),
      body: BlocBuilder<SoftwareBloc, SoftwareState>(
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
                      'Please press Enter after type Software Name to get the Image Cover of the App, please Note right now not every Software have image cover',
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
                                      ? widget.software == null
                                          ? 'https://img.freepik.com/free-vector/yellow-folder-flat-style_78370-6671.jpg?semt=ais_hybrid&w=740'
                                          : widget.software!.iconPath!
                                      : state.tempIconPath!,
                              placeholder:
                                  (context, url) => CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        Text(
                          'Software Image',
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
                      state.tempSoftwarePath == 'none' ||
                              state.tempSoftwarePath == null
                          ? widget.software == null
                              ? 'Software Path'
                              : widget.software!.path!
                          : state.tempSoftwarePath!,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<SoftwareBloc>().add(PickSoftwarePath());
                      },
                      icon: Icon(Icons.folder),
                    ),
                  ),
                  TextField(
                    controller: title,
                    onSubmitted: (value) {
                      context.read<SoftwareBloc>().add(
                        FetchSoftwareImage(name: title.text, context: context),
                      );
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Software Name',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (title.text.isEmpty &&
                              state.tempSoftwarePath == null ||
                          state.tempSoftwarePath == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter Software name or Software Path',
                            ),
                          ),
                        );
                        return;
                      } else if (widget.software != null) {
                        context.read<SoftwareBloc>().add(
                          UpdateSoftware(
                            software: SoftwareModel(
                              path:
                                  state.tempSoftwarePath == 'none' ||
                                          state.tempSoftwarePath == null
                                      ? widget.software!.path
                                      : state.tempSoftwarePath,
                              name: title.text,
                              iconPath:
                                  state.tempIconPath == 'none' ||
                                          state.tempIconPath == null
                                      ? widget.software!.iconPath
                                      : state.tempIconPath,
                            ),
                            index: widget.index!,
                          ),
                        );
                      } else {
                        context.read<SoftwareBloc>().add(
                          AddSoftware(name: title.text),
                        );
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Software Saved')));
                    },
                    child: Text(
                      widget.software != null
                          ? 'Update Software'
                          : 'Save Software',
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
