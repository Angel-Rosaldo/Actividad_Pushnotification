import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/notifications/notification_service.dart';
import 'package:flutter_riverpod/legacy.dart';

// The NotificationService is initialized in main() and provided via override.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('notificationServiceProvider must be overridden in main');
});
final badgeCountProvider = StateProvider<int>((_) => 0);
