class Setting {
  final bool notificationsEnabled;
  final bool checkAtStartup;
  final bool notify30Days;
  final bool notify15Days;
  final bool notify7Days;
  final bool notify1Day;
  final bool notifyOnExpiration;
  final bool notifyExpired;

  Setting({
    required this.notificationsEnabled,
    required this.checkAtStartup,
    required this.notify30Days,
    required this.notify15Days,
    required this.notify7Days,
    required this.notify1Day,
    required this.notifyOnExpiration,
    required this.notifyExpired,
  });
}