part of 'software_bloc.dart';

abstract class SoftwareEvent {}

class FetchSoftware extends SoftwareEvent {}

class RunSoftware extends SoftwareEvent {
  final SoftwareModel software;
  RunSoftware({required this.software});
}

class AddSoftware extends SoftwareEvent {
  final String name;
  AddSoftware({required this.name});
}

class PickSoftwarePath extends SoftwareEvent {
  PickSoftwarePath();
}

class DeleteSoftware extends SoftwareEvent {
  final SoftwareModel software;
  DeleteSoftware({required this.software});
}

class UpdateSoftware extends SoftwareEvent {
  final SoftwareModel software;
  final int index;
  UpdateSoftware({required this.software, required this.index});
}

class FetchSoftwareImage extends SoftwareEvent {
  String name;
  BuildContext? context;
  FetchSoftwareImage({required this.name, required this.context});
}

class SearchSoftware extends SoftwareEvent {
  String softwareName;
  SearchSoftware({required this.softwareName});
}

class SortSofware extends SoftwareEvent {
  String sort;
  SortSofware({required this.sort});
}
