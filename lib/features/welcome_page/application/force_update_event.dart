abstract class ForceUpdateEvent {}

class CheckForceUpdateEvent extends ForceUpdateEvent {
  final String versionNumber;
  final String platformType;

  CheckForceUpdateEvent({required this.versionNumber,  required this.platformType});
}
