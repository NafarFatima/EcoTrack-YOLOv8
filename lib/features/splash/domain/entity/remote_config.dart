class RemoteConfig {
  final bool isUnderMaintenance;
  final String minVersion;
  final String latestVersion;
  final String maintenanceMessage;

  RemoteConfig({
    required this.isUnderMaintenance,
    required this.minVersion,
    required this.latestVersion,
    required this.maintenanceMessage,
  });
}
