import 'package:flutter/material.dart';
import 'package:dropzone_app/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.notificationsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _NotificationTile(
            title: localizations.notificationConfirmed,
            subtitle: localizations.notificationConfirmedBody,
          ),
          _NotificationTile(
            title: localizations.notificationDriverAssigned,
            subtitle: localizations.notificationDriverAssignedBody,
          ),
          _NotificationTile(
            title: localizations.notificationArriving,
            subtitle: localizations.notificationArrivingBody,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.notifications),
      ),
    );
  }
}
