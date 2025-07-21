part of 'software_bloc.dart';

class SoftwareState extends Equatable {
  final List<SoftwareModel> software;
  final String? tempSoftwarePath;
  final String? tempIconPath;
  final bool launchSoftware;
  final String? sort;

  const SoftwareState({
    this.software = const [],
    this.tempSoftwarePath,
    this.tempIconPath,
    this.launchSoftware = false,
    this.sort,
  });

  SoftwareState copyWith({
    List<SoftwareModel>? software,
    String? tempSoftwarePath,
    String? tempIconPath,
    bool? launchSoftware,
    String? sort,
  }) {
    return SoftwareState(
      software: software ?? this.software,
      tempSoftwarePath: tempSoftwarePath ?? this.tempSoftwarePath,
      tempIconPath: tempIconPath ?? this.tempIconPath,
      launchSoftware: launchSoftware ?? this.launchSoftware,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    software,
    tempSoftwarePath,
    tempIconPath,
    launchSoftware,
    sort,
  ];
}

final class SoftwareInitial extends SoftwareState {}
